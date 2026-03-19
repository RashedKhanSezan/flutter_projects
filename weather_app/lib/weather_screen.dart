import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_information_item.dart';
import 'package:weather_app/hourly_forcast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late double temp = 0;
  late Future<Map<String, dynamic>> finalWeather;

  Future<Map<String, dynamic>> getWeather() async {
    print('future start');
    try {
      print('tryy start');
      String cityName = 'London';
      final weatherResponse = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey'),
      );

      final weatherData = jsonDecode(weatherResponse.body);

      if (weatherData['cod'] != '200') {
        throw 'An unexpected error occur';
      }
      print('try end');
      return weatherData;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalWeather = getWeather();
  }

  void onTap() {
    setState(() {
      finalWeather = getWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(' builder');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              onTap();
            },
            icon: const Icon(Icons.refresh),
          )
        ], // Added this
      ),
      body: FutureBuilder(
        future: finalWeather,
        builder: (context, snapshot) {
          print('Future builder');
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting for progress indi');
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
            );
          }

          final wData = snapshot.data!;
          final currentData = wData['list'][0];
          final currentWeatherTemp = currentData['main']['temp'];
          final currentWeatherSky = currentData['weather'][0]['main'];
          final currentHumidity = currentData['main']['humidity'];
          final currentWind = currentData['wind']['speed'];
          final currentpressure = currentData['main']['pressure'];
          print('showin screen');
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                '$currentWeatherTemp K',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currentWeatherSky == 'Clouds' ||
                                        currentWeatherSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                currentWeatherSky,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 1; i < 6; i++)
                //         HourlyForcastItem(
                //           weatherTime: wData['list'][i]['dt'].toString(),
                //           weatherIcon: wData['list'][i]['weather'][0]['main'] ==
                //                       'Clouds' ||
                //                   wData['list'][i]['weather'][0]['main'] ==
                //                       'Rain'
                //               ? Icons.cloud
                //               : Icons.sunny_snowing,
                //           weatherValue:
                //               wData['list'][i]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final time =
                          DateTime.parse(wData['list'][index + 1]['dt_txt']);

                      return HourlyForcastItem(
                        weatherTime: DateFormat.Hm().format(time),
                        weatherIcon: wData['list'][index + 1]['weather'][0]
                                        ['main'] ==
                                    'Clouds' ||
                                wData['list'][index + 1]['weather'][0]
                                        ['main'] ==
                                    'Rain'
                            ? Icons.cloud
                            : Icons.sunny_snowing,
                        weatherValue:
                            wData['list'][index + 1]['main']['temp'].toString(),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Additional Information',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformationItem(
                      icon: Icons.water_drop,
                      weather: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInformationItem(
                      icon: Icons.wind_power,
                      weather: 'Wind Speed',
                      value: currentWind.toString(),
                    ),
                    AdditionalInformationItem(
                      icon: Icons.power_input_outlined,
                      weather: 'Presser',
                      value: currentpressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
