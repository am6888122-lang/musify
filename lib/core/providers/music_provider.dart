import 'package:flutter/material.dart';
import '../models/song.dart';
import '../models/playlist.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../services/audio_service.dart';

enum MusicState { initial, loading, loaded, error }

class MusicProvider extends ChangeNotifier {
  final AudioPlayerService _audioService = AudioPlayerService();
  
  // Reference to AuthProvider to get current user ID
  String? _currentUserId;
  
  void setUserId(String? userId) {
    _currentUserId = userId;
  }
  
  String? get currentUserId => _currentUserId;
  
  // State
  MusicState _state = MusicState.initial;
  String? _errorMessage;
  
  // Songs
  List<Song> _trendingSongs = [];
  List<Song> _popularSongs = [];
  List<Song> _newReleases = [];
  List<Song> _allSongs = [];
  List<Song> _searchResults = [];
  List<String> _favoriteSongIds = [];
  List<Song> _recentlyPlayed = [];
  List<Song> _downloadedSongs = [];
  
  // Playlists
  List<Playlist> _featuredPlaylists = [];
  List<Playlist> _userPlaylists = [];
  
  // Current playing
  Song? _currentSong;
  List<Song> _currentPlaylist = [];
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  // Getters
  MusicState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == MusicState.loading;
  
  List<Song> get trendingSongs => _trendingSongs;
  List<Song> get popularSongs => _popularSongs;
  List<Song> get newReleases => _newReleases;
  List<Song> get allSongs => _allSongs;
  List<Song> get searchResults => _searchResults;
  List<String> get favoriteSongIds => _favoriteSongIds;
  List<Song> get recentlyPlayed => _recentlyPlayed;
  List<Song> get downloadedSongs => _downloadedSongs;
  
  List<Playlist> get featuredPlaylists => _featuredPlaylists;
  List<Playlist> get userPlaylists => _userPlaylists;
  
  Song? get currentSong => _currentSong;
  List<Song> get currentPlaylist => _currentPlaylist;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  
  List<Song> get favoriteSongs => _allSongs.where((song) => _favoriteSongIds.contains(song.id)).toList();

  Future<void> init() async {
    try {
      await _audioService.init();
      _setupAudioListeners();
      await loadInitialData();
      print('MusicProvider: Initialization completed successfully');
    } catch (e) {
      print('MusicProvider: Initialization error: $e');
      _setError('Failed to initialize music service: $e');
    }
  }

  // Load user-specific data
  Future<void> loadUserData(String userId) async {
    _currentUserId = userId;
    _loadFavorites(userId);
    _loadRecentlyPlayed(userId);
    _loadDownloadedSongs(userId);
  }

  // Clear user data on logout
  void clearUserData() {
    _currentUserId = null;
    _favoriteSongIds.clear();
    _recentlyPlayed.clear();
    _downloadedSongs.clear();
    notifyListeners();
  }

