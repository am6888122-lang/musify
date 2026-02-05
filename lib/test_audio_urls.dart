import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioTestScreen extends StatefulWidget {
  const AudioTestScreen({super.key});

  @override
  State<AudioTestScreen> createState() => _AudioTestScreenState();
}

class _AudioTestScreenState extends State<AudioTestScreen> {
  final AudioPlayer _player = AudioPlayer();
  String _status = 'Ready to test';
  bool _isPlaying = false;

  final List<Map<String, String>> _testUrls = [
    {
      'name': 'SoundJay Bell',
      'url': 'https://www.soundjay.com/misc/sounds/bell-ringing-05.mp3'
    },
    {
      'name': 'SoundJay Magic Chime',
      'url': 'https://www.soundjay.com/misc/sounds/magic-chime-02.mp3'
    },
    {
      'name': 'SoundJay Success Fanfare',
      'url': 'https://www.soundjay.com/misc/sounds/success-fanfare-trumpets.mp3'
    },
    {
      'name': 'SoundJay Fail Buzzer',
      'url': 'https://www.soundjay.com/misc/sounds/fail-buzzer-02.mp3'
    },
    {
      'name': 'Google Actions Beep',
      'url': 'https://actions.google.com/sounds/v1/alarms/beep_short.ogg'
    },
    {
      'name': 'Google Actions Clang',
      'url': 'https://actions.google.com/sounds/v1/cartoon/clang_and_wobble.ogg'
    },
    {
      'name': 'Google Actions Pop',
      'url': 'https://actions.google.com/sounds/v1/cartoon/pop.ogg'
    },
  ];

  @override
  void initState() {
    super.initState();
    _player.playingStream.listen((playing) {
      setState(() {
        _isPlaying = playing;
      });
    });
  }

  Future<void> _testUrl(String name, String url) async {
    try {
      setState(() {
        _status = 'Loading: $name';
      });

      await _player.setUrl(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout loading $name');
        },
      );
      
      await _player.play();

      setState(() {
        _status = 'Playing: $name ✅';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed: $name ❌ - $e';
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio URL Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _status,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () async {
                    if (_isPlaying) {
                      await _player.pause();
                    } else {
                      await _player.play();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () async {
                    await _player.stop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _testUrls.length,
                itemBuilder: (context, index) {
                  final item = _testUrls[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['name']!),
                      subtitle: Text(
                        item['url']!,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.play_arrow),
                      onTap: () => _testUrl(item['name']!, item['url']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}