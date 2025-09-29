# Praniti - Career Guidance Platform

A comprehensive Flutter mobile application designed to help students discover their career paths through interactive quizzes, mentorship, and personalized guidance.

## 🚀 Features

### For Students
- **Career Assessment Quizzes**: Take comprehensive quizzes to discover your ideal career path
- **Progress Tracking**: Monitor your performance and track improvement over time
- **Mentor Connection**: Connect with experienced mentors for personalized guidance
- **Real-time Chat**: Communicate directly with your assigned mentor
- **Analytics Dashboard**: View detailed insights about your strengths and areas for improvement

### For Mentors
- **Student Management**: View and manage all assigned students
- **Performance Analytics**: Track student progress and identify areas needing attention
- **Communication Tools**: Chat with students and provide real-time guidance
- **Session Scheduling**: Plan and manage mentoring sessions
- **Detailed Reports**: Generate comprehensive reports on student performance

## 📱 App Screenshots

### Student Dashboard
- Modern, intuitive interface with progress tracking
- Quick access to quizzes and results
- Real-time activity feed
- Performance analytics with visual charts

### Mentor Dashboard
- Comprehensive student overview
- Performance metrics and analytics
- Communication tools
- Session management

### Quiz System
- Multiple quiz types: Career Aptitude, Leadership Skills, Technical Skills
- Interactive question interface with progress tracking
- Detailed results with personalized recommendations
- Performance analysis and next steps

### Chat System
- Real-time messaging between mentors and students
- File sharing capabilities
- Message history and search
- User profiles and status

## 🛠️ Technical Stack

- **Framework**: Flutter 3.5.4+
- **State Management**: Riverpod
- **Navigation**: Go Router
- **Local Storage**: Hive
- **HTTP Client**: Dio
- **UI Components**: Material Design 3
- **Animations**: Flutter Animations
- **Charts**: FL Chart

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  material_design_icons_flutter: ^7.0.7296
  provider: ^6.1.2
  riverpod: ^2.5.1
  flutter_riverpod: ^2.5.1
  http: ^1.2.2
  dio: ^5.7.0
  shared_preferences: ^2.3.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  jwt_decoder: ^2.0.1
  crypto: ^3.0.5
  socket_io_client: ^2.0.3+1
  flutter_svg: ^2.0.10+1
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0
  lottie: ^3.1.2
  fl_chart: ^0.69.0
  syncfusion_flutter_charts: ^26.2.14
  go_router: ^14.2.7
  form_builder_validators: ^11.0.0
  flutter_form_builder: ^9.4.1
  intl: ^0.19.0
  file_picker: ^8.1.2
  path_provider: ^2.1.4
  flutter_local_notifications: ^17.2.3
  image_picker: ^1.1.2
  qr_flutter: ^4.1.0
  pdf: ^3.11.1
  printing: ^5.13.2
  connectivity_plus: ^6.0.5
  flutter_spinkit: ^5.2.1
  animations: ^2.0.11
  url_launcher: ^6.3.1
  package_info_plus: ^8.0.2
  device_info_plus: ^10.1.2
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.5.4 or higher)
- Dart SDK (3.5.4 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Lalith-47/app_frontend.git
   cd app_frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Mock Data

The app currently uses comprehensive mock data for demonstration purposes. This includes:
- Sample users (students and mentors)
- Pre-configured quizzes with multiple question types
- Mock chat conversations
- Sample analytics and performance data

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🎨 UI/UX Features

- **Material Design 3**: Modern, accessible design system
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Responsive Design**: Optimized for all screen sizes
- **Smooth Animations**: Delightful micro-interactions and transitions
- **Accessibility**: Full support for screen readers and accessibility features

## 🔧 Architecture

The app follows a clean architecture pattern with:

- **Features**: Organized by feature modules (auth, quiz, chat, etc.)
- **Core**: Shared utilities, constants, and services
- **Shared**: Common widgets, models, and providers
- **State Management**: Riverpod for reactive state management
- **Navigation**: Go Router for declarative routing

## 📊 Quiz Types

1. **Career Aptitude Assessment**
   - Work environment preferences
   - Learning style assessment
   - Interest and motivation analysis
   - Career recommendations

2. **Leadership Skills Evaluation**
   - Conflict resolution abilities
   - Team management skills
   - Decision-making processes
   - Leadership style identification

3. **Technical Skills Assessment**
   - Programming language proficiency
   - Problem-solving approaches
   - Technical knowledge evaluation
   - Skill gap identification

## 🔐 Authentication

- Role-based authentication (Student/Mentor)
- Secure token management
- Profile management
- Password reset functionality

## 💬 Chat Features

- Real-time messaging
- File sharing capabilities
- Message status indicators
- User presence indicators
- Message search and history

## 📈 Analytics

- Student performance tracking
- Quiz completion statistics
- Time spent analysis
- Progress visualization
- Mentor dashboard insights

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Lalith** - *Initial work* - [Lalith-47](https://github.com/Lalith-47)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- Open source community for the excellent packages

## 📞 Support

If you have any questions or need help, please:
- Open an issue on GitHub
- Contact the development team
- Check the documentation

---

**Made with ❤️ using Flutter**
