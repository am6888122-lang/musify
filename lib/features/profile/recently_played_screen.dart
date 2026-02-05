import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/providers/music_provider.dart';
import '../../core/models/song.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/mini_player.dart';

class RecentlyPlayedScreen extends StatelessWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MusicProvider>(
        builder: (context, musicProvider, child) {
          final recentSongs = musicProvider.recentlyPlayed;

          return Column(
            children: [
              // Header
              _buildHeader(context, recentSongs, musicProvider),

              // Songs List
              Expanded(
                child: recentSongs.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                          vertical: 8, // تقليل الـ padding العمودي
                        ),
                        itemCount: recentSongs.length,
                        itemBuilder: (context, index) {
                          final song = recentSongs[index];
                          return _buildSongTile(context, song, index, recentSongs, musicProvider);
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

  Widget _buildHeader(BuildContext context, List<Song> recentSongs, MusicProvider musicProvider) {
    return Container(
      height: 360, // تقليل الارتفاع من 300 إلى 250
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.secondary.withOpacity(0.8), AppColors.secondary.withOpacity(0.3)],
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
              // History Icon
              Container(
                width: 80, // تقليل من 120 إلى 80
                height: 80, // تقليل من 120 إلى 80
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.8)],
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
                  Icons.history,
                  size: 40, // تقليل من 60 إلى 40
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10), // تقليل من 20 إلى 10
              // Title
              Text(
                'Recently Played',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  // تغيير من headlineMedium إلى headlineSmall
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4), // تقليل من 8 إلى 4

              Text(
                '${recentSongs.length} songs',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  // تغيير من titleMedium إلى titleSmall
                  color: Colors.white.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 10), // تقليل من 20 إلى 10
              // Play Button
              if (recentSongs.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () => musicProvider.playPlaylist(recentSongs),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.secondary,
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
            Icons.history,
            size: 80,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'No Recently Played Songs',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Songs you play will appear here',
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
              icon: Icon(
                musicProvider.isFavorite(song.id) ? Icons.favorite : Icons.favorite_border,
                color: musicProvider.isFavorite(song.id) ? AppColors.error : null,
              ),
              onPressed: () => musicProvider.toggleFavorite(song.id),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showSongOptions(context, song, musicProvider),
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
                final songs = musicProvider.recentlyPlayed;
                if (songs.isNotEmpty) {
                  songs.shuffle();
                  musicProvider.playPlaylist(songs);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: const Text('Clear History'),
              onTap: () {
                Navigator.pop(context);
                _showClearHistoryDialog(context, musicProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add All to Playlist'),
              onTap: () {
                Navigator.pop(context);
                _showAddToPlaylistDialog(context, musicProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSongOptions(BuildContext context, Song song, MusicProvider musicProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to Playlist'),
              onTap: () {
                Navigator.pop(context);
                _showAddSongToPlaylistDialog(context, song, musicProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.album),
              title: const Text('Go to Album'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Going to ${song.album} album...')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Go to Artist'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Going to ${song.artist} profile...')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline, color: AppColors.error),
              title: const Text('Remove from History'),
              onTap: () {
                Navigator.pop(context);
                musicProvider.removeFromRecentlyPlayed(song.id);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Removed from recently played')));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, MusicProvider musicProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear your recently played history?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              musicProvider.clearRecentlyPlayed();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Recently played history cleared')));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear'),
          ),
        ],
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
                // Add all recent songs to selected playlist
                for (final song in musicProvider.recentlyPlayed) {
                  musicProvider.addSongToPlaylist(playlist.id, song.id);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added ${musicProvider.recentlyPlayed.length} songs to ${playlist.name}',
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

  void _showAddSongToPlaylistDialog(BuildContext context, Song song, MusicProvider musicProvider) {
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
                musicProvider.addSongToPlaylist(playlist.id, song.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added "${song.title}" to ${playlist.name}')),
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
