import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'auth_provider.dart';
import 'music_provider.dart';

class AppProviders {
  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider()..init(),
    ),
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider()..init(),
    ),
    ChangeNotifierProvider<MusicProvider>(
      create: (context) => MusicProvider()..init(),
    ),
  ];
}