import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import '../models/user.dart';

/// Authentication service for Firebase Auth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Configure GoogleSignIn - works on both web and mobile
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current Firebase user
  User? get currentUser => _auth.currentUser;

  /// Sign in with email and password
  Future<AppUser?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(credential.user);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /// Sign up with email and password
  Future<AppUser?> signUpWithEmail(String email, String password, String displayName) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await credential.user?.updateDisplayName(displayName);
      await credential.user?.reload();
      
      return _userFromFirebase(credential.user);
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  /// Sign in with Google
  Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      // More detailed error for debugging
      debugPrint('Google sign in error: $e');
      throw Exception('Google sign in failed: $e');
    }
  }

  /// Sign in as guest
  Future<AppUser> signInAsGuest() async {
    // For guest mode, we create a local user without Firebase auth
    return AppUser.guest();
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      // Sign out from Google (works on web too)
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      } else {
        // On web, GoogleSignIn handles it automatically
        try {
          await _googleSignIn.signOut();
        } catch (e) {
          debugPrint('Google sign out error (web): $e');
        }
      }
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
      // Don't throw - allow sign out to complete even if Google sign out fails
    }
  }

  /// Convert Firebase User to AppUser
  AppUser? _userFromFirebase(User? user) {
    if (user == null) return null;
    
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isGuest: false,
      createdAt: user.metadata.creationTime,
    );
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }
}

