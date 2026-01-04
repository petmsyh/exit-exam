# EthioExitExam - Setup and Deployment Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Firebase Setup](#firebase-setup)
3. [Project Configuration](#project-configuration)
4. [Building the App](#building-the-app)
5. [Creating Initial Admin](#creating-initial-admin)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (version 3.0.0 or higher)
  ```bash
  flutter --version
  ```
  
- **Android Studio** or **VS Code** with Flutter extensions

- **Git**
  ```bash
  git --version
  ```

- **Firebase CLI** (for deploying rules)
  ```bash
  npm install -g firebase-tools
  firebase --version
  ```

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `ethio-exit-exam`
4. Disable Google Analytics (optional)
5. Click "Create project"

### 2. Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get started"
3. Enable **Email/Password** sign-in method
4. Click "Save"

### 3. Create Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Choose "Start in test mode" (we'll add rules later)
4. Select a location (preferably close to Ethiopia)
5. Click "Enable"

### 4. Enable Firebase Storage

1. In Firebase Console, go to **Storage**
2. Click "Get started"
3. Keep default security rules
4. Click "Done"

### 5. Register Android App

1. In Firebase Console, go to **Project settings** (gear icon)
2. Click "Add app" and select Android
3. Enter Android package name: `com.ethioexitexam.app`
4. Register app
5. Download `google-services.json`
6. Place it in `android/app/` directory

### 6. Get Firebase Configuration

1. In Firebase Console, go to **Project settings**
2. Scroll down to "Your apps"
3. Click on your Android app
4. Copy the Firebase configuration
5. Update `lib/firebase_options.dart` with your configuration:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.appspot.com',
);
```

## Project Configuration

### 1. Clone and Install Dependencies

```bash
git clone https://github.com/petmsyh/exit-exam.git
cd exit-exam
flutter pub get
```

### 2. Deploy Firestore Security Rules

```bash
firebase login
firebase init firestore
# Select your Firebase project
# Use existing firestore.rules file
firebase deploy --only firestore:rules
```

### 3. Verify Configuration

```bash
flutter doctor -v
```

Ensure all checks pass, especially Android toolchain.

## Building the App

### Development Build

```bash
flutter run
```

### Release Build (APK)

```bash
flutter build apk --release
```

The APK will be in `build/app/outputs/flutter-apk/app-release.apk`

### Release Build (App Bundle for Play Store)

```bash
flutter build appbundle --release
```

The AAB will be in `build/app/outputs/bundle/release/app-release.aab`

## Creating Initial Admin

After deploying the app, you need to create the first Super Admin manually:

### Method 1: Through Firestore Console

1. Create a user account through the app (register normally)
2. Go to Firebase Console → Authentication
3. Copy the User UID
4. Go to Firebase Console → Firestore Database
5. Find the `users` collection
6. Find your user document (use the UID)
7. Edit the document:
   - Change `role` to `superAdmin`
   - Change `status` to `approved`
8. Save changes

### Method 2: Using Firebase Admin SDK (Node.js)

Create a script `create_admin.js`:

```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const auth = admin.auth();

async function createSuperAdmin() {
  try {
    // Create user in Authentication
    const userRecord = await auth.createUser({
      email: 'admin@ethioexitexam.com',
      password: 'SecurePassword123!',
      displayName: 'Super Admin'
    });

    // Create user document in Firestore
    await db.collection('users').doc(userRecord.uid).set({
      name: 'Super Admin',
      email: 'admin@ethioexitexam.com',
      role: 'superAdmin',
      university: 'System',
      departmentId: null,
      status: 'approved',
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    console.log('Super Admin created successfully!');
    console.log('Email: admin@ethioexitexam.com');
    console.log('Password: SecurePassword123!');
  } catch (error) {
    console.error('Error creating super admin:', error);
  }
}

createSuperAdmin();
```

Run:
```bash
node create_admin.js
```

## Initial Setup Flow

1. **Create Super Admin** (as described above)
2. **Login as Super Admin**
3. **Create Departments**:
   - Go to Admin Dashboard → Manage Departments
   - Add departments (e.g., Computer Science, Engineering, Medicine)
4. **Create Department Admin**:
   - Register a new user through the app
   - As Super Admin, change their role to `admin` in Firestore
   - Assign them a department
5. **Department Admin Setup**:
   - Login as Department Admin
   - Create Courses
   - Create Modules under courses
   - Upload Materials
   - Add Questions
6. **Approve Students**:
   - Students register through the app
   - Admins approve them from "Pending Students" screen

## Troubleshooting

### Firebase Connection Issues

If you see Firebase connection errors:
1. Verify `google-services.json` is in `android/app/`
2. Check Firebase configuration in `firebase_options.dart`
3. Ensure Firebase services are enabled in console
4. Check internet connection

### Build Errors

**"Could not resolve com.google.firebase"**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

**"Firebase not initialized"**
- Ensure Firebase.initializeApp() is called in main.dart
- Verify firebase_core is in pubspec.yaml

### Permission Errors

**"FirebaseError: Missing or insufficient permissions"**
- Deploy Firestore security rules
- Verify user role and status in Firestore
- Check if user is approved

### Department Dropdown Empty

- Ensure at least one department exists in Firestore
- Check Firestore security rules allow reading departments
- Verify network connection

## Testing

### Test User Flow

1. Register as student
2. Select department
3. Wait for approval (or manually approve)
4. Login and access courses
5. Practice questions

### Test Admin Flow

1. Login as admin
2. Create course
3. Add modules
4. Upload materials
5. Approve pending students

## Production Checklist

- [ ] Update Firebase security rules for production
- [ ] Change Firebase from test mode to production mode
- [ ] Set up proper signing key for Android
- [ ] Enable Firebase App Check
- [ ] Set up Firebase Analytics (optional)
- [ ] Test all features thoroughly
- [ ] Prepare app for Play Store submission
- [ ] Create privacy policy
- [ ] Create terms of service

## Support

For issues:
1. Check this guide
2. Review Firebase Console for errors
3. Check app logs: `flutter logs`
4. Create an issue on GitHub

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
