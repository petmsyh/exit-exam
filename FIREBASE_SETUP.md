# Firebase Configuration Guide

This guide helps you properly configure Firebase for the EthioExitExam application.

## Prerequisites

- Firebase account (free tier works)
- Firebase CLI installed: `npm install -g firebase-tools`
- Flutter project set up locally

## Step-by-Step Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Project name: `ethio-exit-exam` (or your preferred name)
4. Google Analytics: Optional (can disable for simplicity)
5. Click "Create project"
6. Wait for project creation

### 2. Enable Authentication

1. In Firebase Console, click "Authentication" in left menu
2. Click "Get started"
3. Click "Sign-in method" tab
4. Enable "Email/Password"
   - Click on it
   - Toggle "Enable" switch
   - Click "Save"
5. You can add authorized domains later if needed

### 3. Create Firestore Database

1. In Firebase Console, click "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (we'll deploy secure rules later)
4. Select a location:
   - Recommended: `europe-west1` (Netherlands) - closest to Ethiopia
   - Or: `europe-west3` (Frankfurt)
5. Click "Enable"
6. Wait for database creation

### 4. Enable Firebase Storage

1. In Firebase Console, click "Storage"
2. Click "Get started"
3. Keep default security rules for now
4. Use the same location as Firestore
5. Click "Done"

### 5. Register Android App

#### 5.1 Add Android App

1. In Firebase Console, click the gear icon → "Project settings"
2. Scroll down to "Your apps"
3. Click the Android icon
4. Android package name: `com.ethioexitexam.app`
5. App nickname (optional): `EthioExitExam`
6. Debug signing certificate SHA-1 (optional, for later)
7. Click "Register app"

#### 5.2 Download google-services.json

1. Download the `google-services.json` file
2. Place it in `android/app/` directory
3. **Important**: Do NOT commit this file to Git (already in .gitignore)

#### 5.3 Update Firebase Options

1. In Firebase Console, Project settings → Your apps
2. Scroll to "SDK setup and configuration"
3. Copy the configuration values
4. Update `lib/firebase_options.dart`:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY_HERE',
  appId: '1:123456789:android:abcdef123456',
  messagingSenderId: '123456789',
  projectId: 'ethio-exit-exam',
  storageBucket: 'ethio-exit-exam.appspot.com',
);
```

### 6. Deploy Firestore Security Rules

#### 6.1 Initialize Firebase in Project

```bash
cd /path/to/exit-exam
firebase login
firebase init firestore
```

When prompted:
- Select your Firebase project
- Firestore rules file: `firestore.rules` (already exists)
- Firestore indexes file: `firestore.indexes.json` (create new or use default)

#### 6.2 Deploy Rules

```bash
firebase deploy --only firestore:rules
```

This deploys the security rules from `firestore.rules` file.

#### 6.3 Verify Rules Deployed

1. Go to Firebase Console → Firestore Database
2. Click "Rules" tab
3. You should see the deployed rules

### 7. Create Firestore Indexes (Optional but Recommended)

Some queries require indexes. Create `firestore.indexes.json`:

```json
{
  "indexes": [
    {
      "collectionGroup": "courses",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "departmentId", "order": "ASCENDING" },
        { "fieldPath": "name", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "users",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "departmentId", "order": "ASCENDING" },
        { "fieldPath": "role", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "past_questions",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "moduleId", "order": "ASCENDING" },
        { "fieldPath": "year", "order": "DESCENDING" }
      ]
    }
  ],
  "fieldOverrides": []
}
```

Deploy indexes:
```bash
firebase deploy --only firestore:indexes
```

### 8. Configure Storage Rules

Update Storage rules in Firebase Console → Storage → Rules:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Only authenticated users can read
    match /{allPaths=**} {
      allow read: if request.auth != null;
    }
    
    // Only admins can write
    match /materials/{allPaths=**} {
      allow write: if request.auth != null 
                    && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'superAdmin'];
    }
  }
}
```

### 9. Create Initial Super Admin

After app is deployed, create the first admin:

#### Method 1: Manual (Firebase Console)

1. Register a user through the app
2. Firebase Console → Authentication → Users
3. Copy the User UID
4. Firebase Console → Firestore Database
5. Navigate to `users` collection
6. Find document with that UID
7. Click "Edit"
8. Update fields:
   - `role`: `superAdmin`
   - `status`: `approved`
9. Save

#### Method 2: Using Firebase Admin SDK

Create `scripts/create_admin.js`:

```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const email = 'admin@ethioexitexam.com';
const password = 'ChangeThisPassword123!';

async function createAdmin() {
  try {
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: 'Super Admin'
    });

    await admin.firestore().collection('users').doc(userRecord.uid).set({
      name: 'Super Admin',
      email: email,
      role: 'superAdmin',
      university: 'System',
      departmentId: null,
      status: 'approved',
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    console.log('✅ Super Admin created!');
    console.log('Email:', email);
    console.log('Password:', password);
    console.log('⚠️  Change password after first login!');
  } catch (error) {
    console.error('Error:', error);
  }
}

createAdmin();
```

Download service account key from Firebase Console → Project Settings → Service accounts → Generate new private key

Run:
```bash
npm install firebase-admin
node scripts/create_admin.js
```

### 10. Test Configuration

1. Run the app: `flutter run`
2. Try to register (should work)
3. Try to login (should work)
4. Check if departments dropdown loads (need to create departments first)

### 11. Create Initial Data

As Super Admin:

1. Login to the app
2. Go to "Manage Departments"
3. Add departments:
   - Computer Science
   - Software Engineering
   - Information Systems
   - (Add more as needed)

Now regular users can register and select departments!

## Troubleshooting

### "FirebaseOptions not configured"
- Check `firebase_options.dart` has correct values
- Ensure `google-services.json` is in `android/app/`

### "Failed to load departments"
- Check Firestore security rules are deployed
- Create at least one department
- Check internet connection

### "Authentication failed"
- Verify Email/Password is enabled in Firebase Console
- Check Firebase configuration is correct

### "Permission denied" errors
- Deploy Firestore security rules: `firebase deploy --only firestore:rules`
- Check user role and status in Firestore
- Verify user is approved

### Build errors
- Clean and rebuild: `flutter clean && flutter pub get`
- Check `google-services.json` is present
- Verify Gradle files are correct

## Security Checklist

Before going to production:

- [ ] Change Firestore from test mode to production with security rules
- [ ] Deploy proper security rules
- [ ] Update Storage rules
- [ ] Remove test accounts
- [ ] Set up Firebase App Check (optional but recommended)
- [ ] Enable 2FA for Firebase Console access
- [ ] Review user permissions
- [ ] Set up monitoring and alerts
- [ ] Back up Firestore data regularly
- [ ] Document admin procedures

## Useful Firebase Commands

```bash
# Login
firebase login

# Initialize services
firebase init

# Deploy rules only
firebase deploy --only firestore:rules
firebase deploy --only storage:rules

# Deploy everything
firebase deploy

# Check current project
firebase projects:list
firebase use

# View logs
firebase functions:log

# Test security rules locally
firebase emulators:start --only firestore
```

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Console](https://console.firebase.google.com/)

## Support

If you encounter issues:
1. Check Firebase Console for errors
2. Review this guide
3. Check [SETUP.md](SETUP.md)
4. Create an issue on GitHub
