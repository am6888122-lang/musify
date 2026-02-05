import 'package:flutter_test/flutter_test.dart';
import 'package:musify/core/models/song.dart';
import 'package:musify/core/models/playlist.dart';
import 'package:musify/core/models/user.dart';

void main() {
  group('Song Model Tests', () {
    test('Song creation and properties', () {
      final song = Song(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        imageUrl: 'https://example.com/image.jpg',
        audioUrl: 'https://example.com/audio.mp3',
        duration: const Duration(minutes: 3, seconds: 30),
        genre: 'Pop',
        releaseYear: 2024,
      );

      expect(song.id, '1');
      expect(song.title, 'Test Song');
      expect(song.artist, 'Test Artist');
      expect(song.album, 'Test Album');
      expect(song.duration.inSeconds, 210);
      expect(song.genre, 'Pop');
      expect(song.releaseYear, 2024);
      expect(song.isFavorite, false);
      expect(song.playCount, 0);
    });

    test('Song copyWith method', () {
      final song = Song(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        imageUrl: 'https://example.com/image.jpg',
        audioUrl: 'https://example.com/audio.mp3',
        duration: const Duration(minutes: 3, seconds: 30),
      );

      final updatedSong = song.copyWith(
        title: 'Updated Song',
        isFavorite: true,
        playCount: 5,
      );

      expect(updatedSong.id, '1');
      expect(updatedSong.title, 'Updated Song');
      expect(updatedSong.artist, 'Test Artist');
      expect(updatedSong.isFavorite, true);
      expect(updatedSong.playCount, 5);
    });

    test('Song equality', () {
      final song1 = Song(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        imageUrl: 'https://example.com/image.jpg',
        audioUrl: 'https://example.com/audio.mp3',
        duration: const Duration(minutes: 3, seconds: 30),
      );

      final song2 = Song(
        id: '1',
        title: 'Different Title',
        artist: 'Different Artist',
        album: 'Different Album',
        imageUrl: 'https://example.com/different.jpg',
        audioUrl: 'https://example.com/different.mp3',
        duration: const Duration(minutes: 4, seconds: 0),
      );

      final song3 = Song(
        id: '2',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        imageUrl: 'https://example.com/image.jpg',
        audioUrl: 'https://example.com/audio.mp3',
        duration: const Duration(minutes: 3, seconds: 30),
      );

      expect(song1, equals(song2)); // Same ID
      expect(song1, isNot(equals(song3))); // Different ID
    });
  });

  group('Playlist Model Tests', () {
    test('Playlist creation and properties', () {
      final now = DateTime.now();
      final playlist = Playlist(
        id: '1',
        name: 'Test Playlist',
        description: 'A test playlist',
        songIds: ['song1', 'song2', 'song3'],
        createdAt: now,
        updatedAt: now,
        isPublic: true,
      );

      expect(playlist.id, '1');
      expect(playlist.name, 'Test Playlist');
      expect(playlist.description, 'A test playlist');
      expect(playlist.songIds.length, 3);
      expect(playlist.songCount, 3);
      expect(playlist.isPublic, true);
      expect(playlist.createdAt, now);
      expect(playlist.updatedAt, now);
    });

    test('Playlist copyWith method', () {
      final now = DateTime.now();
      final playlist = Playlist(
        id: '1',
        name: 'Test Playlist',
        description: 'A test playlist',
        songIds: ['song1', 'song2'],
        createdAt: now,
        updatedAt: now,
      );

      final updatedPlaylist = playlist.copyWith(
        name: 'Updated Playlist',
        songIds: ['song1', 'song2', 'song3'],
        isPublic: true,
      );

      expect(updatedPlaylist.id, '1');
      expect(updatedPlaylist.name, 'Updated Playlist');
      expect(updatedPlaylist.description, 'A test playlist');
      expect(updatedPlaylist.songIds.length, 3);
      expect(updatedPlaylist.isPublic, true);
    });
  });

  group('User Model Tests', () {
    test('User creation and properties', () {
      final now = DateTime.now();
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        profileImageUrl: 'https://example.com/profile.jpg',
        createdAt: now,
        favoriteGenres: ['Pop', 'Rock'],
        isPremium: true,
      );

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.profileImageUrl, 'https://example.com/profile.jpg');
      expect(user.favoriteGenres.length, 2);
      expect(user.isPremium, true);
      expect(user.createdAt, now);
    });

    test('User copyWith method', () {
      final now = DateTime.now();
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        createdAt: now,
      );

      final updatedUser = user.copyWith(
        name: 'Jane Doe',
        isPremium: true,
        favoriteGenres: ['Jazz', 'Blues'],
      );

      expect(updatedUser.id, '1');
      expect(updatedUser.name, 'Jane Doe');
      expect(updatedUser.email, 'john@example.com');
      expect(updatedUser.isPremium, true);
      expect(updatedUser.favoriteGenres.length, 2);
    });
  });
}