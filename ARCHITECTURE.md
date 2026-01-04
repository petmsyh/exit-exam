# System Architecture Diagrams

## Overall System Architecture

```mermaid
graph TB
    A[Flutter Mobile App] --> B[Firebase Authentication]
    A --> C[Cloud Firestore]
    A --> D[Firebase Storage]
    B --> C
    C --> E[Users Collection]
    C --> F[Departments Collection]
    C --> G[Courses Collection]
    C --> H[Modules Collection]
    C --> I[Materials Collection]
    C --> J[Questions Collections]
    D --> K[PDF Files]
    D --> L[Media Assets]
```

## User Flow Diagrams

### Registration Flow

```mermaid
sequenceDiagram
    participant U as User
    participant A as App
    participant FA as Firebase Auth
    participant FS as Firestore
    
    U->>A: Fill registration form
    U->>A: Enter university (text)
    U->>A: Select department (dropdown)
    A->>FS: Load departments
    FS-->>A: Return departments list
    U->>A: Submit registration
    A->>FA: Create user account
    FA-->>A: User created (UID)
    A->>FS: Create user document (status: pending)
    FS-->>A: Document created
    A-->>U: Show pending approval screen
```

### Approval Flow

```mermaid
sequenceDiagram
    participant S as Student
    participant A as App
    participant FS as Firestore
    participant Admin as Admin
    
    S->>A: Login
    A->>FS: Check user status
    FS-->>A: Status: pending
    A-->>S: Show pending screen
    
    Admin->>A: Open pending students
    A->>FS: Query pending students
    FS-->>Admin: List of students
    Admin->>A: Approve student
    A->>FS: Update status to approved
    FS-->>A: Updated
    
    S->>A: Login again
    A->>FS: Check user status
    FS-->>A: Status: approved
    A-->>S: Show student dashboard
```

### Student Content Access Flow

```mermaid
sequenceDiagram
    participant S as Student
    participant A as App
    participant FS as Firestore
    
    S->>A: Login (approved)
    A->>FS: Get user department
    FS-->>A: Department ID
    A->>FS: Query courses by department
    FS-->>A: Department courses
    A-->>S: Display courses
    
    S->>A: Select course
    A->>FS: Query modules by course
    FS-->>A: Course modules
    A-->>S: Display modules
    
    S->>A: Select module
    A->>FS: Query materials by module
    A->>FS: Query questions by module
    FS-->>A: Materials & questions
    A-->>S: Display module content
```

## Data Model Relationships

```mermaid
erDiagram
    USERS ||--o{ DEPARTMENTS : "belongs to"
    DEPARTMENTS ||--o{ COURSES : "contains"
    COURSES ||--o{ MODULES : "contains"
    MODULES ||--o{ MATERIALS : "has"
    MODULES ||--o{ PAST_QUESTIONS : "has"
    MODULES ||--o{ AI_QUESTIONS : "has"
    USERS ||--o{ MATERIALS : "uploads"
    
    USERS {
        string id PK
        string name
        string email
        enum role
        string university
        string departmentId FK
        enum status
        timestamp createdAt
    }
    
    DEPARTMENTS {
        string id PK
        string name
        timestamp createdAt
    }
    
    COURSES {
        string id PK
        string departmentId FK
        string name
        string description
    }
    
    MODULES {
        string id PK
        string courseId FK
        string title
        string description
    }
    
    MATERIALS {
        string id PK
        string departmentId FK
        string courseId FK
        string moduleId FK
        enum type
        string url
        string uploadedBy FK
        timestamp createdAt
    }
    
    PAST_QUESTIONS {
        string id PK
        string departmentId FK
        string courseId FK
        string moduleId FK
        int year
        string question
        array options
        string correctAnswer
        string explanation
    }
    
    AI_QUESTIONS {
        string id PK
        string departmentId FK
        string courseId FK
        string moduleId FK
        enum difficulty
        bool approved
        string question
        array options
        string correctAnswer
    }
```

## Role-Based Access Control

```mermaid
graph LR
    A[User Roles] --> B[Student]
    A --> C[Admin]
    A --> D[Super Admin]
    
    B --> E[View Own Dept Content]
    B --> F[Practice Questions]
    
    C --> G[Manage Courses]
    C --> H[Manage Modules]
    C --> I[Manage Materials]
    C --> J[Approve Students]
    
    D --> K[All Admin Rights]
    D --> L[Manage Departments]
```