  void _setupAudioListeners() {
    _audioService.currentSongStream.listen((song) {
      _currentSong = song;
      notifyListeners();
    });
    
    _audioService.isPlayingStream.listen((playing) {
      _isPlaying = playing;
      notifyListeners();
    });
    
    _audioService.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });
    
    _audioService.durationStream.listen((duration) {
      _duration = duration;
      notifyListeners();
    });
    
    _audioService.playlistStream.listen((playlist) {
      _currentPlaylist = playlist;
      notifyListeners();
    });
  }

  Future<void> loadInitialData() async {
    _setState(MusicState.loading);
    
    try {
      // Load all data concurrently
      final results = await Future.wait([
        ApiService.getTrendingSongs(),
        ApiService.getPopularSongs(),
        ApiService.getNewReleases(),
        ApiService.getAllSongs(),
        ApiService.getFeaturedPlaylists(),
      ]);
      
      _trendingSongs = results[0] as List<Song>;
      _popularSongs = results[1] as List<Song>;
      _newReleases = results[2] as List<Song>;
      _allSongs = results[3] as List<Song>;
      _featuredPlaylists = results[4] as List<Playlist>;
      
      // Load user playlists from local storage
      _userPlaylists = HiveService.getAllPlaylists();
      
      _setState(MusicState.loaded);
    } catch (e) {
      _setError('Failed to load music data');
    }
  }

  Future<void> searchSongs(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    try {
      _searchResults = await ApiService.searchSongs(query);
      notifyListeners();
    } catch (e) {
      print('Search error: $e');
      _searchResults = [];
      _setError('Search failed: $e');
    }
  }

  // Audio control methods
  Future<void> playSong(Song song, {List<Song>? playlist, String? userId}) async {
    try {
      // Check if the song is already in the current playlist
      final currentPlaylistIndex = _currentPlaylist.indexWhere((s) => s.id == song.id);
      
      if (currentPlaylistIndex != -1 && playlist == null) {
        // Song is already in current playlist, just switch to it
        print('MusicProvider: Switching to existing song in playlist at index $currentPlaylistIndex');
        await _audioService.skipToIndex(currentPlaylistIndex);
        await _audioService.play();
        if (userId != null) {
          await addToRecentlyPlayed(song, userId);
        }
        return;
      }
      
      // Stop current playback first if playing
      if (_isPlaying) {
        await _audioService.stop();
      }
      
      final playlistToUse = playlist ?? [song];
      final index = playlistToUse.indexWhere((s) => s.id == song.id);
      
      // Ensure index is valid
      if (index == -1) {
        print('Song not found in playlist, adding it');
        playlistToUse.add(song);
      }
      
      final validIndex = index == -1 ? playlistToUse.length - 1 : index;
      
      // Add to recently played
      if (userId != null) {
        await addToRecentlyPlayed(song, userId);
      }
      
      // Set new playlist and play
      await _audioService.setPlaylist(playlistToUse, initialIndex: validIndex);
      await _audioService.play();
      
      print('MusicProvider: Successfully switched to song: ${song.title}');
    } catch (e) {
      print('Error playing song: $e');
      rethrow;
    }
  }

  Future<void> playPlaylist(List<Song> playlist, {int startIndex = 0}) async {
    try {
      if (playlist.isEmpty) {
        throw Exception('Playlist is empty');
      }
      
      final validIndex = startIndex.clamp(0, playlist.length - 1);
      
      // Add the first song to recently played
      await addToRecentlyPlayed(playlist[validIndex]);
      
      await _audioService.setPlaylist(playlist, initialIndex: validIndex);
      await _audioService.play();
    } catch (e) {
      print('Error playing playlist: $e');
      rethrow;
    }
  }

  Future<void> togglePlayPause() async {
    await _audioService.togglePlayPause();
  }

  Future<void> skipToNext() async {
    await _audioService.skipToNext();
  }

  Future<void> skipToPrevious() async {
    await _audioService.skipToPrevious();
  }

  Future<void> seekTo(Duration position) async {
    await _audioService.seek(position);
  }

  // Favorites management
  void _loadFavorites(String userId) {
    _favoriteSongIds = HiveService.getAllFavorites(userId: userId);
    notifyListeners();
  }

  Future<void> toggleFavorite(String songId, [String? userId]) async {
    final uid = userId ?? _currentUserId;
    if (uid == null) return;
    
    if (_favoriteSongIds.contains(songId)) {
      await HiveService.removeFromFavorites(songId, userId: uid);
      _favoriteSongIds.remove(songId);
    } else {
      await HiveService.addToFavorites(songId, userId: uid);
      _favoriteSongIds.add(songId);
    }
    notifyListeners();
  }

  bool isFavorite(String songId) {
    return _favoriteSongIds.contains(songId);
  }

  // Playlist management
  Future<void> createPlaylist(String name, {String description = ''}) async {
    final playlist = Playlist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      songIds: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await HiveService.savePlaylist(playlist);
    _userPlaylists.add(playlist);
    notifyListeners();
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    final playlistIndex = _userPlaylists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex != -1) {
      final playlist = _userPlaylists[playlistIndex];
      if (!playlist.songIds.contains(songId)) {
        final updatedPlaylist = playlist.copyWith(
          songIds: [...playlist.songIds, songId],
          updatedAt: DateTime.now(),
        );
        
        await HiveService.savePlaylist(updatedPlaylist);
        _userPlaylists[playlistIndex] = updatedPlaylist;
        notifyListeners();
      }
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    final playlistIndex = _userPlaylists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex != -1) {
      final playlist = _userPlaylists[playlistIndex];
      final updatedSongIds = playlist.songIds.where((id) => id != songId).toList();
      
      final updatedPlaylist = playlist.copyWith(
        songIds: updatedSongIds,
        updatedAt: DateTime.now(),
      );
      
      await HiveService.savePlaylist(updatedPlaylist);
      _userPlaylists[playlistIndex] = updatedPlaylist;
      notifyListeners();
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    await HiveService.deletePlaylist(playlistId);
    _userPlaylists.removeWhere((p) => p.id == playlistId);
    notifyListeners();
  }

  List<Song> getPlaylistSongs(String playlistId) {
    final playlist = _userPlaylists.firstWhere((p) => p.id == playlistId);
    return _allSongs.where((song) => playlist.songIds.contains(song.id)).toList();
  }

  // Recently Played management
  void _loadRecentlyPlayed(String userId) {
    _recentlyPlayed = HiveService.getRecentlyPlayed(userId: userId);
    notifyListeners();
  }

  Future<void> addToRecentlyPlayed(Song song, [String? userId]) async {
    final uid = userId ?? _currentUserId;
    if (uid == null) return;
    
    // Remove if already exists to avoid duplicates
    _recentlyPlayed.removeWhere((s) => s.id == song.id);
    
    // Add to beginning of list
    _recentlyPlayed.insert(0, song);
    
    // Keep only last 50 songs
    if (_recentlyPlayed.length > 50) {
      _recentlyPlayed = _recentlyPlayed.take(50).toList();
    }
    
    await HiveService.saveRecentlyPlayed(_recentlyPlayed, userId: uid);
    notifyListeners();
  }

  Future<void> removeFromRecentlyPlayed(String songId, [String? userId]) async {
    final uid = userId ?? _currentUserId;
    if (uid == null) return;
    
    _recentlyPlayed.removeWhere((song) => song.id == songId);
    await HiveService.saveRecentlyPlayed(_recentlyPlayed, userId: uid);
    notifyListeners();
  }

  Future<void> clearRecentlyPlayed([String? userId]) async {
    final uid = userId ?? _currentUserId;
    if (uid == null) return;
    
    _recentlyPlayed.clear();
    await HiveService.clearRecentlyPlayed(userId: uid);
    notifyListeners();
  }

  // Downloaded Songs management
  void _loadDownloadedSongs(String userId) {
    _downloadedSongs = HiveService.getDownloadedSongs(userId: userId);
    notifyListeners();
  }

  Future<void> downloadSong(Song song, [String? userId]) async {
    final uid = userId ?? _currentUserId;
    if (uid == null) return;
    
    if (!_downloadedSongs.any((s) => s.id == song.id)) {
      _downloadedSongs.add(song);
      await HiveService.saveDownloadedSong(song, userId: uid);
      notifyListeners();
    }
  }

  Future<void> removeDownloadedSong(String songId, [String? userId]) async {
    final uid = userId ?? _currentUserId;
    if (uid == null) return;
    
    _downloadedSongs.removeWhere((song) => song.id == songId);
    await HiveService.removeDownloadedSong(songId, userId: uid);
    notifyListeners();
  }

  Future<void> clearDownloadedSongs([String? userId]) async {
    final uid = userId ?? _currentUserId;
    if (uid == null) return;
    
    _downloadedSongs.clear();
    await HiveService.clearDownloadedSongs(userId: uid);
    notifyListeners();
  }

  bool isDownloaded(String songId) {
    return _downloadedSongs.any((song) => song.id == songId);
  }

  // Recommendations
  Future<List<Song>> getRecommendations() async {
    try {
      return await ApiService.getRecommendations();
    } catch (e) {
      return [];
    }
  }

  void _setState(MusicState state) {
    _state = state;
    if (state != MusicState.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setState(MusicState.error);
  }

  void clearError() {
    _errorMessage = null;
    _setState(MusicState.loaded);
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}