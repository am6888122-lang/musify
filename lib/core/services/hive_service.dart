import 'package:hive_flutter/hive_flutter.dart';
import '../models/song.dart';
import '../models/playlist.dart';
import '../models/user.dart';
import '../constants/app_constants.dart';
import '../adapters/duration_adapter.dart';

class HiveService {
  static late Box<Song> _songsBox;
  static late Box<Playlist> _playlistsBox;
  static late Box<User> _userBox;
  static late Box<String> _favoritesBox;
  static late Box<Song> _recentlyPlayedBox;
  static late Box<Song> _downloadedSongsBox;
  static late Box<User> _registeredAccountsBox;

  static Future<void> init() async {
    // Register adapters
    Hive.registerAdapter(DurationAdapter()); // Register Duration adapter first
    Hive.registerAdapter(SongAdapter());
    Hive.registerAdapter(PlaylistAdapter());
    Hive.registerAdapter(UserAdapter());

    // Open boxes
    _songsBox = await Hive.openBox<Song>(AppConstants.songsBox);
    _playlistsBox = await Hive.openBox<Playlist>(AppConstants.playlistsBox);
    _userBox = await Hive.openBox<User>(AppConstants.userBox);
    _favoritesBox = await Hive.openBox<String>(AppConstants.favoritesBox);
    _recentlyPlayedBox = await Hive.openBox<Song>('recently_played');
    _downloadedSongsBox = await Hive.openBox<Song>('downloaded_songs');
    _registeredAccountsBox = await Hive.openBox<User>('registered_accounts');
  }

  // Songs operations
  static Box<Song> get songsBox => _songsBox;
  
  static Future<void> saveSong(Song song) async {
    await _songsBox.put(song.id, song);
  }
  
  static Song? getSong(String id) {
    return _songsBox.get(id);
  }
  
  static List<Song> getAllSongs() {
    return _songsBox.values.toList();
  }
  
  static Future<void> deleteSong(String id) async {
    await _songsBox.delete(id);
  }

  // Playlists operations
  static Box<Playlist> get playlistsBox => _playlistsBox;
  
  static Future<void> savePlaylist(Playlist playlist) async {
    await _playlistsBox.put(playlist.id, playlist);
  }
  
  static Playlist? getPlaylist(String id) {
    return _playlistsBox.get(id);
  }
  
  static List<Playlist> getAllPlaylists() {
    return _playlistsBox.values.toList();
  }
  
  static Future<void> deletePlaylist(String id) async {
    await _playlistsBox.delete(id);
  }

  // User operations
  static Box<User> get userBox => _userBox;
  
  static Future<void> saveUser(User user) async {
    await _userBox.put('current_user', user);
  }
  
  static User? getCurrentUser() {
    return _userBox.get('current_user');
  }
  
  static Future<void> deleteUser() async {
    await _userBox.delete('current_user');
  }

  // Registered Accounts operations
  static Box<User> get registeredAccountsBox => _registeredAccountsBox;
  
  static Future<void> saveRegisteredAccount(User user) async {
    // Save account with email as key
    await _registeredAccountsBox.put(user.email.toLowerCase(), user);
  }
  
  static User? getRegisteredAccount(String email) {
    return _registeredAccountsBox.get(email.toLowerCase());
  }
  
  static bool isAccountRegistered(String email) {
    return _registeredAccountsBox.containsKey(email.toLowerCase());
  }
  
  static List<User> getAllRegisteredAccounts() {
    return _registeredAccountsBox.values.toList();
  }
  
  static Future<void> deleteRegisteredAccount(String email) async {
    await _registeredAccountsBox.delete(email.toLowerCase());
  }

  // Favorites operations (user-specific)
  static Box<String> get favoritesBox => _favoritesBox;
  
  static String _getUserFavoritesKey(String userId) => 'favorites_$userId';
  
  static Future<void> addToFavorites(String songId, {String? userId}) async {
    if (userId == null) {
      await _favoritesBox.put(songId, songId);
    } else {
      final key = _getUserFavoritesKey(userId);
      final favorites = getAllFavorites(userId: userId);
      if (!favorites.contains(songId)) {
        favorites.add(songId);
        await _favoritesBox.put(key, favorites.join(','));
      }
    }
  }
  
  static Future<void> removeFromFavorites(String songId, {String? userId}) async {
    if (userId == null) {
      await _favoritesBox.delete(songId);
    } else {
      final key = _getUserFavoritesKey(userId);
      final favorites = getAllFavorites(userId: userId);
      favorites.remove(songId);
      if (favorites.isEmpty) {
        await _favoritesBox.delete(key);
      } else {
        await _favoritesBox.put(key, favorites.join(','));
      }
    }
  }
  
  static bool isFavorite(String songId, {String? userId}) {
    if (userId == null) {
      return _favoritesBox.containsKey(songId);
    } else {
      final favorites = getAllFavorites(userId: userId);
      return favorites.contains(songId);
    }
  }
  
