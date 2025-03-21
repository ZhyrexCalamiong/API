import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String baseUrl = "http://127.0.0.1:5000";
  String? _weatherLocation = "Loading...";
  String? _temperature = "Loading...";
  String? _condition = "Loading...";
  String? _humidity = "Loading...";
  String? _wind = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchWeatherDetails();
  }

  Future<void> fetchWeatherDetails() async {
    _weatherLocation = await fetchData('$baseUrl/weather/location', 'location');
    _temperature = await fetchData('$baseUrl/weather/temperature', 'temperature_c');
    _condition = await fetchData('$baseUrl/weather/condition', 'condition');
    _humidity = await fetchData('$baseUrl/weather/humidity', 'humidity');
    _wind = await fetchData('$baseUrl/weather/wind', 'wind_kph');
    setState(() {});
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
    return Center(
      child: SizedBox(
        width: 300, // Fixed width for the Card
        child: Card(
          color: Colors.blueAccent,
          child: ListTile(
            title: Text(
              "Weather in $_weatherLocation",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Temp: $_temperature°C, $_condition\nHumidity: $_humidity%\nWind: $_wind kph",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}