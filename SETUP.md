# Quick Setup Guide

## Step 1: Install Dependencies

```bash
flutter pub get
```

## Step 2: Firebase Setup (Optional)

The app works without Firebase in guest mode, but for full features:

1. Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Run configuration:
```bash
flutterfire configure
```

3. Follow the prompts to:
   - Select/create Firebase project
   - Choose platforms (Android, iOS)
   - This generates `firebase_options.dart` automatically

4. For Android: Download `google-services.json` from Firebase Console → Project Settings → Your apps → Android app, and place in:
   ```
   android/app/google-services.json
   ```

5. For iOS: Download `GoogleService-Info.plist` and add to:
   ```
   ios/Runner/GoogleService-Info.plist
   ```

## Step 3: Run the App

```bash
flutter run
```

## Running Without Firebase

The app will automatically run in guest mode if Firebase is not configured. All features work with local storage.

## Troubleshooting

### "Firebase not initialized" error
- The app handles this gracefully and runs in offline mode
- To fix: Complete Firebase setup above

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

### Android build issues
- Ensure `minSdkVersion` is at least 21 in `android/app/build.gradle`
- Check that `google-services.json` is in the correct location

### iOS build issues
- Run `pod install` in `ios/` directory
- Ensure `GoogleService-Info.plist` is added to Xcode project

## Next Steps

1. Replace YouTube video IDs in `resources_screen.dart` with actual educational videos
2. Customize colors in `lib/utils/constants.dart`
3. Add real MSE API integration when available
4. Add your app logo/assets to `assets/images/`

## Testing Features

- **Guest Mode**: App works immediately without sign-in
- **Stock Trading**: Buy/sell stocks with virtual 100,000 MWK
- **Charts**: View line and candlestick charts
- **Portfolio**: Track your virtual investments
- **Quizzes**: Complete daily quizzes to earn coins
- **Challenges**: Predict price movements

Enjoy learning about MSE investing! 📈

