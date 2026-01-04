# Project Structure Documentation

## Directory Structure

```
exit-exam/
├── android/                    # Android-specific configuration
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── kotlin/        # Kotlin source files
│   │   │   └── AndroidManifest.xml
│   │   └── build.gradle       # App-level Gradle config
│   ├── build.gradle           # Project-level Gradle config
│   └── settings.gradle        # Gradle settings
├── assets/                    # App assets
│   ├── images/               # Image files
│   └── icons/                # Icon files
├── ios/                      # iOS configuration (not implemented)
├── lib/                      # Dart source code
│   ├── models/              # Data models
│   │   ├── user_model.dart
│   │   ├── department.dart
│   │   ├── course.dart
│   │   ├── module.dart
│   │   ├── material.dart
│   │   ├── past_question.dart
│   │   └── ai_question.dart
│   ├── screens/             # UI screens
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── student/
│   │   │   ├── student_dashboard.dart
│   │   │   ├── courses_screen.dart
│   │   │   ├── module_screen.dart
│   │   │   └── practice_screen.dart
│   │   ├── admin/
│   │   │   ├── admin_dashboard.dart
│   │   │   ├── manage_departments_screen.dart
│   │   │   ├── manage_courses_screen.dart
│   │   │   ├── manage_modules_screen.dart
│   │   │   ├── manage_materials_screen.dart
│   │   │   └── pending_students_screen.dart
│   │   ├── splash_screen.dart
│   │   └── pending_approval_screen.dart
│   ├── services/            # Business logic
│   │   ├── auth_service.dart
│   │   └── database_service.dart
│   ├── widgets/             # Reusable widgets (to be added)
│   ├── utils/               # Utility functions (to be added)
│   ├── firebase_options.dart # Firebase configuration
│   └── main.dart            # App entry point
├── test/                    # Test files
├── .gitignore              # Git ignore rules
├── analysis_options.yaml   # Dart analysis options
├── firestore.rules         # Firestore security rules
├── pubspec.yaml            # Package dependencies
├── README.md               # Project overview
└── SETUP.md                # Setup instructions

```

## Key Components

### Models

**UserModel** (`lib/models/user_model.dart`)
- Represents user data (students, admins, super admins)
- Handles serialization to/from Firestore
- Contains role and status enums

**Department** (`lib/models/department.dart`)
- Represents academic departments
- Simple structure with name and creation date

**Course** (`lib/models/course.dart`)
- Represents courses within departments
- Links to department via departmentId

**Module** (`lib/models/module.dart`)
- Represents modules within courses
- Contains title and description

**Material** (`lib/models/material.dart`)
- Represents learning materials
- Supports PDF, note, and link types
- Links to department, course, and module

**PastQuestion** (`lib/models/past_question.dart`)
- Represents past exit exam questions
- Multiple choice with explanation
- Categorized by department, course, module, and year

**AIQuestion** (`lib/models/ai_question.dart`)
- Represents AI-generated questions
- Requires admin approval
- Has difficulty levels

### Services

**AuthService** (`lib/services/auth_service.dart`)
- Handles user authentication
- Manages sign in, sign up, sign out
- Maintains user state with ChangeNotifier
- Loads user data from Firestore

**DatabaseService** (`lib/services/database_service.dart`)
- Handles all Firestore operations
- CRUD operations for all collections
- Department, course, module, material management
- Question retrieval
- User approval workflow

### Screens

#### Authentication Screens

**LoginScreen**
- Email/password login
- Navigation to registration
- Auto-navigation based on user role and status

**RegisterScreen**
- Student registration form
- University name text input
- Department dropdown (populated from Firestore)
- Password validation
- Creates pending user account

#### Student Screens

**StudentDashboard**
- Displays welcome message
- Lists department-specific courses
- Navigation to course details

**CoursesScreen**
- Shows modules for selected course
- Navigation to module details

**ModuleScreen**
- Displays module information
- Lists learning materials
- Shows practice button if questions available
- Opens materials in external browser

**PracticeScreen**
- Displays questions one by one
- Multiple choice selection
- Shows correct answer and explanation
- Tracks score
- Shows final results

#### Admin Screens

**AdminDashboard**
- Admin/Super Admin hub
- Cards for different management functions
- Role-based visibility

