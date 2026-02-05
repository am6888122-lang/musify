class AppConfig {
  // Development mode settings
  static const bool isDevelopment = true;
  static const bool enableFirebase = false;
  static const bool enableGoogleSignIn = false;
  static const bool enableAudioService = true;
  static const bool enableHiveStorage = true;
  
  // API Configuration
  static const String apiBaseUrl = 'https://api.musify.com/v1';
  static const bool useMockApi = true;
  
  // Audio Configuration
  static const bool enableBackgroundAudio = true;
  static const bool enableNotificationControls = true;
  
  // UI Configuration
  static const bool enableAnimations = true;
  static const bool enableHapticFeedback = true;
  
  // Debug Configuration
  static const bool showDebugInfo = isDevelopment;
  static const bool logNetworkRequests = isDevelopment;
  static const bool logAudioEvents = isDevelopment;
  
  // Feature Flags
  static const bool enableOfflineMode = false;
  static const bool enableSocialFeatures = false;
  static const bool enablePremiumFeatures = false;
  
  // Cache Configuration
  static const int imageCacheMaxAge = 7; // days
  static const int audioCacheMaxAge = 30; // days
  static const int maxCachedSongs = 100;
  
  // Performance Configuration
  static const int maxConcurrentDownloads = 3;
  static const int networkTimeoutSeconds = 30;
  static const int retryAttempts = 3;
}