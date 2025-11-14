import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';

/// Auth provider for managing user authentication state
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseService _firebaseService = FirebaseService();

  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && !_user!.isGuest;

  AuthProvider() {
    _initAuth();
  }

  /// Initialize auth state listener
  void _initAuth() {
    _authService.authStateChanges.listen((firebaseUser) async {
      try {
        if (firebaseUser != null) {
          // Load user profile from Firebase
          final appUser = await _firebaseService.loadUserProfile(firebaseUser.uid);
          _user = appUser ?? AppUser(
            uid: firebaseUser.uid,
            email: firebaseUser.email,
            displayName: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL,
            isGuest: false,
            createdAt: firebaseUser.metadata.creationTime,
          );
          await _firebaseService.saveUserProfile(_user!);
        } else {
          _user = null;
        }
        notifyListeners();
      } catch (e) {
        debugPrint('Auth state listener error: $e');
        // Don't crash the app, just log the error
      }
    });
  }

  /// Sign in with email
  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final appUser = await _authService.signInWithEmail(email, password);
      if (appUser != null) {
        _user = await _firebaseService.loadUserProfile(appUser.uid) ?? appUser;
        await _firebaseService.saveUserProfile(_user!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign up with email
  Future<bool> signUpWithEmail(String email, String password, String displayName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final appUser = await _authService.signUpWithEmail(email, password, displayName);
      if (appUser != null) {
        _user = appUser;
        await _firebaseService.saveUserProfile(_user!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final appUser = await _authService.signInWithGoogle();
      if (appUser != null) {
        _user = await _firebaseService.loadUserProfile(appUser.uid) ?? appUser;
        await _firebaseService.saveUserProfile(_user!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in as guest
  Future<void> signInAsGuest() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.signInAsGuest();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _user = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user coins
  Future<void> updateCoins(int coins) async {
    if (_user == null) return;
    
    _user = _user!.copyWith(virtualCoins: coins);
    await _firebaseService.updateUserCoins(_user!.uid, coins);
    notifyListeners();
  }

  /// Add badge
  Future<void> addBadge(String badge) async {
    if (_user == null) return;
    
    if (!_user!.badges.contains(badge)) {
      final newBadges = List<String>.from(_user!.badges)..add(badge);
      _user = _user!.copyWith(badges: newBadges);
      await _firebaseService.addBadge(_user!.uid, badge);
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

