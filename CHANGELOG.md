# Changelog

All notable changes to the EthioExitExam project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-04

### Added - Initial Release

#### Core Features
- Complete Flutter mobile application for Ethiopian university students
- Firebase backend integration (Auth, Firestore, Storage)
- Role-based access control (Student, Admin, Super Admin)

#### Authentication & Registration
- Email/password authentication
- Student registration with university text field
- Department selection via dropdown (dynamically populated from Firestore)
- Pending approval workflow for new registrations
- Status-based screen routing (pending, approved, rejected)

#### Student Features
- Department-specific course access
- Module browsing with learning materials
- Practice questions interface
  - Combined past and AI-generated questions
  - Shuffled question order
  - Multiple choice selection
  - Answer checking with explanations
  - Score tracking and final results display
- Material viewing (PDF, notes, external links)
- Progress tracking within practice sessions

#### Admin Features
- Admin dashboard with management cards
- Department management (Super Admin only)
  - Create new departments
  - View department list
- Course management
  - Create courses under department
  - View course list
  - Navigate to module management
- Module management
  - Create modules under courses
  - View module list
  - Navigate to material management
- Material management
  - Add materials (PDF, note, link types)
  - Type selection dropdown
  - View material list
- Student approval system
  - View pending student registrations
  - Approve/reject students
  - View student details

#### Database Models
- User model with role and status enums
- Department model
- Course model with department reference
- Module model with course reference
- Material model with type enum (PDF, note, link)
- PastQuestion model with explanation
- AIQuestion model with difficulty and approval flag

#### Security
- Firestore security rules with RBAC
- Department-based data isolation
- Approved students only access
- Admin operations restricted to their department
- Super admin full access

#### Documentation
- Comprehensive README with features and overview
- Detailed SETUP.md with step-by-step deployment guide
- PROJECT_STRUCTURE.md with architecture documentation
- QUICKSTART.md for rapid setup
- CONTRIBUTING.md with contribution guidelines
- LICENSE file (MIT)

#### Android Configuration
- Android manifest with permissions
- Gradle build configuration
- MainActivity in Kotlin
- Firebase integration setup
- Example google-services.json template

#### Development Tools
- Dart analysis options with linting rules
- .gitignore with Flutter/Firebase patterns
- Project metadata file

### Technical Details

#### Dependencies
- flutter (SDK)
- firebase_core: ^2.24.2
- firebase_auth: ^4.15.3
- cloud_firestore: ^4.13.6
- firebase_storage: ^11.5.6
- provider: ^6.1.1
- url_launcher: ^6.2.2
- file_picker: ^6.1.1
- flutter_spinkit: ^5.2.0
- intl: ^0.18.1

#### Platform Support
- Android (primary)
- iOS (structure in place, needs configuration)

#### State Management
- Provider for authentication state
- StatefulWidget for UI state
- ChangeNotifier for service layer

#### Navigation
- MaterialPageRoute for navigation
- Context-based push/pop
- Role-based initial routing

### Known Limitations

- iOS not yet configured (Android only)
- No offline mode
- No push notifications
- No file upload from device (URLs only)
- No progress persistence across sessions
- No leaderboard or social features
- English only (no Amharic localization)
- No admin web dashboard

### Future Enhancements (Planned)

- [ ] iOS support with configuration
- [ ] Offline mode with local caching
- [ ] Push notifications for approvals and updates
- [ ] Admin web dashboard
- [ ] Multi-language support (Amharic)
- [ ] File upload from device
- [ ] Advanced analytics and reporting
- [ ] Question search and filtering
- [ ] Study progress persistence
- [ ] Bookmarks and favorites
- [ ] Dark mode theme
- [ ] Question comments and discussions
- [ ] Performance statistics
- [ ] Leaderboard system
- [ ] Timed practice mode
- [ ] Export study reports

---

## Version History

### [Unreleased]
- Future features to be added

### [1.0.0] - 2026-01-04
- Initial release with core features
- Complete student and admin workflows
- Firebase integration
- Comprehensive documentation

---

## Migration Guide

### From Nothing to 1.0.0

This is the initial release. Follow the [SETUP.md](SETUP.md) guide to:
1. Set up Firebase project
2. Configure the app
3. Deploy security rules
4. Create initial admin
5. Run the application

---

## Notes

- This changelog will be updated with each release
- Breaking changes will be clearly marked
- Migration guides will be provided for major versions