## Security Architecture

```mermaid
graph TB
    A[User Request] --> B{Authenticated?}
    B -->|No| C[Deny Access]
    B -->|Yes| D{Check Role}
    
    D --> E[Student]
    D --> F[Admin]
    D --> G[Super Admin]
    
    E --> H{Status Approved?}
    H -->|No| I[Show Pending Screen]
    H -->|Yes| J{Department Match?}
    J -->|Yes| K[Allow Access]
    J -->|No| L[Deny Access]
    
    F --> M{Department Match?}
    M -->|Yes| N[Allow Management]
    M -->|No| O[Deny Management]
    
    G --> P[Allow All Operations]
```

## Application State Flow

```mermaid
stateDiagram-v2
    [*] --> SplashScreen
    SplashScreen --> LoginScreen: Not Authenticated
    SplashScreen --> CheckUserStatus: Authenticated
    
    CheckUserStatus --> StudentDashboard: Student + Approved
    CheckUserStatus --> PendingScreen: Student + Pending
    CheckUserStatus --> PendingScreen: Student + Rejected
    CheckUserStatus --> AdminDashboard: Admin/Super Admin
    
    LoginScreen --> RegisterScreen: New User
    RegisterScreen --> PendingScreen: Registration Complete
    
    StudentDashboard --> CoursesScreen: Select Course
    CoursesScreen --> ModuleScreen: Select Module
    ModuleScreen --> PracticeScreen: Start Practice
    PracticeScreen --> ResultScreen: Complete
    
    AdminDashboard --> ManageDepartments: Super Admin
    AdminDashboard --> ManageCourses: All Admins
    AdminDashboard --> PendingStudents: All Admins
    
    ManageCourses --> ManageModules: Select Course
    ManageModules --> ManageMaterials: Select Module
```

## Component Architecture

```mermaid
graph TB
    A[Main App] --> B[Provider Setup]
    B --> C[AuthService]
    B --> D[Material App]
    
    D --> E[Splash Screen]
    E --> F{Route Based on Auth}
    
    F --> G[Auth Screens]
    F --> H[Student Screens]
    F --> I[Admin Screens]
    
    G --> G1[Login]
    G --> G2[Register]
    G --> G3[Pending Approval]
    
    H --> H1[Dashboard]
    H1 --> H2[Courses]
    H2 --> H3[Modules]
    H3 --> H4[Practice]
    
    I --> I1[Admin Dashboard]
    I1 --> I2[Manage Departments]
    I1 --> I3[Manage Courses]
    I1 --> I4[Manage Modules]
    I1 --> I5[Manage Materials]
    I1 --> I6[Pending Students]
    
    C --> J[Firebase Auth]
    C --> K[Firestore Users]
    
    H --> L[DatabaseService]
    I --> L
    L --> M[Firestore Collections]
```

## Deployment Architecture

```mermaid
graph TB
    A[Developer] --> B[Flutter Build]
    B --> C[APK/AAB]
    C --> D[Google Play Store]
    
    E[Firebase Console] --> F[Authentication]
    E --> G[Firestore]
    E --> H[Storage]
    E --> I[Security Rules]
    
    D --> J[Users Download]
    J --> K[Mobile Devices]
    K --> F
    K --> G
    K --> H
    
    I --> G
    I --> H
```

## How to View These Diagrams

These diagrams are written in Mermaid syntax. To view them:

1. **GitHub**: Automatically renders Mermaid in markdown files
2. **VS Code**: Install "Markdown Preview Mermaid Support" extension
3. **Online**: Use [Mermaid Live Editor](https://mermaid.live/)
4. **Documentation Sites**: Most support Mermaid (GitBook, Docusaurus, etc.)

## Diagram Descriptions

### Overall System Architecture
Shows the high-level components and their relationships.

### User Flow Diagrams
Illustrate the sequence of interactions for key user journeys.

### Data Model Relationships
Entity-relationship diagram showing Firestore collections and their connections.

### Role-Based Access Control
Shows the permission hierarchy and what each role can do.

### Security Architecture
Decision tree for access control and security checks.

### Application State Flow
State machine showing navigation between screens.

### Component Architecture
Hierarchical view of the app's component structure.

### Deployment Architecture
Shows how the app is deployed and connects to Firebase services.
