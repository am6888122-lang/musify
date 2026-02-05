import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/providers/music_provider.dart';
import '../../core/models/song.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/mini_player.dart';

class DownloadedMusicScreen extends StatelessWidget {
  const DownloadedMusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MusicProvider>(
        builder: (context, musicProvider, child) {
          final downloadedSongs = musicProvider.downloadedSongs;

          return Column(
            children: [
              // Header
              _buildHeader(context, downloadedSongs, musicProvider),

              // Storage Info
              _buildStorageInfo(context, downloadedSongs),

              // Songs List
              Expanded(
                child: downloadedSongs.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                          vertical: 8, // تقليل الـ padding العمودي
                        ),
                        itemCount: downloadedSongs.length,
                        itemBuilder: (context, index) {
                          final song = downloadedSongs[index];
                          return _buildSongTile(
                            context,
                            song,
                            index,
                            downloadedSongs,
                            musicProvider,
                          );
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

  Widget _buildHeader(
    BuildContext context,
    List<Song> downloadedSongs,
    MusicProvider musicProvider,
  ) {
    return Container(
      height: 360, // تقليل الارتفاع من 280 إلى 230
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary.withOpacity(0.8), AppColors.primary.withOpacity(0.3)],
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
              // Download Icon
              Container(
                width: 70, // تقليل من 100 إلى 70
                height: 70, // تقليل من 100 إلى 70
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
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
                  Icons.download,
                  size: 35,
                  color: Colors.white,
                ), // تقليل من 50 إلى 35
              ),

              const SizedBox(height: 10), // تقليل من 20 إلى 10
              // Title
              Text(
                'Downloaded Music',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  // تغيير من headlineMedium إلى headlineSmall
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4), // تقليل من 8 إلى 4

              Text(
                '${downloadedSongs.length} songs',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ), // تغيير من titleMedium إلى titleSmall
              ),

              const SizedBox(height: 10), // تقليل من 20 إلى 10
              // Play Button
              if (downloadedSongs.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () => musicProvider.playPlaylist(downloadedSongs),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
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

  Widget _buildStorageInfo(BuildContext context, List<Song> downloadedSongs) {
    final totalSize = downloadedSongs.length * 4.5; // Assume 4.5MB per song

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8, // تقليل الـ margin العمودي
      ),
      padding: const EdgeInsets.all(12), // تقليل الـ padding من 16 إلى 12
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.storage, color: AppColors.primary, size: 20), // تقليل من 24 إلى 20
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Storage Used',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ), // تغيير من titleMedium إلى titleSmall
                ),
                const SizedBox(height: 2), // تقليل من 4 إلى 2
                Text(
                  '${totalSize.toStringAsFixed(1)} MB used',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    // تغيير من bodyMedium إلى bodySmall
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: () => _showStorageManagement(context), child: const Text('Manage')),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'No Downloaded Music',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Download songs to listen offline',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.explore),
            label: const Text('Explore Music'),
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
            // Downloaded indicator
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.download_done, color: Colors.white, size: 12),
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.offline_pin, size: 12, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  'Downloaded • 4.5 MB',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.primary, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
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
                final songs = musicProvider.downloadedSongs;
                if (songs.isNotEmpty) {
                  songs.shuffle();
                  musicProvider.playPlaylist(songs);
                }
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
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: AppColors.error),
              title: const Text('Delete All Downloads'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteAllDialog(context, musicProvider);
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
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Delete Download'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteSongDialog(context, song, musicProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStorageManagement(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Management'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Download Quality:'),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: 'High',
              items: const [
                DropdownMenuItem(value: 'Low', child: Text('Low (2MB per song)')),
                DropdownMenuItem(value: 'Medium', child: Text('Medium (3MB per song)')),
                DropdownMenuItem(value: 'High', child: Text('High (4.5MB per song)')),
                DropdownMenuItem(value: 'Lossless', child: Text('Lossless (8MB per song)')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const Text('Auto-delete downloads after:'),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: 'Never',
              items: const [
                DropdownMenuItem(value: 'Never', child: Text('Never')),
                DropdownMenuItem(value: '30 days', child: Text('30 days')),
                DropdownMenuItem(value: '60 days', child: Text('60 days')),
                DropdownMenuItem(value: '90 days', child: Text('90 days')),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Storage settings updated')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context, MusicProvider musicProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Downloads'),
        content: const Text(
          'Are you sure you want to delete all downloaded music? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              musicProvider.clearDownloadedSongs();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('All downloads deleted')));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _showDeleteSongDialog(BuildContext context, Song song, MusicProvider musicProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Download'),
        content: Text('Delete "${song.title}" from downloads?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              musicProvider.removeDownloadedSong(song.id);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Download deleted')));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
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
                for (final song in musicProvider.downloadedSongs) {
                  musicProvider.addSongToPlaylist(playlist.id, song.id);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added ${musicProvider.downloadedSongs.length} songs to ${playlist.name}',
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
