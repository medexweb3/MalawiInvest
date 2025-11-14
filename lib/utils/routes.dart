import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/stock_detail_screen.dart';
import '../screens/portfolio_screen.dart';
import '../screens/resources_screen.dart';
import '../screens/challenges_screen.dart';
import '../screens/profile_screen.dart';

/// App routing configuration using GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) {
        final signUp = state.uri.queryParameters['mode'] == 'signup';
        return AuthScreen(initialSignUpMode: signUp);
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/stock/:symbol',
      builder: (context, state) {
        final symbol = state.pathParameters['symbol']!;
        return StockDetailScreen(symbol: symbol);
      },
    ),
    GoRoute(
      path: '/portfolio',
      builder: (context, state) => const PortfolioScreen(),
    ),
    GoRoute(
      path: '/resources',
      builder: (context, state) => const ResourcesScreen(),
    ),
    GoRoute(
      path: '/challenges',
      builder: (context, state) => const ChallengesScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

/// Helper extension for easy navigation
extension NavigationExtension on BuildContext {
  void navigateToStock(String symbol) {
    go('/stock/$symbol');
  }

  void navigateToHome() {
    go('/home');
  }

  void navigateToPortfolio() {
    go('/portfolio');
  }

  void navigateToResources() {
    go('/resources');
  }

  void navigateToChallenges() {
    go('/challenges');
  }

  void navigateToProfile() {
    go('/profile');
  }
}

