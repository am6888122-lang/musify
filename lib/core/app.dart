import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/music_provider.dart';
import 'routes/app_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Listen to auth changes and load user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final musicProvider = Provider.of<MusicProvider>(context, listen: false);
      
      authProvider.addListener(() {
        final user = authProvider.user;
        if (user != null && authProvider.isAuthenticated) {
          // User logged in - load their data
          musicProvider.loadUserData(user.id);
        } else {
          // User logged out - clear data
          musicProvider.clearUserData();
        }
      });
      
      // Load data if already authenticated
      if (authProvider.isAuthenticated && authProvider.user != null) {
        musicProvider.loadUserData(authProvider.user!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Musify',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}