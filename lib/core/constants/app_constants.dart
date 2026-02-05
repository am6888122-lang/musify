class AppConstants {
  // App Info
  static const String appName = 'Musify';
  static const String appVersion = '1.0.0';
  
  // API
  static const String baseUrl = 'https://api.musify.com/v1';
  static const String apiKey = 'your_api_key_here';
  
  // Storage Keys
  static const String userBox = 'user_box';
  static const String songsBox = 'songs_box';
  static const String playlistsBox = 'playlists_box';
  static const String favoritesBox = 'favorites_box';
  
  // Preferences Keys
  static const String themeKey = 'theme_mode';
  static const String onboardingKey = 'onboarding_completed';
  static const String userTokenKey = 'user_token';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
}