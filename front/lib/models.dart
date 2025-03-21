class Weather {
  final String? location;
  final double? temperature;
  final String? condition;
  final int? humidity;
  final double? wind;

  Weather({
    this.location,
    this.temperature,
    this.condition,
    this.humidity,
    this.wind,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json['location'] as String?,
      temperature: json['temperature_c'] as double?,
      condition: json['condition'] as String?,
      humidity: json['humidity'] as int?,
      wind: json['wind_kph'] as double?,
    );
  }
}
class Music {
  final String? title;
  final String? artist;
  final int? duration;

  Music({
    this.title,
    this.artist,
    this.duration,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      title: json['title'] as String?,
      artist: json['artist'] as String?,
      duration: json['duration'] as int?,
    );
  }
}
class Cat {
  final String? name;
  final String? origin;
  final String? imageUrl;

  Cat({
    this.name,
    this.origin,
    this.imageUrl,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      name: json['name'] as String?,
      origin: json['origin'] as String?,
      imageUrl: json['image'] as String?,
    );
  }
}