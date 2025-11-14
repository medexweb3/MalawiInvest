import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/portfolio.dart';
import '../models/user.dart';
import '../utils/constants.dart';

/// Firebase service for storing and retrieving user data
class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  static const String _portfolioKey = 'portfolio';
  static const String _userKey = 'user';

  /// Save portfolio to Firebase (and cache locally)
  Future<void> savePortfolio(String userId, Portfolio portfolio) async {
    try {
      // Save to Firebase
      await _database
          .child('portfolios')
          .child(userId)
          .set(portfolio.toJson());

      // Cache locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '${_portfolioKey}_$userId',
        jsonEncode(portfolio.toJson()),
      );
    } catch (e) {
      // If Firebase fails, still cache locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '${_portfolioKey}_$userId',
        jsonEncode(portfolio.toJson()),
      );
      throw Exception('Failed to save portfolio: $e');
    }
  }

  /// Load portfolio from Firebase (or cache)
  Future<Portfolio?> loadPortfolio(String userId) async {
    try {
      // Try Firebase first
      final snapshot = await _database
          .child('portfolios')
          .child(userId)
          .get();

      if (snapshot.exists) {
        final portfolio = Portfolio.fromJson(
          Map<String, dynamic>.from(snapshot.value as Map),
        );
        
        // Update cache
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          '${_portfolioKey}_$userId',
          jsonEncode(portfolio.toJson()),
        );
        
        return portfolio;
      }
    } catch (e) {
      // Fallback to cache
    }

    // Fallback to local cache
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('${_portfolioKey}_$userId');
    if (cached != null) {
      return Portfolio.fromJson(
        Map<String, dynamic>.from(jsonDecode(cached)),
      );
    }

    // Return default portfolio for new users
    return Portfolio(
      cashBalance: initialCashBalance,
      holdings: [],
      history: [],
    );
  }

  /// Save user profile
  Future<void> saveUserProfile(AppUser user) async {
    try {
      await _database
          .child('users')
          .child(user.uid)
          .set(user.toJson());

      // Cache locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '${_userKey}_${user.uid}',
        jsonEncode(user.toJson()),
      );
    } catch (e) {
      // Cache locally even if Firebase fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '${_userKey}_${user.uid}',
        jsonEncode(user.toJson()),
      );
    }
  }

  /// Load user profile
  Future<AppUser?> loadUserProfile(String userId) async {
    try {
      final snapshot = await _database
          .child('users')
          .child(userId)
          .get();

      if (snapshot.exists) {
        return AppUser.fromJson(
          Map<String, dynamic>.from(snapshot.value as Map),
        );
      }
    } catch (e) {
      // Fallback to cache
    }

    // Fallback to local cache
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('${_userKey}_$userId');
    if (cached != null) {
      return AppUser.fromJson(
        Map<String, dynamic>.from(jsonDecode(cached)),
      );
    }

    return null;
  }

  /// Update user virtual coins
  Future<void> updateUserCoins(String userId, int coins) async {
    try {
      await _database
          .child('users')
          .child(userId)
          .child('virtualCoins')
          .set(coins);

      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('${_userKey}_$userId');
      if (cached != null) {
        final userJson = Map<String, dynamic>.from(jsonDecode(cached));
        userJson['virtualCoins'] = coins;
        await prefs.setString('${_userKey}_$userId', jsonEncode(userJson));
      }
    } catch (e) {
      // Handle error silently for offline mode
    }
  }

  /// Add badge to user
  Future<void> addBadge(String userId, String badge) async {
    try {
      final snapshot = await _database
          .child('users')
          .child(userId)
          .child('badges')
          .get();

      List<String> badges = [];
      if (snapshot.exists) {
        badges = List<String>.from(snapshot.value as List);
      }

      if (!badges.contains(badge)) {
        badges.add(badge);
        await _database
            .child('users')
            .child(userId)
            .child('badges')
            .set(badges);
      }
    } catch (e) {
      // Handle error silently
    }
  }
}

