import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/additional_data.dart';
import 'package:weatherapp/hourly_forecast.dart';
import 'package:weatherapp/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>?> weather;
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  Future<Map<String, dynamic>?> getCurrentWeather() async {
    try {
      String city = "Bhīmavaram,IN";
      final res = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$openweatherAPI',
        ),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "Unexpected error occurred";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final data = snapshot.data!;
          final currentWeatherdata = data['list'][0];
          final curtemp = currentWeatherdata['main']['temp'];
          final currentSky = currentWeatherdata['weather'][0]['main'];
          final humidity = currentWeatherdata['main']['humidity'];
          final windSpeed = currentWeatherdata['wind']['speed'];
          final pressure = currentWeatherdata['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //main card
                SizedBox(
                  width: double.infinity,

                  child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(10),
                      ),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),

                          child: Column(
                            children: [
                              Text(
                                "$curtemp K",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky == "Clouds" || currentSky == "Rain"
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "$currentSky",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final time = DateTime.parse(
                        data['list'][index + 1]['dt_txt'],
                      );
                      return HourlyForecast(
                        time: DateFormat('j').format(time),
                        temp: data['list'][index + 1]['main']['temp']
                            .toString(),
                        icon:
                            data['list'][index + 1]['weather'][0]['main'] ==
                                    "Clouds" ||
                                data['list'][index + 1]['weather'][0]['main'] ==
                                    "Rain"
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                    scrollDirection: Axis.horizontal,

                    shrinkWrap: true,
                  ),
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalData(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: "$humidity %",
                      ),
                      AdditionalData(
                        icon: Icons.air,
                        label: "Wind Speed",
                        value: "$windSpeed m/s",
                      ),
                      AdditionalData(
                        icon: Icons.thermostat,
                        label: "Pressure",
                        value: "$pressure hPa",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
