# EthioExitExam - University Exit Examination Preparation System

A comprehensive Flutter-based mobile application designed to help Ethiopian university students prepare for the national University Exit Examination.

## 🎯 Features

### For Students
- ✅ Register with university name and department selection
- ✅ Access department-specific learning materials
- ✅ Practice with past exit exam questions
- ✅ AI-generated practice questions (admin approved)
- ✅ Track progress and performance
- ✅ View explanations for correct answers
- ✅ Access PDFs, notes, and external links

### For Admins
- ✅ Manage courses under their department
- ✅ Create and organize modules
- ✅ Upload learning materials (PDFs, notes, links)
- ✅ Upload past exit exam questions
- ✅ Approve/reject student registrations
- ✅ Manage AI-generated questions

### For Super Admins
- ✅ Create and manage departments
- ✅ All admin capabilities

## 🏗️ Architecture

**Frontend:** Flutter (Dart)  
**Backend:** Firebase
- Firebase Authentication (Email/Password)
- Cloud Firestore (NoSQL Database)
- Firebase Storage (File storage)

## 📱 Screens

### Authentication
- Login Screen
- Registration Screen (with university text field & department dropdown)
- Pending Approval Screen

### Student Screens
- Student Dashboard
- Courses List
- Module Details
- Practice Questions
- Results

### Admin Screens
- Admin Dashboard
- Manage Departments (Super Admin only)
- Manage Courses
- Manage Modules
- Manage Materials
- Pending Students Approval

## 🗄️ Database Schema

### Collections

**users**
```
- id: string
- name: string
- email: string
- role: "student" | "admin" | "superAdmin"
- university: string (text input)
- departmentId: reference
- status: "pending" | "approved" | "rejected"
- createdAt: timestamp
```

**departments**
```
- id: string
- name: string
- createdAt: timestamp
```

**courses**
```
- id: string
- departmentId: reference
- name: string
- description: string
```

**modules**
```
- id: string
- courseId: reference
- title: string
- description: string
```

**materials**
```
- id: string
- departmentId: reference
- courseId: reference
- moduleId: reference
- type: "pdf" | "note" | "link"
- url: string
- uploadedBy: string
- createdAt: timestamp
```

**past_questions**
```
- id: string
- departmentId: reference
- courseId: reference
- moduleId: reference
- year: number
- question: string
- options: array<string>
- correctAnswer: string
- explanation: string
```

**ai_questions**
```
- id: string
- departmentId: reference
- courseId: reference
- moduleId: reference
- difficulty: "easy" | "medium" | "hard"
- approved: boolean
- question: string
- options: array<string>
- correctAnswer: string
```

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/petmsyh/exit-exam.git
   cd exit-exam
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
   
   a. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   
   b. Enable the following services:
      - Authentication (Email/Password)
      - Cloud Firestore
      - Firebase Storage
   
   c. Register your Android app in Firebase:
      - Package name: `com.ethioexitexam.app`
      - Download `google-services.json` and place it in `android/app/`
   
   d. Update `lib/firebase_options.dart` with your Firebase configuration
   
   e. Deploy Firestore security rules:
      ```bash
      firebase deploy --only firestore:rules
      ```

4. **Create initial Super Admin** (in Firestore Console)
   
   Go to Firestore and manually create a user document:
   ```
   Collection: users
   Document ID: [your-user-id-from-auth]
   Fields:
   - name: "Super Admin"
   - email: "admin@example.com"
   - role: "superAdmin"
   - status: "approved"
   - createdAt: [timestamp]
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 🔒 Security

- Role-based access control (RBAC)
- Department-based data isolation
- Firebase security rules enforce access policies
- Only approved students can access content
- Students can only see their department's materials

## 📝 User Registration Flow

1. User registers with:
   - Name
   - Email
   - Password
   - University (manual text input)
   - Department (dropdown selection)
2. Account created with `status: pending`
3. User sees "Pending Approval" screen
4. Department admin approves/rejects registration
5. If approved, user gains access to student dashboard
6. If rejected, user sees rejection message

## 🎓 Department-Based Access

- Each department is independent
- Students only see courses from their department
- Admins only manage their department's content
- Super admins can create departments

## 📄 License

This project is licensed under the MIT License.

## 👥 Contributors

- [Your Name/Team]

## 📧 Support

For issues or questions, please create an issue in the repository.

---

**Note:** This is a comprehensive university exit exam preparation system. Make sure to configure Firebase properly before deploying to production.
