import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/providers/music_provider.dart';
import '../../core/models/song.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/mini_player.dart';

class PlaylistScreen extends StatelessWidget {
  final String playlistId;

  const PlaylistScreen({
    super.key,
    required this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MusicProvider>(
        builder: (context, musicProvider, child) {
          final playlistList = musicProvider.userPlaylists
              .where((p) => p.id == playlistId)
              .toList();
          final playlist = playlistList.isNotEmpty ? playlistList.first : null;
          
          if (playlist == null) {
            return const Center(
              child: Text('Playlist not found'),
            );
          }

          final songs = musicProvider.getPlaylistSongs(playlistId);

          return Column(
            children: [
              // Header
              _buildHeader(context, playlist, songs, musicProvider),
              
              // Songs List
              Expanded(
                child: songs.isEmpty
                    ? const Center(
                        child: Text('No songs in this playlist'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return _buildSongTile(
                            context,
                            song,
                            index,
                            songs,
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
    playlist,
    List songs,
    MusicProvider musicProvider,
  ) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.primary.withOpacity(0.3),
          ],
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
                    onPressed: () => _showPlaylistOptions(context, playlist, musicProvider),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Playlist Cover
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  child: playlist.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: playlist.imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => _buildDefaultCover(),
                        )
                      : _buildDefaultCover(),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Playlist Info
              Text(
                playlist.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                '${songs.length} songs',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Play Button
              if (songs.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () => musicProvider.playPlaylist(List<Song>.from(songs)),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: const Icon(
        Icons.playlist_play,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSongTile(
    BuildContext context,
    song,
    int index,
    List songs,
    MusicProvider musicProvider,
  ) {
    final isCurrentSong = musicProvider.currentSong?.id == song.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrentSong
            ? AppColors.primary.withOpacity(0.1)
            : Theme.of(context).cardColor,
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
                  child: const Icon(
                    Icons.volume_up,
                    color: Colors.white,
                    size: 20,
                  ),
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
        subtitle: Text(
          song.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                musicProvider.isFavorite(song.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: musicProvider.isFavorite(song.id)
                    ? AppColors.error
                    : null,
              ),
              onPressed: () => musicProvider.toggleFavorite(song.id),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showSongOptions(context, song, musicProvider),
            ),
          ],
        ),
        onTap: () => musicProvider.playPlaylist(List<Song>.from(songs), startIndex: index),
      ),
    );
  }

  void _showPlaylistOptions(
    BuildContext context,
    playlist,
    MusicProvider musicProvider,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Playlist'),
              onTap: () {
                Navigator.pop(context);
                _showEditPlaylistDialog(context, playlist, musicProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Delete Playlist'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, playlist, musicProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSongOptions(
    BuildContext context,
    song,
    MusicProvider musicProvider,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.remove_circle_outline, color: AppColors.error),
              title: const Text('Remove from Playlist'),
              onTap: () {
                Navigator.pop(context);
                musicProvider.removeSongFromPlaylist(playlistId, song.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Song removed from playlist')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPlaylistDialog(
    BuildContext context,
    playlist,
    MusicProvider musicProvider,
  ) {
    final nameController = TextEditingController(text: playlist.name);
    final descriptionController = TextEditingController(text: playlist.description);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Playlist Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Update playlist logic would go here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Playlist updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    playlist,
    MusicProvider musicProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text('Are you sure you want to delete "${playlist.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              musicProvider.deletePlaylist(playlistId);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Playlist deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}