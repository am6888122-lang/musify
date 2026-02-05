import 'package:hive/hive.dart';

part 'song.g.dart';

@HiveType(typeId: 0)
class Song extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String artist;
  
  @HiveField(3)
  final String album;
  
  @HiveField(4)
  final String imageUrl;
  
  @HiveField(5)
  final String audioUrl;
  
  @HiveField(6)
  final Duration duration;
  
  @HiveField(7)
  final String genre;
  
  @HiveField(8)
  final int releaseYear;
  
  @HiveField(9)
  final bool isFavorite;
  
  @HiveField(10)
  final int playCount;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.audioUrl,
    required this.duration,
    this.genre = '',
    this.releaseYear = 0,
    this.isFavorite = false,
    this.playCount = 0,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      album: json['album'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      duration: Duration(seconds: json['duration'] ?? 0),
      genre: json['genre'] ?? '',
      releaseYear: json['releaseYear'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      playCount: json['playCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'duration': duration.inSeconds,
      'genre': genre,
      'releaseYear': releaseYear,
      'isFavorite': isFavorite,
      'playCount': playCount,
    };
  }

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? imageUrl,
    String? audioUrl,
    Duration? duration,
    String? genre,
    int? releaseYear,
    bool? isFavorite,
    int? playCount,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      genre: genre ?? this.genre,
      releaseYear: releaseYear ?? this.releaseYear,
      isFavorite: isFavorite ?? this.isFavorite,
      playCount: playCount ?? this.playCount,
    );
  }

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist: $artist, album: $album)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Song && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}