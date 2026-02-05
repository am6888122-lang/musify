import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/models/song.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/music_provider.dart';
import '../../core/utils/responsive_utils.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap;
  final double width;
  final bool showFavoriteButton;

  const SongCard({
    super.key,
    required this.song,
    this.onTap,
    this.width = 150,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width;
    final borderRadius = context.borderRadius;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: effectiveWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album Art
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(borderRadius),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: song.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.primary.withOpacity(0.1),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.music_note,
                          size: context.iconSize * 1.5,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  
                  // Play Button Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(borderRadius),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_filled,
                          size: context.iconSize * 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  // Favorite Button
                  if (showFavoriteButton)
                    Positioned(
                      top: context.responsivePadding / 2,
                      right: context.responsivePadding / 2,
                      child: Consumer<MusicProvider>(
                        builder: (context, musicProvider, child) {
                          final isFavorite = musicProvider.isFavorite(song.id);
                          return GestureDetector(
                            onTap: () => musicProvider.toggleFavorite(song.id),
                            child: Container(
                              padding: EdgeInsets.all(context.responsivePadding / 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                size: context.iconSize * 0.8,
                                color: isFavorite ? AppColors.error : Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            
            // Song Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(context.responsivePadding * 0.75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      song.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Theme.of(context).textTheme.titleMedium!.fontSize! * context.fontSizeMultiplier,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.responsivePadding / 4),
                    Text(
                      song.artist,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize! * context.fontSizeMultiplier,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}