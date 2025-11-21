import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Position? geoPosition;

  String _getWeatherIcon(String url) {
    return "https:${url}";
  }

  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forcastMap;

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
  }

  getWeatheData() async {
    try {
      setState(() {
        weatherMap = null;
        forcastMap = null;
      });

      const apiKey = '39d83cb93601434bab3111847252410';

      var weatherResponse = await http.get(Uri.parse(
          'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=${geoPosition!.latitude},${geoPosition!.longitude}&aqi=no'));

      var forcastResponse = await http.get(Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=${geoPosition!.latitude},${geoPosition!.longitude}&days=5&aqi=no&alerts=no'));

      var weatherData = jsonDecode(weatherResponse.body);
      var forcastData = jsonDecode(forcastResponse.body);

      setState(() {
        weatherMap = Map.from(weatherData);
        forcastMap = Map.from(forcastData);
      });

      print(weatherData);
    } catch (exception) {
      print('Error fetching weather data: $exception');
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
      body: weatherMap == null || forcastMap == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
                strokeWidth: 3,
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 28, 57, 109),
                    Color.fromARGB(255, 42, 82, 152),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        weatherMap!['location']['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Jiffy.parseFromDateTime(DateTime.parse(
                                weatherMap!['location']['localtime']))
                            .format(pattern: 'd/M/y  hh:mm a'),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        surfaceTintColor:
                            const Color.fromARGB(17, 255, 255, 255),
                        shadowColor: const Color.fromARGB(17, 255, 255, 255),
                        color: const Color.fromARGB(17, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 100),
                          child: Column(
                            children: [
                              Image.network(
                                _getWeatherIcon(weatherMap!['current']
                                    ['condition']['icon']),
                                width: 120,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                weatherMap!['current']['condition']['text'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "${weatherMap!['current']['temp_c'].round()}°C",
                                style: const TextStyle(
                                  fontSize: 54,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Feels like ${weatherMap!['current']['feelslike_c'].round()}°C",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _infoTile(Icons.water_drop, "Humidity",
                              "${weatherMap!['current']['humidity']}%"),
                          _infoTile(Icons.air, "Wind",
                              "${weatherMap!['current']['wind_kph']} km/h"),
                          _infoTile(Icons.visibility, "Visibility",
                              "${weatherMap!['current']['vis_km']} km"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _infoTile(
                            Icons.wb_sunny_outlined,
                            "Sunrise",
                            forcastMap!['forecast']['forecastday'][0]['astro']
                                ['sunrise'],
                          ),
                          _infoTile(
                            Icons.nights_stay_outlined,
                            "Sunset",
                            forcastMap!['forecast']['forecastday'][0]['astro']
                                ['sunset'],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "5 - Day Forecast",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 320,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount:
                              forcastMap!['forecast']['forecastday'].length,
                          itemBuilder: (context, index) {
                            var item =
                                forcastMap!['forecast']['forecastday'][index];
                            var date = item['date'];
                            var icon = item['day']['condition']['icon'];
                            var temp = item['day']['avgtemp_c'];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(34, 255, 255, 255),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(17, 255, 255, 255),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    Jiffy.parseFromDateTime(
                                            DateTime.parse(date))
                                        .format(pattern: 'EEE, d MMM'),
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                  Image.network(
                                    _getWeatherIcon(icon),
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text(
                                    "${temp.round()}°C",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 35),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