  static List<String> getAllFavorites({String? userId}) {
    if (userId == null) {
      return _favoritesBox.values.toList();
    } else {
      final key = _getUserFavoritesKey(userId);
      final favoritesString = _favoritesBox.get(key);
      if (favoritesString == null || favoritesString.isEmpty) {
        return [];
      }
      return favoritesString.split(',');
    }
  }

  // Recently Played operations (user-specific)
  static String _getUserRecentlyPlayedKey(String userId) => 'recently_played_$userId';
  
  static List<Song> getRecentlyPlayed({String? userId}) {
    if (userId == null) {
      return _recentlyPlayedBox.values.toList();
    } else {
      final key = _getUserRecentlyPlayedKey(userId);
      final songs = <Song>[];
      int index = 0;
      while (true) {
        final song = _recentlyPlayedBox.get('${key}_$index');
        if (song == null) break;
        songs.add(song);
        index++;
      }
      return songs;
    }
  }

  static Future<void> saveRecentlyPlayed(List<Song> songs, {String? userId}) async {
    if (userId == null) {
      await _recentlyPlayedBox.clear();
      for (int i = 0; i < songs.length; i++) {
        await _recentlyPlayedBox.put(i, songs[i]);
      }
    } else {
      final key = _getUserRecentlyPlayedKey(userId);
      // Clear old data for this user
      await clearRecentlyPlayed(userId: userId);
      // Save new data
      for (int i = 0; i < songs.length; i++) {
        await _recentlyPlayedBox.put('${key}_$i', songs[i]);
      }
    }
  }

  static Future<void> clearRecentlyPlayed({String? userId}) async {
    if (userId == null) {
      await _recentlyPlayedBox.clear();
    } else {
      final key = _getUserRecentlyPlayedKey(userId);
      final keysToDelete = <String>[];
      for (var boxKey in _recentlyPlayedBox.keys) {
        if (boxKey.toString().startsWith(key)) {
          keysToDelete.add(boxKey.toString());
        }
      }
      for (var keyToDelete in keysToDelete) {
        await _recentlyPlayedBox.delete(keyToDelete);
      }
    }
  }

  // Downloaded Songs operations (user-specific)
  static String _getUserDownloadedKey(String userId) => 'downloaded_$userId';
  
  static List<Song> getDownloadedSongs({String? userId}) {
    if (userId == null) {
      return _downloadedSongsBox.values.toList();
    } else {
      final key = _getUserDownloadedKey(userId);
      final songs = <Song>[];
      int index = 0;
      while (true) {
        final song = _downloadedSongsBox.get('${key}_$index');
        if (song == null) break;
        songs.add(song);
        index++;
      }
      return songs;
    }
  }

  static Future<void> saveDownloadedSong(Song song, {String? userId}) async {
    if (userId == null) {
      await _downloadedSongsBox.put(song.id, song);
    } else {
      final songs = getDownloadedSongs(userId: userId);
      if (!songs.any((s) => s.id == song.id)) {
        final key = _getUserDownloadedKey(userId);
        await _downloadedSongsBox.put('${key}_${songs.length}', song);
      }
    }
  }

  static Future<void> removeDownloadedSong(String songId, {String? userId}) async {
    if (userId == null) {
      await _downloadedSongsBox.delete(songId);
    } else {
      final songs = getDownloadedSongs(userId: userId);
      final index = songs.indexWhere((s) => s.id == songId);
      if (index != -1) {
        final key = _getUserDownloadedKey(userId);
        await _downloadedSongsBox.delete('${key}_$index');
        // Reindex remaining songs
        final remainingSongs = songs..removeAt(index);
        await clearDownloadedSongs(userId: userId);
        for (int i = 0; i < remainingSongs.length; i++) {
          await _downloadedSongsBox.put('${key}_$i', remainingSongs[i]);
        }
      }
    }
  }

  static Future<void> clearDownloadedSongs({String? userId}) async {
    if (userId == null) {
      await _downloadedSongsBox.clear();
    } else {
      final key = _getUserDownloadedKey(userId);
      final keysToDelete = <String>[];
      for (var boxKey in _downloadedSongsBox.keys) {
        if (boxKey.toString().startsWith(key)) {
          keysToDelete.add(boxKey.toString());
        }
      }
      for (var keyToDelete in keysToDelete) {
        await _downloadedSongsBox.delete(keyToDelete);
      }
    }
  }

  static bool isDownloaded(String songId, {String? userId}) {
    if (userId == null) {
      return _downloadedSongsBox.containsKey(songId);
    } else {
      final songs = getDownloadedSongs(userId: userId);
      return songs.any((s) => s.id == songId);
    }
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await _songsBox.clear();
    await _playlistsBox.clear();
    await _userBox.clear();
    await _favoritesBox.clear();
    await _recentlyPlayedBox.clear();
    await _downloadedSongsBox.clear();
    // Don't clear registered accounts - keep them for login verification
  }
}