import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CatScreen extends StatefulWidget {
  @override
  _CatScreenState createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  final String baseUrl = "https://api-qaecn9m76-zhyrexcalamiongs-projects.vercel.app";
  String? _catName = "Loading...";
  String? _catOrigin = "Loading...";
  String? _catImageUrl;

  @override
  void initState() {
    super.initState();
    fetchCatDetails();
  }

  Future<void> fetchCatDetails() async {
    _catName = await fetchData('$baseUrl/cat/name', 'name');
    _catOrigin = await fetchData('$baseUrl/cat/origin', 'origin');
    _catImageUrl = await fetchData('$baseUrl/cat/image', 'image');
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
          color: Colors.purple,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _catImageUrl != null && _catImageUrl!.startsWith("http")
                  ? Image.network(_catImageUrl!, height: 200, fit: BoxFit.cover)
                  : Container(
                      height: 200,
                      color: Colors.grey,
                      child: Center(child: Text("No Image Available", style: TextStyle(color: Colors.white))),
                ),
              ListTile(
                title: Text(
                  "Cat: $_catName",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Origin: $_catOrigin",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}