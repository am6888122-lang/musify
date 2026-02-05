import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class FirebaseAuthService {
  static final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current Firebase user
  static firebase_auth.User? get currentFirebaseUser => _auth.currentUser;

  // Check if user is signed in
  static bool get isSignedIn => _auth.currentUser != null;

  // Register with email and password
  static Future<Map<String, dynamic>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Check if email already exists
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        return {
          'success': false,
          'message': 'Account already exists. Please login instead.',
        };
      }

      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return {
          'success': false,
          'message': 'Failed to create account',
        };
      }

      // Update display name
      await firebaseUser.updateDisplayName(name);

      // Create user document in Firestore
      final user = User(
        id: firebaseUser.uid,
        name: name,
        email: email,
        profileImageUrl: firebaseUser.photoURL ?? '',
        createdAt: DateTime.now(),
        favoriteGenres: [],
        isPremium: false,
      );

      await _firestore.collection('users').doc(firebaseUser.uid).set({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'profileImageUrl': user.profileImageUrl,
        'createdAt': user.createdAt.toIso8601String(),
        'favoriteGenres': user.favoriteGenres,
        'isPremium': user.isPremium,
      });

      return {
        'success': true,
        'token': await firebaseUser.getIdToken(),
        'user': {
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'profileImageUrl': user.profileImageUrl,
          'createdAt': user.createdAt.toIso8601String(),
          'favoriteGenres': user.favoriteGenres,
          'isPremium': user.isPremium,
        },
      };
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Account already exists. Please login instead.';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'weak-password':
          message = 'Password is too weak. Use at least 6 characters.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        default:
          message = e.message ?? 'Registration failed';
      }

      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }

  // Login with email and password
  static Future<Map<String, dynamic>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with email and password
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return {
          'success': false,
          'message': 'Login failed',
        };
      }

      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      
      if (!userDoc.exists) {
        return {
          'success': false,
          'message': 'User data not found',
        };
      }

      final userData = userDoc.data()!;

      return {
        'success': true,
        'token': await firebaseUser.getIdToken(),
        'user': {
          'id': userData['id'],
          'name': userData['name'],
          'email': userData['email'],
          'profileImageUrl': userData['profileImageUrl'] ?? '',
          'createdAt': userData['createdAt'],
          'favoriteGenres': List<String>.from(userData['favoriteGenres'] ?? []),
          'isPremium': userData['isPremium'] ?? false,
        },
      };
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Login failed';
      
      switch (e.code) {
        case 'user-not-found':
          message = 'Account not found. Please register first.';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        default:
          message = e.message ?? 'Login failed';
      }

      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send password reset email
  static Future<Map<String, dynamic>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent',
      };
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Failed to send reset email';
      
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = e.message ?? 'Failed to send reset email';
      }

      return {
        'success': false,
        'message': message,
      };
    }
  }

  // Update user profile
  static Future<bool> updateUserProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      if (name != null) {
        await user.updateDisplayName(name);
      }

      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Update Firestore
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (photoUrl != null) updates['profileImageUrl'] = photoUrl;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updates);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete account
  static Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Delete user document from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete Firebase Auth account
      await user.delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
