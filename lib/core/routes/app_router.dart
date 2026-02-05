import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/player/player_screen.dart';
import '../../features/playlist/playlist_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/liked_songs_screen.dart';
import '../../features/profile/recently_played_screen.dart';
import '../../features/profile/downloaded_music_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/profile/help_support_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = authProvider.isAuthenticated;
      final isOnSplash = state.uri.toString() == AppRoutes.splash;
      final isOnOnboarding = state.uri.toString() == AppRoutes.onboarding;
      final isOnAuth = state.uri.toString() == AppRoutes.login || state.uri.toString() == AppRoutes.register;

      // If on splash, let it handle the navigation
      if (isOnSplash) return null;

      // If not authenticated and not on auth screens, redirect to login
      if (!isAuthenticated && !isOnAuth && !isOnOnboarding) {
        return AppRoutes.login;
      }

      // If authenticated and on auth screens, redirect to home
      if (isAuthenticated && (isOnAuth || isOnOnboarding)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.player,
        name: 'player',
        builder: (context, state) => const PlayerScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.playlist}/:id',
        name: 'playlist',
        builder: (context, state) {
          final playlistId = state.pathParameters['id']!;
          return PlaylistScreen(playlistId: playlistId);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.likedSongs,
        name: 'liked-songs',
        builder: (context, state) => const LikedSongsScreen(),
      ),
      GoRoute(
        path: AppRoutes.recentlyPlayed,
        name: 'recently-played',
        builder: (context, state) => const RecentlyPlayedScreen(),
      ),
      GoRoute(
        path: AppRoutes.downloadedMusic,
        name: 'downloaded-music',
        builder: (context, state) => const DownloadedMusicScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.helpSupport,
        name: 'help-support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}