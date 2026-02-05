import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/providers/music_provider.dart';
import '../../core/models/song.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/mini_player.dart';

class LikedSongsScreen extends StatelessWidget {
  const LikedSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MusicProvider>(
        builder: (context, musicProvider, child) {
          final likedSongs = musicProvider.favoriteSongs;

          return Column(
            children: [
              // Header
              _buildHeader(context, likedSongs, musicProvider),

              // Songs List
              Expanded(
                child: likedSongs.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                          vertical: 8, // تقليل الـ padding العمودي
                        ),
                        itemCount: likedSongs.length,
                        itemBuilder: (context, index) {
                          final song = likedSongs[index];
                          return _buildSongTile(context, song, index, likedSongs, musicProvider);
                        },
                      ),
              ),

              // Mini Player
              const MiniPlayer(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<Song> likedSongs, MusicProvider musicProvider) {
    return Container(
      height: 360, // تقليل الارتفاع من 300 إلى 250
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.error.withOpacity(0.8), AppColors.error.withOpacity(0.3)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              // App Bar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () => _showOptionsMenu(context, musicProvider),
                  ),
                ],
              ),

              const SizedBox(height: 10), // تقليل من 20 إلى 10
              // Heart Icon
              Container(
                width: 80, // تقليل من 120 إلى 80
                height: 80, // تقليل من 120 إلى 80
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.error, AppColors.error.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  size: 40, // تقليل من 60 إلى 40
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10), // تقليل من 20 إلى 10
              // Title
              Text(
                'Liked Songs',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  // تغيير من headlineMedium إلى headlineSmall
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4), // تقليل من 8 إلى 4

              Text(
                '${likedSongs.length} songs',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  // تغيير من titleMedium إلى titleSmall
                  color: Colors.white.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 10), // تقليل من 20 إلى 10
              // Play Button
              if (likedSongs.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () => musicProvider.playPlaylist(likedSongs),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ), // تقليل الـ padding
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'No Liked Songs Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Songs you like will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSongTile(
    BuildContext context,
    Song song,
    int index,
    List<Song> songs,
    MusicProvider musicProvider,
  ) {
    final isCurrentSong = musicProvider.currentSong?.id == song.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrentSong ? AppColors.primary.withOpacity(0.1) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ListTile(
        leading: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: song.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 50,
                  height: 50,
                  color: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.music_note),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 50,
                  height: 50,
                  color: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.music_note),
                ),
              ),
            ),
            if (isCurrentSong && musicProvider.isPlaying)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.volume_up, color: Colors.white, size: 20),
                ),
              ),
          ],
        ),
        title: Text(
          song.title,
          style: TextStyle(
            color: isCurrentSong ? AppColors.primary : null,
            fontWeight: isCurrentSong ? FontWeight.w600 : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_formatDuration(song.duration), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.favorite, color: AppColors.error),
              onPressed: () => musicProvider.toggleFavorite(song.id),
            ),
          ],
        ),
        onTap: () => musicProvider.playPlaylist(songs, startIndex: index),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showOptionsMenu(BuildContext context, MusicProvider musicProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.shuffle),
              title: const Text('Shuffle Play'),
              onTap: () {
                Navigator.pop(context);
                final songs = musicProvider.favoriteSongs;
                if (songs.isNotEmpty) {
                  songs.shuffle();
                  musicProvider.playPlaylist(songs);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to Playlist'),
              onTap: () {
                Navigator.pop(context);
                _showAddToPlaylistDialog(context, musicProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Sharing liked songs...')));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddToPlaylistDialog(BuildContext context, MusicProvider musicProvider) {
    final playlists = musicProvider.userPlaylists;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: playlists.map((playlist) {
            return ListTile(
              leading: const Icon(Icons.playlist_play),
              title: Text(playlist.name),
              onTap: () {
                Navigator.pop(context);
                // Add all liked songs to selected playlist
                for (final song in musicProvider.favoriteSongs) {
                  musicProvider.addSongToPlaylist(playlist.id, song.id);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added ${musicProvider.favoriteSongs.length} songs to ${playlist.name}',
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
      ),
    );
  }
}
