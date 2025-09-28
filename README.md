# Praniti Mobile App

A comprehensive Flutter mobile application for the Praniti Career Guidance Platform, providing role-based access for Students, Mentors, and Administrators.

## Features

### 🔐 Authentication & Role Management

- Secure login/signup with role-based sessions
- JWT token authentication
- Session management with automatic token refresh
- Role-based access control (Admin, Mentor, Student)

### 👨‍🎓 Student Portal

- **Profile Management**: View and update personal information
- **Career Quizzes**: Take aptitude tests and skill assessments
- **Results & Analytics**: View quiz results and performance trends
- **Mentor Connection**: Connect with assigned mentors
- **Real-time Chat**: Communicate with mentors
- **Career Recommendations**: Get personalized career guidance

### 👨‍🏫 Mentor Portal

- **Student Management**: View and manage assigned students
- **Dashboard Analytics**: Comprehensive insights and metrics
- **Session Management**: Schedule and record guidance sessions
- **Performance Tracking**: Monitor student progress
- **Messaging System**: Communicate with students
- **Assignment Management**: Assign/unassign students

### 👨‍💼 Admin Portal

- **User Management**: Manage mentors and students
- **Analytics Dashboard**: Platform-wide insights and metrics
- **System Administration**: Configure platform settings
- **User Analytics**: Track user engagement and performance
- **Content Management**: Manage quizzes and educational content

### 💬 Real-time Communication

- **Integrated Chat System**: Mentor-Student communication
- **Message History**: Persistent message storage
- **File Sharing**: Share documents and resources
- **Push Notifications**: Real-time message alerts

### 🎨 Modern UI/UX

- **Material Design 3**: Modern, intuitive interface
- **Dark/Light Theme**: Automatic theme switching
- **Responsive Design**: Optimized for all screen sizes
- **Smooth Animations**: Enhanced user experience
- **Accessibility**: Full accessibility support

## Technology Stack

- **Framework**: Flutter 3.24.5
- **Language**: Dart 3.5.4
- **State Management**: Riverpod 2.5.1
- **Navigation**: GoRouter 14.2.7
- **HTTP Client**: Dio 5.7.0
- **Local Storage**: Hive 2.2.3
- **Real-time**: Socket.IO
- **Charts**: FL Chart 0.69.0
- **UI Components**: Material Design 3

## Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── errors/            # Error handling
│   ├── network/          # API client
│   └── utils/            # Utility functions
├── features/              # Feature modules
│   ├── auth/             # Authentication
│   ├── student/          # Student features
│   ├── mentor/           # Mentor features
│   ├── admin/            # Admin features
│   ├── chat/             # Chat system
│   └── shared/            # Shared features
├── shared/                # Shared components
│   ├── models/           # Data models
│   ├── providers/        # State providers
│   └── widgets/          # Reusable widgets
└── main.dart             # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK 3.24.5 or higher
- Dart SDK 3.5.4 or higher
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development)

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd praniti_mobile_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure environment**

   - Copy `env.example` to `.env`
   - Update API endpoints and configuration

4. **Run the app**
   ```bash
   flutter run
   ```

### Backend Integration

The app integrates with the existing Praniti web backend:

- **Base URL**: `http://localhost:5000/api`
- **Authentication**: JWT token-based
- **Real-time**: Socket.IO for chat
- **Database**: MongoDB (Azure Cosmos DB)

## API Endpoints

### Authentication

- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `GET /auth/me` - Get current user
- `POST /auth/logout` - User logout

### Student Endpoints

- `GET /student/profile` - Get student profile
- `GET /student/quiz` - Get available quizzes
- `POST /student/quiz/submit` - Submit quiz answers
- `GET /student/results` - Get quiz results
- `GET /student/mentor` - Get assigned mentor

### Mentor Endpoints

- `GET /mentor/students` - Get assigned students
- `GET /mentor/dashboard-stats` - Get dashboard statistics
- `GET /mentor/analytics` - Get analytics data
- `GET /mentor/sessions` - Get session history
- `POST /mentor/sessions` - Create new session

### Admin Endpoints

- `GET /admin/users` - Get all users
- `GET /admin/mentors` - Get all mentors
- `GET /admin/students` - Get all students
- `GET /admin/analytics` - Get platform analytics

### Chat Endpoints

- `GET /chat/messages` - Get chat messages
- `POST /chat/send` - Send message
- `GET /chat/rooms` - Get chat rooms

## Building the App

### Android

1. **Debug Build**

   ```bash
   flutter build apk --debug
   ```

2. **Release Build**

   ```bash
   flutter build apk --release
   ```

3. **App Bundle**
   ```bash
   flutter build appbundle --release
   ```

### iOS

1. **Debug Build**

   ```bash
   flutter build ios --debug
   ```

2. **Release Build**
   ```bash
   flutter build ios --release
   ```

## Deployment

### Android Play Store

1. Build release APK/AAB
2. Create Play Console account
3. Upload to Play Store
4. Configure store listing
5. Submit for review

### iOS App Store

1. Build release iOS app
2. Create App Store Connect account
3. Upload to App Store
4. Configure store listing
5. Submit for review

## Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
API_BASE_URL=http://localhost:5000/api
SOCKET_URL=http://localhost:5000
APP_NAME=Praniti
APP_VERSION=1.0.0
```

### Backend Configuration

Ensure the backend is running and accessible:

```bash
# Start the backend server
cd ../AdhyayanMarg_WebStack/backend
npm run dev
```

## Testing

### Unit Tests

```bash
flutter test
```

### Integration Tests

```bash
flutter test integration_test/
```

### Widget Tests

```bash
flutter test test/widget_test.dart
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Submit a pull request

## Troubleshooting

### Common Issues

1. **Build Errors**

   - Clean build: `flutter clean && flutter pub get`
   - Check Flutter version compatibility

2. **API Connection Issues**

   - Verify backend is running
   - Check network connectivity
   - Validate API endpoints

3. **Authentication Issues**
   - Clear app data
   - Check token expiration
   - Verify user credentials

### Debug Mode

Enable debug logging:

```dart
// In main.dart
import 'package:flutter/foundation.dart';

void main() {
  if (kDebugMode) {
    // Enable debug logging
  }
  runApp(MyApp());
}
```

## Support

For support and questions:

- **Documentation**: [Link to docs]
- **Issues**: [GitHub Issues]
- **Email**: support@praniti.com

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Changelog

### Version 1.0.0

- Initial release
- Role-based authentication
- Student, Mentor, Admin portals
- Real-time chat system
- Quiz and assessment features
- Analytics and reporting
- Modern Material Design 3 UI

---

**Praniti Mobile App** - Empowering career guidance through technology.
