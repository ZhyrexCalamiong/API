import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class CatScreen extends StatefulWidget {
  @override
  _CatScreenState createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  final String baseUrl = "https://api-zhyrexcalamiongs-projects.vercel.app/";
  String? _catName = "Loading...";
  String? _catOrigin = "Loading...";
  String? _catImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCatDetails();
  }

  Future<void> fetchCatDetails() async {
    setState(() => _isLoading = true);
    _catName = await fetchData('$baseUrl/cat/name', 'name');
    _catOrigin = await fetchData('$baseUrl/cat/origin', 'origin');
    _catImageUrl = await fetchData('$baseUrl/cat/image', 'image');
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
            colors: [Colors.deepPurple.shade900, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Meet Your Cat!",
                style: GoogleFonts.pacifico(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
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
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: _catImageUrl != null &&
                              _catImageUrl!.startsWith("http")
                          ? Image.network(_catImageUrl!,
                              height: 200, fit: BoxFit.cover)
                          : Container(
                              height: 200,
                              width: 250,
                              color: Colors.grey,
                              child: Center(
                                child: Text("No Image Available",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _catName!,
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Origin: $_catOrigin",
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: fetchCatDetails,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isLoading ? Colors.white38 : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.purpleAccent)
                      : Icon(Icons.refresh, color: Colors.purple, size: 28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
