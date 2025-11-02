import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class WeatherScreen2 extends StatefulWidget {
  const WeatherScreen2({super.key});

  @override
  State<WeatherScreen2> createState() => _WeatherScreen2State();
}

class _WeatherScreen2State extends State<WeatherScreen2> {
  Position? geoPosition;

  String _kToC(double kelvin) {
    return (kelvin - 273.15).round().toString();
  }

  String _getWeatherIcon(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    geoPosition = await Geolocator.getCurrentPosition();

    getWeatheData();

    // print(geoPosition!.latitude);
    // print(geoPosition!.longitude);
  }

  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forcastMap;

  getWeatheData() async {
    try {
      setState(() {
        weatherMap = null;
        forcastMap = null;
      });
      const apiKey = '5cd327828db02dacbae1b8249f9bfd3c';
      var weatherResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${geoPosition!.latitude}&lon=${geoPosition!.longitude}&appid=$apiKey'));
      var weatherData = jsonDecode(weatherResponse.body);

      var forcastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${geoPosition!.latitude}&lon=${geoPosition!.longitude}&appid=$apiKey'));
      var forcastData = jsonDecode(forcastResponse.body);

      setState(() {
        weatherMap = Map.from(weatherData);
        forcastMap = Map.from(forcastData);
      });
    } catch (excepction) {
      print('Error fetching weather data: $excepction');
    }
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 30, 33, 64),
              Color.fromARGB(255, 58, 45, 77),
            ],
          ),
        ),
        child: weatherMap == null
            ? const Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 140, 122, 230)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    _buildLocationAndDate(),
                    const SizedBox(height: 30),
                    _buildMainWeather(),
                    const SizedBox(height: 40),
                    _buildDetailsGrid(),
                    const SizedBox(height: 40),
                    _buildHourlyForecast(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLocationAndDate() {
    final cityName = weatherMap!['name'].toString();

    final dt = weatherMap!['dt'] != null
        ? Jiffy.parseFromDateTime(
            DateTime.fromMillisecondsSinceEpoch(weatherMap!['dt'] * 1000))
        : Jiffy.parseFromDateTime(DateTime.now());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30),
            Text(
              cityName,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            IconButton(
                onPressed: () {
                  getWeatheData();
                },
                icon: Icon(Icons.refresh, size: 30))
          ],
        ),
        const SizedBox(height: 8),
        Text(
          dt.format(pattern: 'EEEE, MMMM do, h:mm a').toString(),
          style: const TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 189, 189, 189),
          ),
        ),
      ],
    );
  }

  Widget _buildMainWeather() {
    final tempKelvin = weatherMap!['main']['temp'].toDouble();
    final description =
        weatherMap!['weather'][0]['description'].toString().toUpperCase();
    final iconCode = weatherMap!['weather'][0]['icon'].toString();
    final tempCelsius = _kToC(tempKelvin);

    return Column(
      children: [
        Image.network(
          _getWeatherIcon(iconCode),
          height: 120,
          width: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.cloud,
            size: 120,
            color: Color.fromARGB(255, 140, 122, 230),
          ),
        ),
        Text(
          '$tempCelsius°C',
          style: const TextStyle(
            fontSize: 88,
            fontWeight: FontWeight.w200,
            color: Colors.white,
          ),
        ),
        Text(
          description,
          style: const TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 189, 189, 189),
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color.fromARGB(255, 140, 122, 230).withOpacity(0.3),
            width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weather Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Divider(
              thickness: 1,
              height: 25,
              color: Color.fromARGB(255, 59, 46, 78),
            ),
            _buildDetailRow(
              'Max Temp',
              '${_kToC(weatherMap!['main']['temp_max'].toDouble())}°C',
              Icons.arrow_upward,
              Colors.redAccent,
            ),
            _buildDetailRow(
                'Min Temp',
                '${_kToC(weatherMap!['main']['temp_min'].toDouble())}°C',
                Icons.arrow_downward,
                Colors.lightBlueAccent),
            _buildDetailRow('Humidity', '${weatherMap!['main']['humidity']}%',
                Icons.water_drop, Colors.cyanAccent),
            _buildDetailRow('Wind Speed', '${weatherMap!['wind']['speed']} m/s',
                Icons.air, Colors.greenAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(fontSize: 17, color: Colors.white70),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    final forecastList =
        forcastMap?['list'] is List ? forcastMap!['list'] : null;

    if (forecastList == null || forecastList.isEmpty) {
      return Container();
    }

    final hourlyData = forecastList.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            'Hourly Forecast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyData.length,
            itemBuilder: (context, index) {
              final item = hourlyData[index];
              final time = Jiffy.parseFromDateTime(
                  DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000));
              final temp = _kToC(item['main']['temp'].toDouble());
              final iconCode = item['weather'][0]['icon'].toString();

              return Container(
                width: 90,
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 140, 122, 230).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color.fromARGB(255, 140, 122, 230)
                          .withOpacity(0.2),
                      width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      time.format(pattern: 'h a'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    Image.network(
                      _getWeatherIcon(iconCode),
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.refresh,
                          color: Color.fromARGB(255, 140, 122, 230)),
                    ),
                    Text(
                      '$temp°C',
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