**ManageDepartmentsScreen** (Super Admin only)
- Lists all departments
- Create new departments
- Shows department details

**ManageCoursesScreen**
- Lists department courses
- Create new courses
- Navigate to module management

**ManageModulesScreen**
- Lists course modules
- Create new modules
- Navigate to material management

**ManageMaterialsScreen**
- Lists module materials
- Add materials (PDF, note, link)
- Material type selection

**PendingStudentsScreen**
- Lists pending student registrations
- Approve/reject functionality
- Shows student details

#### Other Screens

**SplashScreen**
- App initialization
- Auth state checking
- Auto-navigation to appropriate screen

**PendingApprovalScreen**
- Shown to pending/rejected students
- Status-based messaging
- Sign out option

## State Management

The app uses **Provider** for state management:
- AuthService is provided at app level
- Screens listen to auth state changes
- Manual state management with setState for UI updates

## Navigation

Navigation uses Flutter's Navigator.push/pop:
- No named routes (can be added later)
- Route-based navigation with MaterialPageRoute
- Back button support

## Firebase Integration

### Authentication
- Email/password authentication
- User creation synced with Firestore

### Firestore Collections
- users: User profiles and roles
- departments: Academic departments
- courses: Department courses
- modules: Course modules
- materials: Learning materials
- past_questions: Past exam questions
- ai_questions: AI-generated questions

### Security Rules
- Role-based access control
- Department-based data isolation
- Approved students only see content
- Admins manage their department only
- Super admins have full access

## Key Features Implementation

### Department Selection
- Dropdown populated from Firestore
- No manual text input
- Required field in registration

### User Approval Workflow
1. User registers → status: pending
2. Shows pending screen
3. Admin approves → status: approved
4. User can now access content

### Department-Based Access
- Courses filtered by department
- Materials filtered by department
- Questions filtered by department
- Admins manage their department only

### Question Practice
- Combined past and AI questions
- Shuffled for variety
- Immediate feedback
- Explanation display
- Score tracking
- Progress indicator

## Future Enhancements

Planned features:
- [ ] Offline mode with local caching
- [ ] Push notifications for approvals
- [ ] Admin web dashboard
- [ ] Multi-language support (Amharic)
- [ ] Advanced analytics
- [ ] Question search and filters
- [ ] Study progress tracking
- [ ] Bookmarks and favorites
- [ ] Dark mode
- [ ] File upload for materials
- [ ] Question comments and discussions
- [ ] Performance statistics
- [ ] Leaderboard

## Testing Strategy

### Unit Tests
- Model serialization/deserialization
- Service methods
- Utility functions

### Widget Tests
- Screen rendering
- User interactions
- Form validations

### Integration Tests
- Complete user flows
- Authentication workflow
- CRUD operations
- Navigation flow

## Code Style

- Follow Flutter/Dart style guide
- Use const constructors where possible
- Prefer single quotes
- Sort child properties last
- Avoid print statements in production
- Use meaningful variable names
- Add comments for complex logic

## Performance Considerations

- Firestore queries are indexed
- Pagination for large lists (to be implemented)
- Image caching (to be implemented)
- Lazy loading of data
- Minimal widget rebuilds
- Efficient state management

## Security Considerations

- Firestore security rules enforced
- No sensitive data in client
- Role-based access control
- Department isolation
- Approval workflow for students
- Admin actions validated server-side (via rules)

## Accessibility

- Semantic labels (to be added)
- Screen reader support (to be enhanced)
- High contrast support
- Font scaling support
- Keyboard navigation (to be enhanced)

## Maintenance

### Updating Dependencies
```bash
flutter pub upgrade
```

### Analyzing Code
```bash
flutter analyze
```

### Formatting Code
```bash
flutter format lib/
```

### Running Tests
```bash
flutter test
```

## Troubleshooting Common Issues

### Firebase Connection
- Check google-services.json location
- Verify Firebase project configuration
- Check internet connectivity

### Build Issues
- Run `flutter clean`
- Delete build folders
- Re-run `flutter pub get`

### State Not Updating
- Check Provider setup
- Verify notifyListeners() calls
- Use Consumer widgets properly

### Navigation Issues
- Check BuildContext validity
- Use mounted checks for async operations
- Verify route definitions
