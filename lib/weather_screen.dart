import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weatherapp/additional_data.dart';
import 'package:weatherapp/hourly_forecast.dart';
import 'package:weatherapp/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
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
              print("Refresh");
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError){
            return Center(child: Text("Error: ${snapshot.error}"));
          }
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
                                "0 K",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Icon(Icons.cloud, size: 64),
                              const SizedBox(height: 16),
                              const Text(
                                "Rain",
                                style: TextStyle(fontSize: 20),
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
                  "Weather Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourlyForecast(
                        icon: Icons.cloud,
                        time: "03:00",
                        temp: "295 K",
                      ),
                      HourlyForecast(
                        icon: Icons.thunderstorm,
                        time: "06:00",
                        temp: "292 K",
                      ),
                      HourlyForecast(
                        icon: Icons.sunny,
                        time: "09:00",
                        temp: "298 K",
                      ),
                      HourlyForecast(
                        icon: Icons.cloud,
                        time: "12:00",
                        temp: "301 K",
                      ),
                      HourlyForecast(
                        icon: Icons.thunderstorm,
                        time: "15:00",
                        temp: "303 K",
                      ),
                    ],
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
                        value: "80%",
                      ),
                      AdditionalData(
                        icon: Icons.air,
                        label: "Wind Speed",
                        value: "15 km/h",
                      ),
                      AdditionalData(
                        icon: Icons.thermostat,
                        label: "Pressure",
                        value: "1013 hPa",
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
