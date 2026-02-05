import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/providers/music_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/models/song.dart';
import '../../core/models/playlist.dart';
import '../../shared/widgets/song_card.dart';
import '../../shared/widgets/playlist_card.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/search_bar.dart' as custom_search;
import '../../shared/widgets/mini_player.dart';
import '../../shared/widgets/responsive_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        // Search
        _showSearchBottomSheet();
        break;
      case 2:
        // Library/Playlists
        _showPlaylistsBottomSheet();
        break;
      case 3:
        // Profile
        context.go(AppRoutes.profile);
        break;
    }
  }

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SearchBottomSheet(),
    );
  }

  void _showPlaylistsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PlaylistsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveWrapper(
          child: Column(
            children: [
              // App Bar
              _buildAppBar(),
              
              // Content
              Expanded(
                child: Consumer<MusicProvider>(
                  builder: (context, musicProvider, child) {
                    if (musicProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (musicProvider.errorMessage != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              musicProvider.errorMessage!,
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => musicProvider.loadInitialData(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(context.responsivePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quick Search
                          custom_search.CustomSearchBar(
                            controller: _searchController,
                            onTap: _showSearchBottomSheet,
                            readOnly: true,
                          ),
                          
                          SizedBox(height: context.verticalSpacing * 2),
                          
                          // Trending Songs
                          SectionHeader(
                            title: 'Trending Now',
                            onSeeAllPressed: () {},
                          ),
                          SizedBox(height: context.verticalSpacing),
                          _buildHorizontalSongList(
                            musicProvider.trendingSongs,
                            musicProvider.trendingSongs,
                          ),
                          
                          SizedBox(height: context.verticalSpacing * 2),
                          
                          // Popular Songs
                          SectionHeader(
                            title: 'Popular',
                            onSeeAllPressed: () {},
                          ),
                          SizedBox(height: context.verticalSpacing),
                          _buildHorizontalSongList(
                            musicProvider.popularSongs,
                            musicProvider.popularSongs,
                          ),
                          
                          SizedBox(height: context.verticalSpacing * 2),
                          
                          // Featured Playlists
                          SectionHeader(
                            title: 'Featured Playlists',
                            onSeeAllPressed: () {},
                          ),
                          SizedBox(height: context.verticalSpacing),
                          _buildHorizontalPlaylistList(musicProvider.featuredPlaylists),
                          
                          SizedBox(height: context.verticalSpacing * 2),
                          
                          // New Releases
                          SectionHeader(
                            title: 'New Releases',
                            onSeeAllPressed: () {},
                          ),
                          SizedBox(height: context.verticalSpacing),
                          _buildHorizontalSongList(
                            musicProvider.newReleases,
                            musicProvider.newReleases,
                          ),
                          
                          const SizedBox(height: 100), // Space for mini player
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Mini Player
              const MiniPlayer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Row(
            children: [
              // Greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Good ${_getGreeting()}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                        fontSize: Theme.of(context).textTheme.titleMedium!.fontSize! * context.fontSizeMultiplier,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authProvider.user?.name ?? 'Music Lover',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize! * context.fontSizeMultiplier,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Profile Avatar
              GestureDetector(
                onTap: () => context.go(AppRoutes.profile),
                child: CircleAvatar(
                  radius: context.isMobile ? 20 : (context.isTablet ? 24 : 28),
                  backgroundColor: AppColors.primary,
                  backgroundImage: authProvider.user?.profileImageUrl.isNotEmpty == true
                      ? NetworkImage(authProvider.user!.profileImageUrl)
                      : null,
                  child: authProvider.user?.profileImageUrl.isEmpty != false
                      ? Text(
                          authProvider.user?.name.isNotEmpty == true
                              ? authProvider.user!.name[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: (context.isMobile ? 16 : (context.isTablet ? 18 : 20)) * context.fontSizeMultiplier,
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
      selectedFontSize: context.isMobile ? 12.0 : (context.isTablet ? 13.0 : 14.0),
      unselectedFontSize: context.isMobile ? 10.0 : (context.isTablet ? 11.0 : 12.0),
      iconSize: context.isMobile ? 24.0 : (context.isTablet ? 26.0 : 28.0),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music_outlined),
          activeIcon: Icon(Icons.library_music),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildHorizontalSongList(List<Song> songs, List<Song> playlist) {
    return SizedBox(
      height: context.isMobile ? 200 : (context.isTablet ? 220 : 240),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return Padding(
            padding: EdgeInsets.only(right: context.horizontalSpacing),
            child: SongCard(
              song: song,
              width: context.cardWidth,
              onTap: () async {
                try {
                  final musicProvider = Provider.of<MusicProvider>(context, listen: false);
                  await musicProvider.playSong(song, playlist: playlist);
                } catch (e) {
                  print('Error playing song: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error playing "${song.title}"'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalPlaylistList(List<Playlist> playlists) {
    return SizedBox(
      height: context.isMobile ? 200 : (context.isTablet ? 220 : 240),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return Padding(
            padding: EdgeInsets.only(right: context.horizontalSpacing),
            child: PlaylistCard(
              playlist: playlist,
              width: context.cardWidth,
              onTap: () => context.go('${AppRoutes.playlist}/${playlist.id}'),
            ),
          );
        },
      ),
    );
  }
}

// Search Bottom Sheet
class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: custom_search.CustomSearchBar(
              controller: _searchController,
              onChanged: (query) {
                Provider.of<MusicProvider>(context, listen: false).searchSongs(query);
              },
              autofocus: true,
            ),
          ),
          
          // Search Results
          Expanded(
            child: Consumer<MusicProvider>(
              builder: (context, musicProvider, child) {
                if (_searchController.text.isEmpty) {
                  return const Center(
                    child: Text('Start typing to search for songs...'),
                  );
                }

                if (musicProvider.searchResults.isEmpty) {
                  return const Center(
                    child: Text('No songs found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: musicProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final song = musicProvider.searchResults[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 50,
                              color: AppColors.primary.withOpacity(0.1),
                              child: const Icon(Icons.music_note),
                            );
                          },
                        ),
                      ),
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      trailing: IconButton(
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
                      onTap: () async {
                        try {
                          final musicProvider = Provider.of<MusicProvider>(context, listen: false);
                          await musicProvider.playSong(song, playlist: musicProvider.searchResults);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print('Error playing search result: $e');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error playing "${song.title}"'),
                                backgroundColor: Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Playlists Bottom Sheet
class PlaylistsBottomSheet extends StatelessWidget {
  const PlaylistsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Text(
                  'Your Library',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Show create playlist dialog
                    _showCreatePlaylistDialog(context);
                  },
                ),
              ],
            ),
          ),
          
          // Favorites
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.secondaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
              ),
            ),
            title: const Text('Liked Songs'),
            subtitle: Consumer<MusicProvider>(
              builder: (context, musicProvider, child) {
                return Text('${musicProvider.favoriteSongs.length} songs');
              },
            ),
            onTap: () {
              Navigator.pop(context);
              // Navigate to favorites
            },
          ),
          
          // User Playlists
          Expanded(
            child: Consumer<MusicProvider>(
              builder: (context, musicProvider, child) {
                if (musicProvider.userPlaylists.isEmpty) {
                  return const Center(
                    child: Text('No playlists yet. Create your first playlist!'),
                  );
                }

                return ListView.builder(
                  itemCount: musicProvider.userPlaylists.length,
                  itemBuilder: (context, index) {
                    final playlist = musicProvider.userPlaylists[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: playlist.imageUrl.isNotEmpty
                            ? Image.network(
                                playlist.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                color: AppColors.primary.withOpacity(0.1),
                                child: const Icon(Icons.playlist_play),
                              ),
                      ),
                      title: Text(playlist.name),
                      subtitle: Text('${playlist.songCount} songs'),
                      onTap: () {
                        Navigator.pop(context);
                        context.go('${AppRoutes.playlist}/${playlist.id}');
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Playlist'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'Playlist name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Provider.of<MusicProvider>(context, listen: false)
                    .createPlaylist(nameController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}