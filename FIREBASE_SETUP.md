# Firebase Setup Guide for Malawi Invest

This guide will walk you through setting up Firebase for the Malawi Invest app step by step.

## Prerequisites

- A Google account
- Flutter SDK installed
- Android Studio (for Android setup)
- Xcode (for iOS setup on Mac)

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or **"Create a project"**
3. Enter project name: `malawi-invest` (or your preferred name)
4. Click **"Continue"**
5. **Disable Google Analytics** (optional, or enable if you want analytics)
6. Click **"Create project"**
7. Wait for project creation, then click **"Continue"**

## Step 2: Install FlutterFire CLI

### Option A: Using FlutterFire CLI (Automated)

Open your terminal and run:

```bash
dart pub global activate flutterfire_cli
```

### ⚠️ Windows Users: If `flutterfire` command not found

**Quick Fix (No PATH changes needed):**
Use the full command instead:
```powershell
dart pub global run flutterfire_cli:flutterfire configure
```

**Or add to PATH (Permanent fix):**
1. Find your pub cache location:
   ```powershell
   dart pub cache location
   ```
   This shows: `C:\Users\YourUsername\AppData\Local\Pub\Cache\bin`

2. Add to PATH:
   - Press `Win + R` → Type `sysdm.cpl` → Enter
   - Go to **Advanced** → **Environment Variables**
   - Under **User variables**, edit `Path`
   - Add: `C:\Users\YourUsername\AppData\Local\Pub\Cache\bin`
   - **Restart PowerShell** after adding

3. Verify installation:
   ```powershell
   flutterfire --version
   ```

### ⚠️ If you get "Failed to fetch Firebase projects" error

This means Firebase CLI needs to be installed and authenticated. You have two options:

**Option 1: Install Firebase CLI and login**
```powershell
# Install Firebase CLI (requires Node.js/npm)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Verify
firebase projects:list

# Then run FlutterFire
dart pub global run flutterfire_cli:flutterfire configure
```

**Option 2: Manual Setup (Easier - No CLI needed)**
See **"Option B: Manual Setup"** section below. This is often easier and doesn't require Firebase CLI installation.

**Mac/Linux users:** Add `~/.pub-cache/bin` to PATH if needed.

---

## Option B: Manual Setup (No Firebase CLI Required)

If you're having issues with FlutterFire CLI, you can set up Firebase manually:

### Step 1: Create Firebase Project
1. Go to https://console.firebase.google.com/
2. Create project: `malawi-invest`
3. Click "Continue"

### Step 2: Add Android App
1. Click **Android icon** (or "Add app")
2. Package name: `com.example.malawi_invest` (check `android/app/build.gradle.kts` line 9 for actual)
3. Download `google-services.json`
4. Place in: `android/app/google-services.json`

### Step 3: Add iOS App
1. Click **iOS icon** (or "Add app")
2. Bundle ID: `com.example.malawiInvest` (check Xcode for actual)
3. Download `GoogleService-Info.plist`
4. Add to Xcode project (`ios/Runner/` folder)

### Step 4: Get Config Values
1. Firebase Console → Project Settings (gear icon)
2. Scroll to "Your apps"
3. Click Android app → Copy all config values
4. Click iOS app → Copy all config values

### Step 5: Update firebase_options.dart
Open `lib/firebase_options.dart` and replace placeholder values with real ones from Step 4.

**See `FIREBASE_CLI_FIX.md` for detailed manual setup instructions.**

## Step 3: Configure Firebase for Your Flutter App

1. **Navigate to your project directory:**
   ```bash
   cd path/to/malawi_invest
   ```

2. **Run FlutterFire configuration:**
   
   **Windows (if PATH not set):**
   ```powershell
   dart pub global run flutterfire_cli:flutterfire configure
   ```
   
   **Mac/Linux (or Windows with PATH set):**
   ```bash
   flutterfire configure
   ```

