import 'package:flutter/material.dart';
import '../models/stock.dart';

/// App-wide constants including colors, mock data, and configuration

// Color Scheme - MSE-inspired black and orange
class AppColors {
  static const Color primary = Color(0xFFFF6600); // Orange
  static const Color primaryDark = Color(0xFFCC5200);
  static const Color secondary = Color(0xFF000000); // Black
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}

// Initial cash balance for new users (MWK)
const double initialCashBalance = 100000.0;

// Price update interval (seconds)
const int priceUpdateInterval = 30;

// Mock MSE Stocks Data
final List<Map<String, dynamic>> mockStocksJson = [
  {
    "symbol": "ILLO",
    "name": "Illovo Sugar Malawi",
    "sector": "Agriculture",
    "price": 1500.0,
    "change": 2.5,
    "volume": 1000,
    "ohlc": [
      {"open": 1450, "high": 1520, "low": 1440, "close": 1500, "time": "2024-01-01"},
      {"open": 1500, "high": 1510, "low": 1480, "close": 1495, "time": "2024-01-02"},
      {"open": 1495, "high": 1505, "low": 1485, "close": 1502, "time": "2024-01-03"},
      {"open": 1502, "high": 1515, "low": 1498, "close": 1510, "time": "2024-01-04"},
      {"open": 1510, "high": 1520, "low": 1500, "close": 1515, "time": "2024-01-05"},
      {"open": 1515, "high": 1525, "low": 1505, "close": 1520, "time": "2024-01-06"},
      {"open": 1520, "high": 1530, "low": 1510, "close": 1500, "time": "2024-01-07"},
    ]
  },
  {
    "symbol": "FDH",
    "name": "FDH Bank",
    "sector": "Banking",
    "price": 200.0,
    "change": -1.2,
    "volume": 2500,
    "ohlc": [
      {"open": 205, "high": 210, "low": 198, "close": 200, "time": "2024-01-01"},
      {"open": 200, "high": 202, "low": 195, "close": 198, "time": "2024-01-02"},
      {"open": 198, "high": 201, "low": 197, "close": 200, "time": "2024-01-03"},
      {"open": 200, "high": 203, "low": 199, "close": 201, "time": "2024-01-04"},
      {"open": 201, "high": 205, "low": 200, "close": 202, "time": "2024-01-05"},
      {"open": 202, "high": 204, "low": 199, "close": 200, "time": "2024-01-06"},
      {"open": 200, "high": 201, "low": 198, "close": 200, "time": "2024-01-07"},
    ]
  },
  {
    "symbol": "NBS",
    "name": "National Bank of Malawi",
    "sector": "Banking",
    "price": 850.0,
    "change": 0.8,
    "volume": 800,
    "ohlc": [
      {"open": 840, "high": 860, "low": 835, "close": 850, "time": "2024-01-01"},
      {"open": 850, "high": 855, "low": 845, "close": 848, "time": "2024-01-02"},
      {"open": 848, "high": 852, "low": 846, "close": 850, "time": "2024-01-03"},
      {"open": 850, "high": 855, "low": 848, "close": 852, "time": "2024-01-04"},
      {"open": 852, "high": 858, "low": 850, "close": 855, "time": "2024-01-05"},
      {"open": 855, "high": 860, "low": 853, "close": 857, "time": "2024-01-06"},
      {"open": 857, "high": 860, "low": 850, "close": 850, "time": "2024-01-07"},
    ]
  },
  {
    "symbol": "STANBIC",
    "name": "Stanbic Bank Malawi",
    "sector": "Banking",
    "price": 320.0,
    "change": 1.5,
    "volume": 1200,
    "ohlc": [
      {"open": 315, "high": 325, "low": 310, "close": 320, "time": "2024-01-01"},
      {"open": 320, "high": 322, "low": 318, "close": 319, "time": "2024-01-02"},
      {"open": 319, "high": 321, "low": 317, "close": 320, "time": "2024-01-03"},
      {"open": 320, "high": 323, "low": 319, "close": 321, "time": "2024-01-04"},
      {"open": 321, "high": 325, "low": 320, "close": 322, "time": "2024-01-05"},
      {"open": 322, "high": 324, "low": 320, "close": 321, "time": "2024-01-06"},
      {"open": 321, "high": 323, "low": 318, "close": 320, "time": "2024-01-07"},
    ]
  },
  {
    "symbol": "TNM",
    "name": "Telekom Networks Malawi",
    "sector": "Telecommunications",
    "price": 45.0,
    "change": -0.5,
    "volume": 5000,
    "ohlc": [
      {"open": 46, "high": 47, "low": 44, "close": 45, "time": "2024-01-01"},
      {"open": 45, "high": 46, "low": 44, "close": 45, "time": "2024-01-02"},
      {"open": 45, "high": 46, "low": 44, "close": 45, "time": "2024-01-03"},
      {"open": 45, "high": 46, "low": 44, "close": 45, "time": "2024-01-04"},
      {"open": 45, "high": 46, "low": 44, "close": 45, "time": "2024-01-05"},
      {"open": 45, "high": 46, "low": 44, "close": 45, "time": "2024-01-06"},
      {"open": 45, "high": 46, "low": 44, "close": 45, "time": "2024-01-07"},
    ]
  },
  {
    "symbol": "AIRTEL",
    "name": "Airtel Malawi",
    "sector": "Telecommunications",
    "price": 38.0,
    "change": 1.8,
    "volume": 6000,
    "ohlc": [
      {"open": 37, "high": 39, "low": 36, "close": 38, "time": "2024-01-01"},
      {"open": 38, "high": 39, "low": 37, "close": 38, "time": "2024-01-02"},
      {"open": 38, "high": 39, "low": 37, "close": 38, "time": "2024-01-03"},
      {"open": 38, "high": 39, "low": 37, "close": 38, "time": "2024-01-04"},
      {"open": 38, "high": 39, "low": 37, "close": 38, "time": "2024-01-05"},
      {"open": 38, "high": 39, "low": 37, "close": 38, "time": "2024-01-06"},
      {"open": 38, "high": 39, "low": 37, "close": 38, "time": "2024-01-07"},
    ]
  },
  {
    "symbol": "PRESS",
    "name": "Press Corporation",
    "sector": "Conglomerate",
    "price": 1200.0,
    "change": -2.1,
    "volume": 600,
    "ohlc": [
      {"open": 1230, "high": 1240, "low": 1190, "close": 1200, "time": "2024-01-01"},
      {"open": 1200, "high": 1210, "low": 1180, "close": 1195, "time": "2024-01-02"},
      {"open": 1195, "high": 1205, "low": 1190, "close": 1200, "time": "2024-01-03"},
      {"open": 1200, "high": 1215, "low": 1195, "close": 1210, "time": "2024-01-04"},
      {"open": 1210, "high": 1220, "low": 1205, "close": 1215, "time": "2024-01-05"},
      {"open": 1215, "high": 1225, "low": 1205, "close": 1200, "time": "2024-01-06"},
      {"open": 1200, "high": 1210, "low": 1190, "close": 1200, "time": "2024-01-07"},
    ]
  },
  {
    "symbol": "FMB",
    "name": "First Merchant Bank",
    "sector": "Banking",
    "price": 180.0,
    "change": 0.3,
    "volume": 1500,
    "ohlc": [
      {"open": 179, "high": 182, "low": 177, "close": 180, "time": "2024-01-01"},
      {"open": 180, "high": 181, "low": 178, "close": 179, "time": "2024-01-02"},
      {"open": 179, "high": 180, "low": 178, "close": 180, "time": "2024-01-03"},
      {"open": 180, "high": 181, "low": 179, "close": 180, "time": "2024-01-04"},
      {"open": 180, "high": 182, "low": 179, "close": 181, "time": "2024-01-05"},
      {"open": 181, "high": 182, "low": 179, "close": 180, "time": "2024-01-06"},
      {"open": 180, "high": 181, "low": 178, "close": 180, "time": "2024-01-07"},
    ]
  },
  {
    "symbol": "ICON",
    "name": "Icon Properties",
    "sector": "Real Estate",
    "price": 95.0,
    "change": 2.2,
    "volume": 800,
    "ohlc": [
      {"open": 93, "high": 96, "low": 92, "close": 95, "time": "2024-01-01"},
      {"open": 95, "high": 96, "low": 94, "close": 95, "time": "2024-01-02"},
      {"open": 95, "high": 96, "low": 94, "close": 95, "time": "2024-01-03"},
      {"open": 95, "high": 96, "low": 94, "close": 95, "time": "2024-01-04"},
      {"open": 95, "high": 96, "low": 94, "close": 95, "time": "2024-01-05"},
      {"open": 95, "high": 96, "low": 94, "close": 95, "time": "2024-01-06"},
      {"open": 95, "high": 96, "low": 94, "close": 95, "time": "2024-01-07"},
    ]
  },
  {
    "symbol": "OMU",
    "name": "Old Mutual Malawi",
    "sector": "Insurance",
    "price": 550.0,
    "change": -0.9,
    "volume": 400,
    "ohlc": [
      {"open": 555, "high": 560, "low": 545, "close": 550, "time": "2024-01-01"},
      {"open": 550, "high": 552, "low": 548, "close": 549, "time": "2024-01-02"},
      {"open": 549, "high": 551, "low": 548, "close": 550, "time": "2024-01-03"},
      {"open": 550, "high": 553, "low": 549, "close": 551, "time": "2024-01-04"},
      {"open": 551, "high": 555, "low": 550, "close": 552, "time": "2024-01-05"},
      {"open": 552, "high": 554, "low": 550, "close": 550, "time": "2024-01-06"},
      {"open": 550, "high": 552, "low": 548, "close": 550, "time": "2024-01-07"},
    ]
  },
];

