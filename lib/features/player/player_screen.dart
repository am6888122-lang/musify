import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/providers/music_provider.dart';
import '../../core/utils/responsive_utils.dart';
import '../../shared/widgets/custom_slider.dart';
import '../../shared/widgets/responsive_wrapper.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  void _navigateBack() {
    try {
      context.go('/home');
    } catch (e) {
      // Fallback navigation
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _navigateBack();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ResponsiveWrapper(
            child: Consumer<MusicProvider>(
              builder: (context, musicProvider, child) {
                final currentSong = musicProvider.currentSong;
                
                if (currentSong == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note,
                          size: context.iconSize * 2,
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                        ),
                        SizedBox(height: context.verticalSpacing),
                        Text(
                          'No song playing',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize! * context.fontSizeMultiplier,
                          ),
                        ),
                        SizedBox(height: context.verticalSpacing),
                        ElevatedButton(
                          onPressed: _navigateBack,
                          child: const Text('Go Back'),
                        ),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen = constraints.maxHeight < 600;
                    final isVerySmallScreen = constraints.maxHeight < 500;
                    
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          children: [
                            // App Bar
                            _buildAppBar(context),
                            
                            // Content
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.responsivePadding,
                                vertical: isVerySmallScreen ? 8 : context.responsivePadding,
                              ),
                              child: Column(
                                children: [
                                  // Album Art
                                  _buildAlbumArt(context, currentSong, isSmallScreen, isVerySmallScreen),
                                  
                                  SizedBox(height: isVerySmallScreen ? 16 : (isSmallScreen ? 24 : 32)),
                                  
                                  // Song Info
                                  _buildSongInfo(context, currentSong),
                                  
                                  SizedBox(height: isVerySmallScreen ? 16 : (isSmallScreen ? 24 : 32)),
                                  
                                  // Progress Bar
                                  _buildProgressBar(context, musicProvider),
                                  
                                  SizedBox(height: isVerySmallScreen ? 16 : (isSmallScreen ? 24 : 32)),
                                  
                                  // Controls
                                  _buildControls(context, musicProvider),
                                  
                                  SizedBox(height: isVerySmallScreen ? 12 : (isSmallScreen ? 20 : 32)),
                                  
                                  // Additional Controls
                                  _buildAdditionalControls(context, musicProvider, currentSong),
                                  
                                  SizedBox(height: context.responsivePadding),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: Row(
        children: [
          IconButton(
            onPressed: _navigateBack,
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: context.iconSize,
          ),
          const Spacer(),
          Text(
            'Now Playing',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize! * context.fontSizeMultiplier,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Show more options
            },
            icon: const Icon(Icons.more_vert),
            iconSize: context.iconSize,
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt(BuildContext context, currentSong, bool isSmallScreen, bool isVerySmallScreen) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    double albumArtSize;
    if (isVerySmallScreen) {
      albumArtSize = screenWidth * 0.6;
    } else if (isSmallScreen) {
      albumArtSize = screenWidth * 0.7;
    } else if (context.isTablet) {
      albumArtSize = screenWidth * 0.5;
    } else {
      albumArtSize = screenWidth * 0.8;
    }
    
    albumArtSize = albumArtSize.clamp(200.0, 400.0);
    
    return Container(
      width: albumArtSize,
      height: albumArtSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.borderRadius * 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: isVerySmallScreen ? 10 : 20,
            offset: Offset(0, isVerySmallScreen ? 5 : 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.borderRadius * 2),
        child: Image.network(
          currentSong.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.primary.withOpacity(0.1),
              child: Icon(
                Icons.music_note,
                size: albumArtSize * 0.3,
                color: AppColors.primary,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSongInfo(BuildContext context, currentSong) {
    return Column(
      children: [
        Text(
          currentSong.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize! * context.fontSizeMultiplier,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          currentSong.artist,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            fontSize: Theme.of(context).textTheme.titleMedium!.fontSize! * context.fontSizeMultiplier,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, MusicProvider musicProvider) {
    return Column(
      children: [
        CustomSlider(
          value: musicProvider.position.inSeconds.toDouble(),
          max: musicProvider.duration.inSeconds.toDouble(),
          onChanged: (value) {
            musicProvider.seekTo(Duration(seconds: value.toInt()));
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(musicProvider.position),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize! * context.fontSizeMultiplier,
              ),
            ),
            Text(
              _formatDuration(musicProvider.duration),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize! * context.fontSizeMultiplier,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context, MusicProvider musicProvider) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return Container(
      constraints: BoxConstraints(
        maxWidth: context.isWeb ? 400 : double.infinity,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => musicProvider.skipToPrevious(),
            icon: const Icon(Icons.skip_previous),
            iconSize: isSmallScreen ? context.iconSize * 1.2 : context.iconSize * 1.5,
          ),
          Container(
            width: isSmallScreen ? 56 : 64,
            height: isSmallScreen ? 56 : 64,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => musicProvider.togglePlayPause(),
              icon: Icon(
                musicProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              iconSize: isSmallScreen ? context.iconSize * 1.5 : context.iconSize * 2,
            ),
          ),
          IconButton(
            onPressed: () => musicProvider.skipToNext(),
            icon: const Icon(Icons.skip_next),
            iconSize: isSmallScreen ? context.iconSize * 1.2 : context.iconSize * 1.5,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalControls(BuildContext context, MusicProvider musicProvider, currentSong) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: context.isWeb ? 300 : double.infinity,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              // Shuffle functionality
            },
            icon: const Icon(Icons.shuffle),
            iconSize: context.iconSize,
          ),
          IconButton(
            onPressed: () => musicProvider.toggleFavorite(currentSong.id),
            icon: Icon(
              musicProvider.isFavorite(currentSong.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: musicProvider.isFavorite(currentSong.id)
                  ? AppColors.error
                  : null,
            ),
            iconSize: context.iconSize,
          ),
          IconButton(
            onPressed: () {
              // Repeat functionality
            },
            icon: const Icon(Icons.repeat),
            iconSize: context.iconSize,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}