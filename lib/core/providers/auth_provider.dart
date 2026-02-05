import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/firebase_auth_service.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../services/image_service.dart';
import '../constants/app_constants.dart';

// Set this to false to use local storage only (no Firebase)
const bool USE_FIREBASE = false;

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.initial;
  User? _user;
  String? _token;
  String? _errorMessage;
  late SharedPreferences _prefs;

  // Getters
  AuthState get state => _state;
  User? get user => _user;
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated && _user != null;
  bool get isLoading => _state == AuthState.loading;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _setState(AuthState.loading);

    try {
      _token = _prefs.getString(AppConstants.userTokenKey);

      if (_token != null) {
        // Try to get user from local storage
        _user = HiveService.getCurrentUser();

        if (_user != null) {
          _setState(AuthState.authenticated);
        } else {
          // Token exists but no user data, clear token
          await _clearAuthData();
          _setState(AuthState.unauthenticated);
        }
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setError('Failed to check authentication status');
    }
  }

  Future<bool> login(String email, String password) async {
    _setState(AuthState.loading);

    try {
      Map<String, dynamic> response;
      
      if (USE_FIREBASE) {
        // Use Firebase Authentication
        response = await FirebaseAuthService.loginWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // Use local storage only
        if (!HiveService.isAccountRegistered(email)) {
          _setError('Account not found. Please register first.');
          return false;
        }
        response = await ApiService.login(email, password);
      }

      if (response['success'] == true) {
        _token = response['token'];
        _user = User.fromJson(response['user']);

        // Save to local storage
        await _prefs.setString(AppConstants.userTokenKey, _token!);
        await HiveService.saveUser(_user!);

        _setState(AuthState.authenticated);
        
        // Notify to load user-specific data
        notifyListeners();
        
        return true;
      } else {
        _setError(response['message'] ?? 'Login failed');
        return false;
      }
    } catch (e) {
      _setError('Network error. Please try again.');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setState(AuthState.loading);

    try {
      Map<String, dynamic> response;
      
      if (USE_FIREBASE) {
        // Use Firebase Authentication
        response = await FirebaseAuthService.registerWithEmailAndPassword(
          name: name,
          email: email,
          password: password,
        );
      } else {
        // Use local storage only
        if (HiveService.isAccountRegistered(email)) {
          _setError('Account already exists. Please login instead.');
          return false;
        }
        response = await ApiService.register(name, email, password);
      }

      if (response['success'] == true) {
        final user = User.fromJson(response['user']);

        // Save to local storage for offline access (but don't login yet)
        await HiveService.saveRegisteredAccount(user);

        // Don't save token or current user - user needs to login
        // This ensures user goes to login screen after registration
        _setState(AuthState.unauthenticated);
        return true;
      } else {
        _setError(response['message'] ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      _setError('Network error. Please try again.');
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    // Google Sign-In is disabled for testing
    _setError('Google Sign-In is disabled in development mode.');
    return false;

    /*
    if (!AppConfig.enableGoogleSignIn) {
      _setError('Google Sign-In is disabled in development mode.');
      return false;
    }

    _setState(AuthState.loading);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _setState(AuthState.unauthenticated);
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create user from Google data
      _user = User(
        id: googleUser.id,
        name: googleUser.displayName ?? '',
        email: googleUser.email,
        profileImageUrl: googleUser.photoUrl ?? '',
        createdAt: DateTime.now(),
      );

      _token = googleAuth.accessToken ?? 'google_token_${DateTime.now().millisecondsSinceEpoch}';

      // Save to local storage
      await _prefs.setString(AppConstants.userTokenKey, _token!);
      await HiveService.saveUser(_user!);

      _setState(AuthState.authenticated);
      return true;
    } catch (e) {
      if (AppConfig.showDebugInfo) {
        print('Google Sign-In Error: $e');
      }
      _setError('Google sign in is not available in development mode.');
      return false;
    }
    */
  }

  Future<void> logout() async {
    _setState(AuthState.loading);

    try {
      // Sign out from Firebase if using it
      if (USE_FIREBASE) {
        await FirebaseAuthService.signOut();
      }

      await _clearAuthData();
      _setState(AuthState.unauthenticated);
    } catch (e) {
      _setError('Logout failed');
    }
  }

  Future<void> _clearAuthData() async {
    _token = null;
    _user = null;
    await _prefs.remove(AppConstants.userTokenKey);
    await HiveService.deleteUser();
  }

  void _setState(AuthState state) {
    _state = state;
    if (state != AuthState.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setState(AuthState.error);
  }

  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _setState(_user != null ? AuthState.authenticated : AuthState.unauthenticated);
    }
  }

  // Profile Image Management
  Future<bool> updateProfileImageFromCamera() async {
    if (_user == null) return false;

    try {
      _setState(AuthState.loading);

      // التقاط صورة من الكاميرا
      final imageFile = await ImageService.pickImageFromCamera();

      if (imageFile != null) {
        // Delete old local image if exists
        if (_user!.localProfileImagePath.isNotEmpty) {
          await ImageService.deleteOldProfileImage(_user!.localProfileImagePath);
        }

        // Update user with new image path
        _user = _user!.copyWith(localProfileImagePath: imageFile.path);

        // Save updated user
        await HiveService.saveUser(_user!);

        _setState(AuthState.authenticated);
        return true;
      }

      _setState(AuthState.authenticated);
      return false;
    } catch (e) {
      print('Error updating profile image from camera: $e');
      _setError('Failed to take photo');
      return false;
    }
  }

  Future<bool> updateProfileImageFromGallery() async {
    if (_user == null) return false;

    try {
      _setState(AuthState.loading);

      // اختيار صورة من المعرض
      final imageFile = await ImageService.pickImageFromGallery();

      if (imageFile != null) {
        // Delete old local image if exists
        if (_user!.localProfileImagePath.isNotEmpty) {
          await ImageService.deleteOldProfileImage(_user!.localProfileImagePath);
        }

        // Update user with new image path
        _user = _user!.copyWith(localProfileImagePath: imageFile.path);

        // Save updated user
        await HiveService.saveUser(_user!);

        _setState(AuthState.authenticated);
        return true;
      }

      _setState(AuthState.authenticated);
      return false;
    } catch (e) {
      print('Error updating profile image from gallery: $e');
      _setError('Failed to select photo');
      return false;
    }
  }

  Future<bool> removeProfileImage() async {
    if (_user == null) return false;

    try {
      _setState(AuthState.loading);

      // Delete local image if exists
      if (_user!.localProfileImagePath.isNotEmpty) {
        await ImageService.deleteOldProfileImage(_user!.localProfileImagePath);
      }

      // Update user to remove image path
      _user = _user!.copyWith(localProfileImagePath: '', profileImageUrl: '');

      // Save updated user
      await HiveService.saveUser(_user!);

      _setState(AuthState.authenticated);
      return true;
    } catch (e) {
      _setError('Failed to remove profile image');
      return false;
    }
  }

  Future<bool> updateProfile({String? name, String? email}) async {
    if (_user == null) return false;

    try {
      _setState(AuthState.loading);

      // Update user data
      _user = _user!.copyWith(name: name ?? _user!.name, email: email ?? _user!.email);

      // Save updated user
      await HiveService.saveUser(_user!);

      _setState(AuthState.authenticated);
      return true;
    } catch (e) {
      _setError('Failed to update profile');
      return false;
    }
  }

  String getProfileImagePath() {
    if (_user == null) return '';

    // Return local image path if exists and file exists
    if (_user!.localProfileImagePath.isNotEmpty) {
      return _user!.localProfileImagePath;
    }

    // Return network image URL if exists
    if (_user!.profileImageUrl.isNotEmpty) {
      return _user!.profileImageUrl;
    }

    return '';
  }

  bool hasProfileImage() {
    return getProfileImagePath().isNotEmpty;
  }
}
