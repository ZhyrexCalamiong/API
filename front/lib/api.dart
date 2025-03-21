import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000'; 

  Future<Weather> fetchWeather(String location) async {
    final response = await http.get(Uri.parse('$baseUrl/weather/temperature?location=$location'));
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Cat> fetchCat() async {
    final response = await http.get(Uri.parse('$baseUrl/cat/name'));
    if (response.statusCode == 200) {
      return Cat.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load cat data');
    }
  }

  Future<Music> fetchMusic() async {
    final response = await http.get(Uri.parse('$baseUrl/music/song'));
    if (response.statusCode == 200) {
      return Music.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load music data');
    }
  }
}