3. **Follow the prompts:**
   - Select your Firebase project (the one you created in Step 1)
   - Select platforms: 
     - Press `Space` to select **Android** and **iOS**
     - Press `Enter` to confirm
   - For Android package name: Use the default (usually `com.example.malawi_invest`)
   - For iOS bundle ID: Use the default (usually `com.example.malawiInvest`)

4. **This will automatically:**
   - Generate `firebase_options.dart` with your config
   - Create Android and iOS apps in Firebase Console
   - Set up basic configuration

## Step 4: Android Setup

### 4.1 Download google-services.json

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click the **Android icon** (or go to Project Settings → Your apps)
4. If you haven't added an Android app yet:
   - Click **"Add app"** → Select Android
   - Enter package name: `com.example.malawi_invest` (check your `android/app/build.gradle` for actual package)
   - Enter app nickname (optional)
   - Click **"Register app"**
   - Download `google-services.json`
5. **Place the file:**
   ```
   android/app/google-services.json
   ```

### 4.2 Update Android Build Files

1. **Open `android/build.gradle`** (project-level) and add:
   ```gradle
   buildscript {
       dependencies {
           // ... existing dependencies
           classpath 'com.google.gms:google-services:4.4.0'
       }
   }
   ```

2. **Open `android/app/build.gradle`** and add at the **bottom**:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

3. **Check minimum SDK version** in `android/app/build.gradle`:
   ```gradle
   android {
       defaultConfig {
           minSdkVersion 21  // Should be at least 21
           // ...
       }
   }
   ```

### 4.3 Enable Required Services

In Firebase Console:

1. **Authentication:**
   - Go to **Authentication** → **Get started**
   - Enable **Email/Password** sign-in method
   - Enable **Google** sign-in method (optional)

2. **Realtime Database:**
   - Go to **Realtime Database** → **Create Database**
   - Choose location (closest to your users)
   - Start in **Test mode** (for development)
   - Click **"Enable"**

3. **Firestore Database** (Alternative/Additional):
   - Go to **Firestore Database** → **Create database**
   - Start in **Test mode**
   - Choose location
   - Click **"Enable"**

## Step 5: iOS Setup

### 5.1 Download GoogleService-Info.plist

1. In Firebase Console, click the **iOS icon** (or go to Project Settings → Your apps)
2. If you haven't added an iOS app:
   - Click **"Add app"** → Select iOS
   - Enter bundle ID: `com.example.malawiInvest` (check your `ios/Runner.xcodeproj` for actual bundle ID)
   - Enter app nickname (optional)
   - Click **"Register app"**
   - Download `GoogleService-Info.plist`
3. **Add to Xcode:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Right-click on **Runner** folder → **Add Files to "Runner"**
   - Select `GoogleService-Info.plist`
   - Make sure **"Copy items if needed"** is checked
   - Click **"Add"**

### 5.2 Update iOS Podfile

1. **Navigate to ios directory:**
   ```bash
   cd ios
   ```

2. **Install pods:**
   ```bash
   pod install
   ```

3. **Go back to project root:**
   ```bash
   cd ..
   ```

### 5.3 Enable Capabilities (if needed)

In Xcode:
1. Select **Runner** target
2. Go to **Signing & Capabilities**
3. Ensure **Push Notifications** capability is added (if you plan to use it)

## Step 6: Update Firebase Rules (Important!)

### 6.1 Realtime Database Rules

1. Go to **Realtime Database** → **Rules** tab
2. Update rules for development:
   ```json
   {
     "rules": {
       "portfolios": {
         "$userId": {
           ".read": "$userId === auth.uid || auth != null",
           ".write": "$userId === auth.uid || auth != null"
         }
       },
       "users": {
         "$userId": {
           ".read": "$userId === auth.uid || auth != null",
           ".write": "$userId === auth.uid || auth != null"
         }
       }
     }
   }
   ```
