import 'dart:async';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Song> _playlist = [];
  int _currentIndex = 0;

  // Stream controllers
  final StreamController<Song?> _currentSongController = StreamController<Song?>.broadcast();
  final StreamController<bool> _isPlayingController = StreamController<bool>.broadcast();
  final StreamController<Duration> _positionController = StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController = StreamController<Duration>.broadcast();
  final StreamController<List<Song>> _playlistController = StreamController<List<Song>>.broadcast();

  // Getters for streams
  Stream<Song?> get currentSongStream => _currentSongController.stream;
  Stream<bool> get isPlayingStream => _isPlayingController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<List<Song>> get playlistStream => _playlistController.stream;

  // Getters for current state
  Song? get currentSong => _playlist.isNotEmpty ? _playlist[_currentIndex] : null;
  bool get isPlaying => _audioPlayer.playing;
  Duration get position => _audioPlayer.position;
  Duration get duration => _audioPlayer.duration ?? Duration.zero;
  List<Song> get playlist => List.unmodifiable(_playlist);
  int get currentIndex => _currentIndex;

  Future<void> init() async {
    // Listen to player state changes
    _audioPlayer.playingStream.listen((playing) {
      _isPlayingController.add(playing);
    });

    // Listen to position changes
    _audioPlayer.positionStream.listen((position) {
      _positionController.add(position);
    });

    // Listen to duration changes
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        _durationController.add(duration);
      }
    });

    // Listen to player completion
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  Future<void> setPlaylist(List<Song> songs, {int initialIndex = 0}) async {
    print('AudioPlayerService: Setting playlist with ${songs.length} songs');

    // Stop current playback first
    if (_audioPlayer.playing) {
      await _audioPlayer.stop();
      print('AudioPlayerService: Stopped current playback');
    }

    _playlist.clear();
    _playlist.addAll(songs);

    if (_playlist.isEmpty) {
      print('AudioPlayerService: Warning - Empty playlist provided');
      return;
    }

    _currentIndex = initialIndex.clamp(0, _playlist.length - 1);
    print('AudioPlayerService: Set current index to $_currentIndex');

    _playlistController.add(_playlist);
    await _loadCurrentSong();
  }

  Future<void> _loadCurrentSong() async {
    if (_playlist.isEmpty || _currentIndex < 0 || _currentIndex >= _playlist.length) {
      print('AudioPlayerService: Invalid playlist or index');
      return;
    }

    final song = _playlist[_currentIndex];
    print('AudioPlayerService: Loading song: ${song.title} from ${song.audioUrl}');

    try {
      // Stop current audio first
      await _audioPlayer.stop();
      
      // Load new audio source
      await _audioPlayer.setUrl(song.audioUrl);
      _currentSongController.add(song);
      print('AudioPlayerService: Successfully loaded: ${song.title}');
    } catch (e) {
      print('AudioPlayerService: Error loading ${song.title}: $e');
      _currentSongController.add(song);
      rethrow;
    }
  }

  Future<void> play() async {
    try {
      print('AudioPlayerService: Starting playback');
      await _audioPlayer.play();
      print('AudioPlayerService: Playback started successfully');
    } catch (e) {
      print('AudioPlayerService: Error starting playback: $e');
      rethrow;
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> skipToNext() async {
    if (_playlist.isEmpty) return;
    
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await _loadCurrentSong();
    
    if (isPlaying) {
      await play();
    }
  }

  Future<void> skipToPrevious() async {
    if (_playlist.isEmpty) return;
    
    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await _loadCurrentSong();
    
    if (isPlaying) {
      await play();
    }
  }

  Future<void> skipToIndex(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _currentIndex = index;
      await _loadCurrentSong();
      
      if (isPlaying) {
        await play();
      }
    }
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  void dispose() {
    _audioPlayer.dispose();
    _currentSongController.close();
    _isPlayingController.close();
    _positionController.close();
    _durationController.close();
    _playlistController.close();
  }
}