// Tips of the day
final List<String> tipsOfTheDay = [
  "Diversify your portfolio across different sectors like banking, agriculture, and telecom.",
  "Start with small investments and learn as you go. Practice makes perfect!",
  "Keep an eye on volume - higher volume often means more market interest.",
  "Don't panic sell during short-term dips. Long-term investing is key.",
  "Research companies before investing. Understand their business model.",
  "Set realistic goals and stick to your investment strategy.",
  "Learn from successful investors on the NGX and other African exchanges.",
  "Track your P&L regularly to understand your performance.",
  "Consider dollar-cost averaging - invest regularly over time.",
  "Stay informed about market news and economic indicators.",
];

// Mock community feed posts
final List<Map<String, dynamic>> mockCommunityPosts = [
  {
    "user": "Investor_Pro",
    "message": "Just beat the market by 2% this week! 🎉",
    "likes": 45,
    "time": "2 hours ago",
  },
  {
    "user": "MSE_Newbie",
    "message": "First profitable trade today! Learning so much.",
    "likes": 32,
    "time": "5 hours ago",
  },
  {
    "user": "TradingGuru",
    "message": "ILLO showing strong momentum. Keep an eye on it!",
    "likes": 67,
    "time": "1 day ago",
  },
  {
    "user": "FinanceFan",
    "message": "Diversification is key! Don't put all eggs in one basket.",
    "likes": 89,
    "time": "1 day ago",
  },
  {
    "user": "MarketWatcher",
    "message": "Banking sector looking solid this quarter.",
    "likes": 54,
    "time": "2 days ago",
  },
];