3. Click **"Publish"**

**Note**: These rules allow authenticated users to read/write their own data. For production, make them more restrictive.

### 6.2 Firestore Rules (if using Firestore)

1. Go to **Firestore Database** → **Rules** tab
2. Update rules:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /portfolios/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```
3. Click **"Publish"**

## Step 7: Verify Setup

### 7.1 Check firebase_options.dart

Open `lib/firebase_options.dart` and verify it contains your actual Firebase configuration (not placeholders).

### 7.2 Test the App

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **Test authentication:**
   - Try signing in as guest (should work)
   - Try email sign-up (should create account in Firebase)
   - Check Firebase Console → Authentication → Users (should see new user)

3. **Test data storage:**
   - Make a trade (buy/sell stock)
   - Check Firebase Console → Realtime Database (should see portfolio data)

## Step 8: Troubleshooting

### Issue: "Firebase not initialized" error

**Solution:**
- Verify `firebase_options.dart` exists and has correct values
- Check that `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in correct location
- Run `flutter clean` and `flutter pub get`

### Issue: Android build fails

**Solution:**
- Verify `google-services.json` is in `android/app/`
- Check `android/app/build.gradle` has `apply plugin: 'com.google.gms.google-services'` at the bottom
- Ensure `minSdkVersion` is at least 21

### Issue: iOS build fails

**Solution:**
- Verify `GoogleService-Info.plist` is added to Xcode project
- Run `cd ios && pod install && cd ..`
- Clean build: `flutter clean && flutter pub get`

### Issue: Authentication not working

**Solution:**
- Check Firebase Console → Authentication → Sign-in methods are enabled
- Verify SHA-1 fingerprint is added (Android) - see below

### Issue: Database permission denied

**Solution:**
- Check Firebase Database rules (Step 6)
- Ensure user is authenticated
- Verify rules allow read/write for authenticated users

## Step 9: Add SHA-1 Fingerprint (Android - Optional but Recommended)

For Google Sign-In to work properly on Android:

1. **Get SHA-1 fingerprint:**
   ```bash
   # Windows
   cd android
   gradlew signingReport
   
   # Mac/Linux
   cd android
   ./gradlew signingReport
   ```

2. **Copy the SHA-1 fingerprint** (look for `SHA1:` in output)

3. **Add to Firebase:**
   - Go to Firebase Console → Project Settings → Your apps → Android app
   - Click **"Add fingerprint"**
   - Paste SHA-1 fingerprint
   - Click **"Save"**

## Step 10: Production Considerations

Before releasing to production:

1. **Update Database Rules:**
   - Make rules more restrictive
   - Remove test mode rules
   - Add proper authentication checks

2. **Enable App Check** (optional but recommended):
   - Go to Firebase Console → App Check
   - Register your apps
   - This prevents abuse

3. **Set up proper authentication:**
   - Configure OAuth consent screen (for Google Sign-In)
   - Add authorized domains

4. **Monitor usage:**
   - Set up Firebase Analytics
   - Monitor database usage
   - Set up alerts

## Quick Reference

### File Locations:
- `lib/firebase_options.dart` - Auto-generated Firebase config
- `android/app/google-services.json` - Android config
- `ios/Runner/GoogleService-Info.plist` - iOS config

### Firebase Console Links:
- [Firebase Console](https://console.firebase.google.com/)
- [Authentication Settings](https://console.firebase.google.com/project/_/authentication/providers)
- [Database Rules](https://console.firebase.google.com/project/_/database)

### Useful Commands:
```bash
# Reconfigure Firebase
flutterfire configure

# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check Firebase connection
flutter doctor
```

## Need Help?

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- Check app logs: `flutter logs`

---

**Note**: The app works in guest mode without Firebase, but Firebase enables:
- User authentication (email/Google)
- Cloud storage of portfolios
- Data sync across devices
- User profiles and badges

