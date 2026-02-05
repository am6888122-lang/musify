import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';
import '../models/playlist.dart';
import '../constants/app_constants.dart';

class ApiService {
  static const String _baseUrl = AppConstants.baseUrl;
  static const String _apiKey = AppConstants.apiKey;

  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_apiKey',
  };

  // Mock data for development - using reliable audio URLs
  static final List<Song> _mockSongs = [
    // Pop Songs
    Song(
      id: '1',
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      album: 'After Hours',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c06f0e8b33c6e8a8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3',
      duration: const Duration(minutes: 3, seconds: 20),
      genre: 'Pop',
      releaseYear: 2020,
    ),
    Song(
      id: '2',
      title: 'Shape of You',
      artist: 'Ed Sheeran',
      album: '÷ (Divide)',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/soundtrack.mp3',
      duration: const Duration(minutes: 3, seconds: 53),
      genre: 'Pop',
      releaseYear: 2017,
    ),
    Song(
      id: '3',
      title: 'Levitating',
      artist: 'Dua Lipa',
      album: 'Future Nostalgia',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273d8b9b8c8b8c8b8c8b8c8b8c8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Sevish_-__nbsp_.mp3',
      duration: const Duration(minutes: 3, seconds: 23),
      genre: 'Pop',
      releaseYear: 2020,
    ),
    Song(
      id: '4',
      title: 'Anti-Hero',
      artist: 'Taylor Swift',
      album: 'Midnights',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/race2.ogg',
      duration: const Duration(minutes: 3, seconds: 20),
      genre: 'Pop',
      releaseYear: 2022,
    ),
    Song(
      id: '5',
      title: 'Watermelon Sugar',
      artist: 'Harry Styles',
      album: 'Fine Line',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273adaeba4b8b8c8b8c8b8c8b8c',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/menu.ogg',
      duration: const Duration(minutes: 2, seconds: 54),
      genre: 'Pop',
      releaseYear: 2020,
    ),
    
    // Romantic Songs
    Song(
      id: '6',
      title: 'Someone Like You',
      artist: 'Adele',
      album: '21',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273372eb33d3277c1ca2ec0b8b9',
      audioUrl: 'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3',
      duration: const Duration(minutes: 4, seconds: 45),
      genre: 'Romantic',
      releaseYear: 2011,
    ),
    Song(
      id: '7',
      title: 'Perfect',
      artist: 'Ed Sheeran',
      album: '÷ (Divide)',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-assets/week7-button.m4a',
      duration: const Duration(minutes: 4, seconds: 23),
      genre: 'Romantic',
      releaseYear: 2017,
    ),
    Song(
      id: '8',
      title: 'All of Me',
      artist: 'John Legend',
      album: 'Love in the Future',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/pyman_assets/thebeat.ogg',
      duration: const Duration(minutes: 4, seconds: 29),
      genre: 'Romantic',
      releaseYear: 2013,
    ),
    Song(
      id: '9',
      title: 'Thinking Out Loud',
      artist: 'Ed Sheeran',
      album: 'x (Multiply)',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/fx/engine-1.ogg',
      duration: const Duration(minutes: 4, seconds: 41),
      genre: 'Romantic',
      releaseYear: 2014,
    ),
    Song(
      id: '10',
      title: 'A Thousand Years',
      artist: 'Christina Perri',
      album: 'The Twilight Saga',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273b8c8b8c8b8c8b8c8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-assets/week7-brrring.m4a',
      duration: const Duration(minutes: 4, seconds: 45),
      genre: 'Romantic',
      releaseYear: 2011,
    ),
    
    // Hip Hop / Rap
    Song(
      id: '11',
      title: 'God\'s Plan',
      artist: 'Drake',
      album: 'Scorpion',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273f8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Sevish_-__nbsp_.mp3',
      duration: const Duration(minutes: 3, seconds: 18),
      genre: 'Hip Hop',
      releaseYear: 2018,
    ),
    Song(
      id: '12',
      title: 'HUMBLE.',
      artist: 'Kendrick Lamar',
      album: 'DAMN.',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/race1.ogg',
      duration: const Duration(minutes: 2, seconds: 57),
      genre: 'Hip Hop',
      releaseYear: 2017,
    ),
    Song(
      id: '13',
      title: 'Sicko Mode',
      artist: 'Travis Scott',
      album: 'Astroworld',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273d8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/pyman_assets/ateapill.ogg',
      duration: const Duration(minutes: 5, seconds: 12),
      genre: 'Hip Hop',
      releaseYear: 2018,
    ),
    Song(
      id: '14',
      title: 'Rockstar',
      artist: 'Post Malone ft. 21 Savage',
      album: 'Beerbongs & Bentleys',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/lose.ogg',
      duration: const Duration(minutes: 3, seconds: 38),
      genre: 'Hip Hop',
      releaseYear: 2017,
    ),
    
    // Alternative / Indie
    Song(
      id: '15',
      title: 'Bad Guy',
      artist: 'Billie Eilish',
      album: 'When We All Fall Asleep',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273a8b98a42d3e6b8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/menu.ogg',
      duration: const Duration(minutes: 3, seconds: 14),
      genre: 'Alternative',
      releaseYear: 2019,
    ),
    Song(
      id: '16',
      title: 'Bury a Friend',
      artist: 'Billie Eilish',
      album: 'When We All Fall Asleep',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273b8c8b8c8b8c8b8c8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/pyman_assets/eategg.ogg',
      duration: const Duration(minutes: 3, seconds: 13),
      genre: 'Alternative',
      releaseYear: 2019,
    ),
    Song(
      id: '17',
      title: 'Stressed Out',
      artist: 'Twenty One Pilots',
      album: 'Blurryface',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/soundtrack.mp3',
      duration: const Duration(minutes: 3, seconds: 22),
      genre: 'Alternative',
      releaseYear: 2015,
    ),
    
    // Rock
    Song(
      id: '18',
      title: 'Bohemian Rhapsody',
      artist: 'Queen',
      album: 'A Night at the Opera',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273d8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3',
      duration: const Duration(minutes: 5, seconds: 55),
      genre: 'Rock',
      releaseYear: 1975,
    ),
    Song(
      id: '19',
      title: 'Sweet Child O\' Mine',
      artist: 'Guns N\' Roses',
      album: 'Appetite for Destruction',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/race2.ogg',
      duration: const Duration(minutes: 5, seconds: 56),
      genre: 'Rock',
      releaseYear: 1987,
    ),
    Song(
      id: '20',
      title: 'Smells Like Teen Spirit',
      artist: 'Nirvana',
      album: 'Nevermind',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273b8c8b8c8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/race1.ogg',
      duration: const Duration(minutes: 5, seconds: 1),
      genre: 'Rock',
      releaseYear: 1991,
    ),
    
    // Electronic / Dance
    Song(
      id: '21',
      title: 'Wake Me Up',
      artist: 'Avicii',
      album: 'True',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/pyman_assets/thebeat.ogg',
      duration: const Duration(minutes: 4, seconds: 9),
      genre: 'Electronic',
      releaseYear: 2013,
    ),
    Song(
      id: '22',
      title: 'Titanium',
      artist: 'David Guetta ft. Sia',
      album: 'Nothing but the Beat',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273d8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Sevish_-__nbsp_.mp3',
      duration: const Duration(minutes: 4, seconds: 5),
      genre: 'Electronic',
      releaseYear: 2011,
    ),
    Song(
      id: '23',
      title: 'Closer',
      artist: 'The Chainsmokers ft. Halsey',
      album: 'Collage',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/menu.ogg',
      duration: const Duration(minutes: 4, seconds: 4),
      genre: 'Electronic',
      releaseYear: 2016,
    ),
    
    // R&B / Soul
    Song(
      id: '24',
      title: 'Redbone',
      artist: 'Childish Gambino',
      album: 'Awaken, My Love!',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273b8c8b8c8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3',
      duration: const Duration(minutes: 5, seconds: 26),
      genre: 'R&B',
      releaseYear: 2016,
    ),
    Song(
      id: '25',
      title: 'Earned It',
      artist: 'The Weeknd',
      album: 'Beauty Behind the Madness',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-assets/week7-button.m4a',
      duration: const Duration(minutes: 4, seconds: 37),
      genre: 'R&B',
      releaseYear: 2015,
    ),
    Song(
      id: '26',
      title: 'No Tears Left to Cry',
      artist: 'Ariana Grande',
      album: 'Sweetener',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273d8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/pyman_assets/ateapill.ogg',
      duration: const Duration(minutes: 3, seconds: 25),
      genre: 'R&B',
      releaseYear: 2018,
    ),
    
    // Latin / Reggaeton
    Song(
      id: '27',
      title: 'Despacito',
      artist: 'Luis Fonsi ft. Daddy Yankee',
      album: 'Vida',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/race2.ogg',
      duration: const Duration(minutes: 3, seconds: 47),
      genre: 'Latin',
      releaseYear: 2017,
    ),
    Song(
      id: '28',
      title: 'Mi Gente',
      artist: 'J Balvin & Willy William',
      album: 'Vibras',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273b8c8b8c8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/pyman_assets/thebeat.ogg',
      duration: const Duration(minutes: 3, seconds: 9),
      genre: 'Latin',
      releaseYear: 2017,
    ),
    Song(
      id: '29',
      title: 'Taki Taki',
      artist: 'DJ Snake ft. Selena Gomez',
      album: 'Carte Blanche',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Sevish_-__nbsp_.mp3',
      duration: const Duration(minutes: 3, seconds: 32),
      genre: 'Latin',
      releaseYear: 2018,
    ),
    
    // Country
    Song(
      id: '30',
      title: 'Meant to Be',
      artist: 'Bebe Rexha ft. Florida Georgia Line',
      album: 'Expectations',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273d8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/soundtrack.mp3',
      duration: const Duration(minutes: 2, seconds: 43),
      genre: 'Country',
      releaseYear: 2017,
    ),
    Song(
      id: '31',
      title: 'Die a Happy Man',
      artist: 'Thomas Rhett',
      album: 'Tangled Up',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/menu.ogg',
      duration: const Duration(minutes: 3, seconds: 48),
      genre: 'Country',
      releaseYear: 2015,
    ),
    
    // Jazz
    Song(
      id: '32',
      title: 'Fly Me to the Moon',
      artist: 'Frank Sinatra',
      album: 'It Might as Well Be Swing',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273b8c8b8c8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3',
      duration: const Duration(minutes: 2, seconds: 29),
      genre: 'Jazz',
      releaseYear: 1964,
    ),
    Song(
      id: '33',
      title: 'What a Wonderful World',
      artist: 'Louis Armstrong',
      album: 'What a Wonderful World',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-assets/week7-brrring.m4a',
      duration: const Duration(minutes: 2, seconds: 21),
      genre: 'Jazz',
      releaseYear: 1967,
    ),
    
    // Classical
    Song(
      id: '34',
      title: 'Für Elise',
      artist: 'Ludwig van Beethoven',
      album: 'Classical Masterpieces',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273d8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/pyman_assets/eategg.ogg',
      duration: const Duration(minutes: 2, seconds: 54),
      genre: 'Classical',
      releaseYear: 1810,
    ),
    Song(
      id: '35',
      title: 'Moonlight Sonata',
      artist: 'Ludwig van Beethoven',
      album: 'Piano Sonatas',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e8b8c8b8c8b8c8b8c8b8c8b8',
      audioUrl: 'https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/lose.ogg',
      duration: const Duration(minutes: 5, seconds: 30),
      genre: 'Classical',
      releaseYear: 1801,
    ),
  ];

  static final List<Playlist> _mockPlaylists = [
    Playlist(
      id: '1',
      name: 'Top Hits 2024',
      description: 'The biggest hits of 2024',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c06f0e8b33c6e8a8c8b8c8b8',
      songIds: ['1', '2', '3', '4', '5'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
      isPublic: true,
    ),
    Playlist(
      id: '2',
      name: 'Romantic Vibes ❤️',
      description: 'Love songs for every mood',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96',
      songIds: ['6', '7', '8', '9', '10'],
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now(),
      isPublic: true,
    ),
    Playlist(
      id: '3',
      name: 'Hip Hop Essentials 🔥',
      description: 'The best rap and hip hop tracks',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273f8b8c8b8c8b8c8b8c8b8c8b8',
      songIds: ['11', '12', '13', '14'],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
      isPublic: true,
    ),
    Playlist(
      id: '4',
      name: 'Rock Legends 🎸',
      description: 'Classic and modern rock anthems',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273d8b8c8b8c8b8c8b8c8b8c8b8',
      songIds: ['18', '19', '20'],
      createdAt: DateTime.now().subtract(const Duration(days: 18)),
      updatedAt: DateTime.now(),
      isPublic: true,
    ),
    Playlist(
      id: '5',
      name: 'Electronic Dance 💃',
      description: 'EDM and dance music to get you moving',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c8b8c8b8c8b8c8b8c8b8c8b8',
      songIds: ['21', '22', '23'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
      isPublic: true,
    ),
    Playlist(
      id: '6',
      name: 'R&B Soul 🎵',
      description: 'Smooth R&B and soul tracks',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273b8c8c8b8c8b8c8b8c8b8c8b8',
      songIds: ['24', '25', '26'],
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      updatedAt: DateTime.now(),
      isPublic: true,
    ),
    Playlist(
      id: '7',
      name: 'Latin Hits 🌴',
      description: 'Hot Latin and Reggaeton tracks',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e8b8c8b8c8b8c8b8c8b8c8b8',
      songIds: ['27', '28', '29'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
      isPublic: true,
    ),
    Playlist(
      id: '8',
      name: 'Alternative Indie 🎧',
      description: 'Alternative and indie music',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273a8b98a42d3e6b8b8c8b8c8b8',
      songIds: ['15', '16', '17'],
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      updatedAt: DateTime.now(),
      isPublic: true,
    ),
    Playlist(
      id: '9',
      name: 'Chill & Relax 😌',
      description: 'Relaxing songs for any mood',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273d8b8c8b8c8b8c8b8c8b8c8b8',
      songIds: ['6', '8', '10', '32', '33'],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now(),
      isPublic: true,
    ),
    Playlist(
      id: '10',
      name: 'Workout Mix 💪',
      description: 'High energy songs for your workout',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c8b8c8b8c8b8c8b8c8b8c8b8',
      songIds: ['1', '11', '13', '21', '22'],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
      isPublic: true,
    ),
  ];

  // Songs API
  static Future<List<Song>> getTrendingSongs() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    // Return top 10 trending songs
    return _mockSongs.take(10).toList();
  }

  static Future<List<Song>> getPopularSongs() async {
    await Future.delayed(const Duration(seconds: 1));
    // Return popular songs (mix of different genres)
    return [
      _mockSongs[0], // Blinding Lights
      _mockSongs[5], // Someone Like You
      _mockSongs[10], // God's Plan
      _mockSongs[17], // Bohemian Rhapsody
      _mockSongs[20], // Wake Me Up
      _mockSongs[26], // Despacito
      _mockSongs[1], // Shape of You
      _mockSongs[14], // Bad Guy
    ];
  }

  static Future<List<Song>> getNewReleases() async {
    await Future.delayed(const Duration(seconds: 1));
    // Return songs from 2015 onwards
    return _mockSongs.where((song) => song.releaseYear >= 2015).toList();
  }

  static Future<List<Song>> getAllSongs() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockSongs;
  }

  static Future<Song?> getSongById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockSongs.firstWhere((song) => song.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<List<Song>> searchSongs(String query) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (query.isEmpty) return [];
    
    final lowercaseQuery = query.toLowerCase();
    return _mockSongs.where((song) {
      return song.title.toLowerCase().contains(lowercaseQuery) ||
             song.artist.toLowerCase().contains(lowercaseQuery) ||
             song.album.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Playlists API
  static Future<List<Playlist>> getFeaturedPlaylists() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockPlaylists;
  }

  static Future<Playlist?> getPlaylistById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockPlaylists.firstWhere((playlist) => playlist.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<List<Song>> getPlaylistSongs(String playlistId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final playlist = await getPlaylistById(playlistId);
    if (playlist == null) return [];
    
    return _mockSongs.where((song) => playlist.songIds.contains(song.id)).toList();
  }

  // Recommendations API
  static Future<List<Song>> getRecommendations({String? genre, String? artistId}) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (genre != null) {
      return _mockSongs.where((song) => song.genre.toLowerCase() == genre.toLowerCase()).toList();
    }
    
    // Return random recommendations
    final shuffled = List<Song>.from(_mockSongs)..shuffle();
    return shuffled.take(3).toList();
  }

  // User API (Mock)
  static Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock successful login
    return {
      'success': true,
      'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': 'user_1',
        'name': 'John Doe',
        'email': email,
        'profileImageUrl': 'https://i.pravatar.cc/150?img=1',
        'createdAt': DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
        'favoriteGenres': ['Pop', 'Rock'],
        'isPremium': false,
      }
    };
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock successful registration
    return {
      'success': true,
      'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'name': name,
        'email': email,
        'profileImageUrl': 'https://i.pravatar.cc/150?img=2',
        'createdAt': DateTime.now().toIso8601String(),
        'favoriteGenres': [],
        'isPremium': false,
      }
    };
  }

  // Helper method to handle HTTP requests (for future real API integration)
  // Currently unused but kept for future API integration
  // ignore: unused_element
  static Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    
    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(uri, headers: _headers);
      case 'POST':
        return await http.post(
          uri,
          headers: _headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return await http.put(
          uri,
          headers: _headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return await http.delete(uri, headers: _headers);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }
}