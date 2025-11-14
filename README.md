# Malawi Invest - MSE Trading Demo App

A cross-platform Flutter mobile app for simulating stock trading on the Malawi Stock Exchange (MSE). This educational app helps beginners learn about investing with virtual trading, using mock data since MSE lacks real-time APIs.

## Features

- 📊 **Live Market Simulation**: 10 MSE stocks with prices updating every 30 seconds
- 💼 **Virtual Portfolio**: Start with 100,000 MWK and practice trading risk-free
- 📈 **Interactive Charts**: Line and candlestick charts using fl_chart
- 📚 **Educational Resources**: Guides, videos, and quizzes
- 🎮 **Gamification**: Daily quizzes, price prediction games, badges, and rewards
- 🔐 **Authentication**: Email/Google sign-in via Firebase (guest mode available)
- 📱 **Offline Support**: Cached data with SharedPreferences
- 🎨 **Modern UI**: Material Design with MSE-inspired black and orange theme

## Tech Stack

- **Flutter 3.x** (Dart)
- **State Management**: Provider
- **Backend**: Firebase (Auth, Realtime Database, Firestore)
- **Charts**: fl_chart
- **Other Packages**: 
  - firebase_core, firebase_auth, cloud_firestore, firebase_database
  - http, shared_preferences
  - lottie, confetti
  - pdf, printing
  - youtube_player_flutter
  - go_router

## Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   ├── stock.dart
│   ├── portfolio.dart
│   └── user.dart
├── services/
│   ├── firebase_service.dart
│   ├── mock_data_service.dart
│   └── auth_service.dart
├── providers/
│   ├── stock_provider.dart
│   ├── portfolio_provider.dart
│   └── auth_provider.dart
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   ├── stock_detail_screen.dart
│   ├── portfolio_screen.dart
│   ├── resources_screen.dart
│   └── challenges_screen.dart
├── widgets/
│   ├── stock_card.dart
│   ├── chart_widget.dart
│   ├── buy_sell_dialog.dart
│   └── badge_widget.dart
└── utils/
    ├── constants.dart
    └── routes.dart
```

## Setup Instructions

### Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Android Studio / Xcode (for mobile development)
- Firebase account (optional, for full functionality)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd malawi_invest
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup (Optional but Recommended)**

   For full functionality (authentication, cloud storage):
   
   a. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
   
   b. Configure Firebase:
   ```bash
   flutterfire configure
   ```
   
   This will:
   - Create/select a Firebase project
   - Generate `firebase_options.dart` with your actual config
   - Set up Android and iOS apps
   
   c. For Android, download `google-services.json` from Firebase Console and place it in:
   ```
   android/app/google-services.json
   ```
   
   d. For iOS, download `GoogleService-Info.plist` and add it to:
   ```
   ios/Runner/GoogleService-Info.plist
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Running Without Firebase

The app can run in **offline/guest mode** without Firebase setup:
- All features work with local storage (SharedPreferences)
- Authentication uses guest mode
- Portfolio data is cached locally
- Stock prices update from mock data

## Mock Data

The app includes 10 mock MSE stocks:
- **ILLO** - Illovo Sugar Malawi (Agriculture)
- **FDH** - FDH Bank (Banking)
- **NBS** - National Bank of Malawi (Banking)
- **STANBIC** - Stanbic Bank Malawi (Banking)
- **TNM** - Telekom Networks Malawi (Telecommunications)
- **AIRTEL** - Airtel Malawi (Telecommunications)
- **PRESS** - Press Corporation (Conglomerate)
- **FMB** - First Merchant Bank (Banking)
- **ICON** - Icon Properties (Real Estate)
- **OMU** - Old Mutual Malawi (Insurance)

Prices update every 30 seconds with random fluctuations (±5%).

## Key Features Explained

### 1. Stock Trading
- View real-time (simulated) prices
- Buy/sell stocks with virtual money
- Track portfolio performance
- View detailed charts (line and candlestick)

### 2. Portfolio Management
- Start with 100,000 MWK
- Track holdings with P&L calculations
- View performance graphs
- Export portfolio as PDF

### 3. Educational Resources
- **Guides**: Learn about stocks, MSE brokers, P&L
- **Videos**: YouTube integration (replace placeholder IDs)
- **Quizzes**: Test your knowledge

### 4. Challenges & Gamification
- **Daily Quiz**: 5 questions, earn coins
- **Price Prediction**: Predict stock movements
- **Badges**: Earn achievements
- **Community Feed**: See mock social posts

## Adding Real MSE Data

To integrate real MSE data in the future:

1. **Create API Service**
   - Replace `MockDataService` with `MSEApiService`
   - Fetch real-time data from MSE API (when available)
   - Update `StockProvider` to use API instead of mock data

2. **Update Stock Model**
   - Add fields as needed for real data
   - Handle API response format

3. **Error Handling**
   - Add network error handling
   - Fallback to cached data when offline

## Configuration

### Colors
Edit `lib/utils/constants.dart` to customize:
- Primary color (orange)
- Secondary color (black)
- Other theme colors

### Initial Cash Balance
Change `initialCashBalance` in `lib/utils/constants.dart`:
```dart
const double initialCashBalance = 100000.0; // MWK
```

### Price Update Interval
Modify `priceUpdateInterval` in `lib/utils/constants.dart`:
```dart
const int priceUpdateInterval = 30; // seconds
```

## Testing

Run tests:
```bash
flutter test
```

## Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Troubleshooting

### Firebase Errors
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in place
- Verify Firebase project settings
- Check internet connection for Firebase services

### Build Errors
- Run `flutter clean` and `flutter pub get`
- Ensure all dependencies are compatible
- Check Flutter/Dart version compatibility

### App Crashes
- Check logs: `flutter logs`
- Verify all required permissions are set
- Ensure Firebase is properly initialized

## Future Enhancements

- [ ] Real-time MSE API integration
- [ ] Push notifications for price alerts
- [ ] Social features (real community feed)
- [ ] Advanced charting (technical indicators)
- [ ] News feed integration
- [ ] More educational content
- [ ] Multi-language support (Chichewa)

## License

This project is for educational purposes. Mock data is used for demonstration only.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues or questions, please open an issue on the repository.

---

**Note**: This is a demo/educational app. No real money transactions occur. All trading is virtual and for learning purposes only.
