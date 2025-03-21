import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final String baseUrl = "https://api-qaecn9m76-zhyrexcalamiongs-projects.vercel.app";
  String? _songTitle = "Loading...";
  String? _artistName = "Loading...";
  String? _songDuration = "Loading...";
  String? _songUrl; // URL of the song to play

  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance
  bool _isPlaying = false; // Track playback state

  @override
  void initState() {
    super.initState();
    fetchMusicDetails();
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Release resources when the widget is disposed
    super.dispose();
  }

  Future<void> fetchMusicDetails() async {
    // Fetch song details
    _songTitle = await fetchData('$baseUrl/music/song', 'title');
    _artistName = await fetchData('$baseUrl/music/artist', 'artist');
    _songDuration = await fetchData('$baseUrl/music/duration', 'duration');
    _songUrl = await fetchData('$baseUrl/music/url', 'url'); // Fetch song URL
    setState(() {});

    // Auto-play the song if a valid URL is fetched
    if (_songUrl != null && _songUrl!.startsWith("http")) {
      await _audioPlayer.play(UrlSource(_songUrl!));
      setState(() {
        _isPlaying = true;
      });
    }
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

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_songUrl != null && _songUrl!.startsWith("http")) {
        await _audioPlayer.play(UrlSource(_songUrl!));
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300, // Fixed width for the Card
        child: Card(
          color: Colors.green,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Random Music",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              ListTile(
                title: Text(
                  _songTitle ?? "Loading...",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  _artistName ?? "Loading...",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  "Duration: $_songDuration sec",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}