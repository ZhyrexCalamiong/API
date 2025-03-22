import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String baseUrl = "https://api-zhyrexcalamiongs-projects.vercel.app/";
  String? _weatherLocation = "Loading...";
  String? _temperature = "--";
  String? _condition = "--";
  String? _humidity = "--";
  String? _wind = "--";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWeatherDetails();
  }

  Future<void> fetchWeatherDetails() async {
    setState(() => _isLoading = true);
    _weatherLocation = await fetchData('$baseUrl/weather/location', 'location');
    _temperature =
        await fetchData('$baseUrl/weather/temperature', 'temperature_c');
    _condition = await fetchData('$baseUrl/weather/condition', 'condition');
    _humidity = await fetchData('$baseUrl/weather/humidity', 'humidity');
    _wind = await fetchData('$baseUrl/weather/wind', 'wind_kph');
    setState(() => _isLoading = false);
  }

  Future<String?> fetchData(String url, String key) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[key]?.toString() ?? "N/A";
      }
      return "N/A";
    } catch (e) {
      return "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade300],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Weather in $_weatherLocation",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "$_temperature°C",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Icon(
                      FontAwesomeIcons.cloudSun,
                      size: 50,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$_condition",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(FontAwesomeIcons.tint, color: Colors.white),
                            SizedBox(height: 5),
                            Text("$_humidity%",
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                        Column(
                          children: [
                            Icon(FontAwesomeIcons.wind, color: Colors.white),
                            SizedBox(height: 5),
                            Text("$_wind kph",
                                style: TextStyle(color: Colors.white))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: fetchWeatherDetails,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isLoading ? Colors.white38 : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.blueAccent)
                      : Icon(FontAwesomeIcons.syncAlt,
                          color: Colors.blue, size: 24),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
