import 'dart:math';
import '../../shared/models/user_model.dart';
import '../../shared/models/quiz_model.dart';
import '../../shared/models/message_model.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock Users
  final List<UserModel> _mockUsers = [
    UserModel(
      id: '1',
      name: 'Alex Johnson',
      email: 'alex.johnson@email.com',
      role: 'student',
      profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
      isActive: true,
      analytics: {
        'quizzesCompleted': 5,
        'averageScore': 78.5,
        'totalTimeSpent': 120,
        'strengths': ['Problem Solving', 'Critical Thinking'],
        'weaknesses': ['Time Management', 'Communication'],
      },
    ),
    UserModel(
      id: '2',
      name: 'Sarah Chen',
      email: 'sarah.chen@email.com',
      role: 'student',
      profileImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      lastLogin: DateTime.now().subtract(const Duration(hours: 1)),
      isActive: true,
      analytics: {
        'quizzesCompleted': 8,
        'averageScore': 85.2,
        'totalTimeSpent': 180,
        'strengths': ['Leadership', 'Teamwork'],
        'weaknesses': ['Technical Skills', 'Public Speaking'],
      },
    ),
    UserModel(
      id: '3',
      name: 'Dr. Michael Rodriguez',
      email: 'michael.rodriguez@email.com',
      role: 'mentor',
      profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      lastLogin: DateTime.now().subtract(const Duration(minutes: 30)),
      isActive: true,
      assignedStudents: ['1', '2', '4', '5'],
      analytics: {
        'studentsMentored': 12,
        'sessionsCompleted': 45,
        'averageRating': 4.8,
        'specializations': ['Career Development', 'Leadership', 'Tech Industry'],
      },
    ),
    UserModel(
      id: '4',
      name: 'Emma Wilson',
      email: 'emma.wilson@email.com',
      role: 'student',
      profileImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      lastLogin: DateTime.now().subtract(const Duration(hours: 4)),
      isActive: true,
      mentorId: '3',
      analytics: {
        'quizzesCompleted': 3,
        'averageScore': 72.0,
        'totalTimeSpent': 90,
        'strengths': ['Creativity', 'Adaptability'],
        'weaknesses': ['Analytical Skills', 'Focus'],
      },
    ),
    UserModel(
      id: '5',
      name: 'James Thompson',
      email: 'james.thompson@email.com',
      role: 'student',
      profileImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      lastLogin: DateTime.now().subtract(const Duration(hours: 6)),
      isActive: true,
      mentorId: '3',
      analytics: {
        'quizzesCompleted': 6,
        'averageScore': 88.3,
        'totalTimeSpent': 150,
        'strengths': ['Technical Skills', 'Problem Solving'],
        'weaknesses': ['Communication', 'Teamwork'],
      },
    ),
  ];

  // Mock Quizzes
  final List<QuizModel> _mockQuizzes = [
    QuizModel(
      id: '1',
      title: 'Career Aptitude Assessment',
      description: 'Discover your ideal career path based on your interests, skills, and personality traits.',
      timeLimit: 30,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      questions: [
        QuizQuestion(
          id: 'q1',
          question: 'What type of work environment do you prefer?',
          options: [
            QuizOption(id: 'o1', text: 'Collaborative team setting'),
            QuizOption(id: 'o2', text: 'Independent work space'),
            QuizOption(id: 'o3', text: 'Dynamic, fast-paced environment'),
            QuizOption(id: 'o4', text: 'Structured, organized setting'),
          ],
          correctAnswerIndex: 0,
          explanation: 'This helps determine your preferred work style and team dynamics.',
          points: 1,
        ),
        QuizQuestion(
          id: 'q2',
          question: 'Which activity energizes you most?',
          options: [
            QuizOption(id: 'o5', text: 'Solving complex problems'),
            QuizOption(id: 'o6', text: 'Creating something new'),
            QuizOption(id: 'o7', text: 'Helping others succeed'),
            QuizOption(id: 'o8', text: 'Analyzing data and trends'),
          ],
          correctAnswerIndex: 1,
          explanation: 'This reveals your primary source of motivation and satisfaction.',
          points: 1,
        ),
        QuizQuestion(
          id: 'q3',
          question: 'How do you prefer to learn new skills?',
          options: [
            QuizOption(id: 'o9', text: 'Hands-on practice'),
            QuizOption(id: 'o10', text: 'Reading and research'),
            QuizOption(id: 'o11', text: 'Learning from others'),
            QuizOption(id: 'o12', text: 'Trial and error'),
          ],
          correctAnswerIndex: 0,
          explanation: 'Understanding your learning style helps identify suitable career paths.',
          points: 1,
        ),
      ],
    ),
    QuizModel(
      id: '2',
      title: 'Leadership Skills Evaluation',
      description: 'Assess your leadership potential and identify areas for development.',
      timeLimit: 25,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      questions: [
        QuizQuestion(
          id: 'q4',
          question: 'How do you handle team conflicts?',
          options: [
            QuizOption(id: 'o13', text: 'Mediate and find common ground'),
            QuizOption(id: 'o14', text: 'Let the team resolve it themselves'),
            QuizOption(id: 'o15', text: 'Make a quick decision'),
            QuizOption(id: 'o16', text: 'Avoid the conflict'),
          ],
          correctAnswerIndex: 0,
          explanation: 'Effective conflict resolution is a key leadership skill.',
          points: 1,
        ),
        QuizQuestion(
          id: 'q5',
          question: 'What motivates you to take on leadership roles?',
          options: [
            QuizOption(id: 'o17', text: 'Helping others grow'),
            QuizOption(id: 'o18', text: 'Achieving organizational goals'),
            QuizOption(id: 'o19', text: 'Personal recognition'),
            QuizOption(id: 'o20', text: 'Making important decisions'),
          ],
          correctAnswerIndex: 0,
          explanation: 'Understanding your motivation helps align with leadership opportunities.',
          points: 1,
        ),
      ],
    ),
    QuizModel(
      id: '3',
      title: 'Technical Skills Assessment',
      description: 'Evaluate your technical competencies and identify skill gaps.',
      timeLimit: 40,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      questions: [
        QuizQuestion(
          id: 'q6',
          question: 'Which programming language are you most comfortable with?',
          options: [
            QuizOption(id: 'o21', text: 'Python'),
            QuizOption(id: 'o22', text: 'JavaScript'),
            QuizOption(id: 'o23', text: 'Java'),
            QuizOption(id: 'o24', text: 'C++'),
          ],
          correctAnswerIndex: 0,
          explanation: 'Technical skills assessment helps identify your strengths.',
          points: 1,
        ),
        QuizQuestion(
          id: 'q7',
          question: 'How do you approach debugging code?',
          options: [
            QuizOption(id: 'o25', text: 'Systematic step-by-step approach'),
            QuizOption(id: 'o26', text: 'Trial and error'),
            QuizOption(id: 'o27', text: 'Ask for help immediately'),
            QuizOption(id: 'o28', text: 'Use debugging tools'),
          ],
          correctAnswerIndex: 0,
          explanation: 'Debugging approach reveals problem-solving methodology.',
          points: 1,
        ),
      ],
    ),
  ];

  // Mock Quiz Results
  final List<QuizResult> _mockQuizResults = [
    QuizResult(
      id: 'r1',
      quizId: '1',
      userId: '1',
      userName: 'Alex Johnson',
      answers: [
        QuizAnswer(questionId: 'q1', selectedOptionIndex: 0, isCorrect: true, timeSpent: 45),
        QuizAnswer(questionId: 'q2', selectedOptionIndex: 1, isCorrect: true, timeSpent: 30),
        QuizAnswer(questionId: 'q3', selectedOptionIndex: 0, isCorrect: true, timeSpent: 60),
      ],
      totalQuestions: 3,
      correctAnswers: 3,
      score: 3,
      percentage: 100.0,
      timeSpent: 135,
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
      analysis: {
        'careerRecommendations': ['Software Engineer', 'Product Manager', 'Data Analyst'],
        'strengths': ['Problem Solving', 'Collaboration', 'Hands-on Learning'],
        'developmentAreas': ['Time Management', 'Public Speaking'],
      },
    ),
    QuizResult(
      id: 'r2',
      quizId: '2',
      userId: '1',
      userName: 'Alex Johnson',
      answers: [
        QuizAnswer(questionId: 'q4', selectedOptionIndex: 0, isCorrect: true, timeSpent: 30),
        QuizAnswer(questionId: 'q5', selectedOptionIndex: 0, isCorrect: true, timeSpent: 25),
      ],
      totalQuestions: 2,
      correctAnswers: 2,
      score: 2,
      percentage: 100.0,
      timeSpent: 55,
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
      analysis: {
        'leadershipStyle': 'Collaborative',
        'strengths': ['Conflict Resolution', 'Team Development'],
        'developmentAreas': ['Strategic Thinking', 'Decision Making'],
      },
    ),
  ];

  // Mock Messages
  final List<MessageModel> _mockMessages = [
    MessageModel(
      id: 'm1',
      senderId: '3',
      senderName: 'Dr. Michael Rodriguez',
      receiverId: '1',
      receiverName: 'Alex Johnson',
      message: 'Great job on your recent quiz! Your problem-solving skills are really improving. Let\'s schedule a session to discuss your career goals.',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    MessageModel(
      id: 'm2',
      senderId: '1',
      senderName: 'Alex Johnson',
      receiverId: '3',
      receiverName: 'Dr. Michael Rodriguez',
      message: 'Thank you! I\'d love to discuss my career path. When would be a good time for a session?',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: true,
    ),
    MessageModel(
      id: 'm3',
      senderId: '3',
      senderName: 'Dr. Michael Rodriguez',
      receiverId: '1',
      receiverName: 'Alex Johnson',
      message: 'How about tomorrow at 2 PM? We can discuss the career recommendations from your assessment.',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
    ),
  ];

  // Mock Chat Rooms
  final List<ChatRoom> _mockChatRooms = [
    ChatRoom(
      id: 'room1',
      name: 'Alex Johnson',
      participants: ['1', '3'],
      lastMessage: 'How about tomorrow at 2 PM? We can discuss the career recommendations from your assessment.',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
      unreadCount: 1,
      isGroup: false,
      createdBy: '1',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ChatRoom(
      id: 'room2',
      name: 'Sarah Chen',
      participants: ['2', '3'],
      lastMessage: 'I completed the leadership assessment. Can we review the results?',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 0,
      isGroup: false,
      createdBy: '2',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // Getters
  List<UserModel> get mockUsers => _mockUsers;
  List<QuizModel> get mockQuizzes => _mockQuizzes;
  List<QuizResult> get mockQuizResults => _mockQuizResults;
  List<MessageModel> get mockMessages => _mockMessages;
  List<ChatRoom> get mockChatRooms => _mockChatRooms;

  // User methods
  UserModel? getUserById(String id) {
    try {
      return _mockUsers.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  List<UserModel> getStudentsByMentorId(String mentorId) {
    return _mockUsers.where((user) => user.mentorId == mentorId).toList();
  }

  UserModel? getMentorByStudentId(String studentId) {
    final student = getUserById(studentId);
    if (student?.mentorId != null) {
      return getUserById(student!.mentorId!);
    }
    return null;
  }

  // Quiz methods
  QuizModel? getQuizById(String id) {
    try {
      return _mockQuizzes.firstWhere((quiz) => quiz.id == id);
    } catch (e) {
      return null;
    }
  }

  List<QuizResult> getQuizResultsByUserId(String userId) {
    return _mockQuizResults.where((result) => result.userId == userId).toList();
  }

  List<QuizResult> getQuizResultsByQuizId(String quizId) {
    return _mockQuizResults.where((result) => result.quizId == quizId).toList();
  }

  // Message methods
  List<MessageModel> getMessagesByRoomId(String roomId) {
    // For simplicity, return all messages for now
    // In a real app, you'd filter by room
    return _mockMessages;
  }

  List<ChatRoom> getChatRoomsByUserId(String userId) {
    return _mockChatRooms.where((room) => room.participants.contains(userId)).toList();
  }

  // Analytics methods
  Map<String, dynamic> getStudentAnalytics(String userId) {
    final results = getQuizResultsByUserId(userId);
    if (results.isEmpty) {
      return {
        'totalQuizzes': 0,
        'averageScore': 0.0,
        'totalTimeSpent': 0,
        'strengths': [],
        'weaknesses': [],
        'recentPerformance': [],
      };
    }

    final totalQuizzes = results.length;
    final averageScore = results.map((r) => r.percentage).reduce((a, b) => a + b) / totalQuizzes;
    final totalTimeSpent = results.map((r) => r.timeSpent).reduce((a, b) => a + b);

    return {
      'totalQuizzes': totalQuizzes,
      'averageScore': averageScore,
      'totalTimeSpent': totalTimeSpent,
      'strengths': ['Problem Solving', 'Critical Thinking', 'Collaboration'],
      'weaknesses': ['Time Management', 'Public Speaking'],
      'recentPerformance': results.take(5).map((r) => {
        'quizId': r.quizId,
        'score': r.percentage,
        'date': r.completedAt,
      }).toList(),
    };
  }

  Map<String, dynamic> getMentorAnalytics(String mentorId) {
    final students = getStudentsByMentorId(mentorId);
    final totalStudents = students.length;
    final activeStudents = students.where((s) => s.isActive).length;
    
    return {
      'totalStudents': totalStudents,
      'activeStudents': activeStudents,
      'averageStudentScore': 82.5,
      'totalSessions': 45,
      'upcomingSessions': 3,
      'recentActivity': [
        {
          'type': 'quiz_completed',
          'studentName': 'Alex Johnson',
          'quizName': 'Career Aptitude Assessment',
          'score': 100.0,
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        },
        {
          'type': 'message_received',
          'studentName': 'Sarah Chen',
          'message': 'I completed the leadership assessment...',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
        },
      ],
    };
  }

  // Mock authentication
  Future<Map<String, dynamic>> authenticateUser(String email, String password, String? role) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    final user = _mockUsers.firstWhere(
      (u) => u.email == email && u.role == (role ?? 'student'),
      orElse: () => throw Exception('User not found'),
    );

    // Simulate password check (in real app, this would be hashed)
    if (password != 'password123') {
      throw Exception('Invalid credentials');
    }

    return {
      'success': true,
      'user': user,
      'token': 'mock_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}',
    };
  }

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
    String? mentorId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Check if user already exists
    if (_mockUsers.any((u) => u.email == email)) {
      return {
        'success': false,
        'message': 'User with this email already exists',
      };
    }

    // Create new user
    final newUser = UserModel(
      id: (_mockUsers.length + 1).toString(),
      name: name,
      email: email,
      role: role,
      createdAt: DateTime.now(),
      isActive: true,
      mentorId: mentorId,
    );

    _mockUsers.add(newUser);

    return {
      'success': true,
      'message': 'User registered successfully',
      'user': newUser,
    };
  }
}
