# Quick Start Guide - EthioExitExam

This is a condensed guide to get you up and running quickly. For detailed instructions, see [SETUP.md](SETUP.md).

## Prerequisites

- Flutter SDK installed
- Android Studio or VS Code
- Firebase account
- Git

## Quick Setup (5 Steps)

### 1. Clone the Repository

```bash
git clone https://github.com/petmsyh/exit-exam.git
cd exit-exam
flutter pub get
```

### 2. Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Create new project: "ethio-exit-exam"
3. Enable Authentication (Email/Password)
4. Create Firestore Database (test mode)
5. Enable Storage

### 3. Configure Android App

1. In Firebase Console, add Android app
2. Package name: `com.ethioexitexam.app`
3. Download `google-services.json`
4. Place in `android/app/` folder
5. Copy Firebase config to `lib/firebase_options.dart`

### 4. Deploy Security Rules

```bash
firebase login
firebase init firestore
firebase deploy --only firestore:rules
```

### 5. Run the App

```bash
flutter run
```

## Create First Admin

After app is running:

1. Register a user through the app
2. Go to Firebase Console → Authentication
3. Copy the User UID
4. Go to Firestore Database → users collection
5. Find your user document
6. Edit: `role: "superAdmin"`, `status: "approved"`
7. Save and re-login

## Test the App

### As Super Admin:
1. Login with your admin account
2. Create departments (e.g., "Computer Science")
3. Create courses under departments
4. Create modules under courses
5. Add materials to modules

### As Student:
1. Register new user
2. Select university (text field)
3. Select department (dropdown)
4. Wait for admin approval
5. Login and explore courses

## Common Issues

**Firebase not connected**: Check `google-services.json` location

**No departments in dropdown**: Create departments as super admin first

**Access denied**: Deploy Firestore security rules

**Build error**: Run `flutter clean && flutter pub get`

## Next Steps

- [ ] Add more departments
- [ ] Create courses and modules
- [ ] Upload learning materials
- [ ] Add past exam questions
- [ ] Invite students to register
- [ ] Approve student registrations

## Documentation

- [README.md](README.md) - Project overview
- [SETUP.md](SETUP.md) - Detailed setup guide
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Code architecture

## Support

Create an issue on GitHub if you need help.

---

**Ready to build!** 🚀
