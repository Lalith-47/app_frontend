class QuizModel {
  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final int timeLimit; // in minutes
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  QuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.timeLimit,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => QuizQuestion.fromJson(q))
          .toList() ?? [],
      timeLimit: json['timeLimit'] ?? 30,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
      'timeLimit': timeLimit,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class QuizQuestion {
  final String id;
  final String question;
  final List<QuizOption> options;
  final int correctAnswerIndex;
  final String? explanation;
  final int points;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.points = 1,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['_id'] ?? json['id'] ?? '',
      question: json['question'] ?? '',
      options: (json['options'] as List<dynamic>?)
          ?.map((o) => QuizOption.fromJson(o))
          .toList() ?? [],
      correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
      explanation: json['explanation'],
      points: json['points'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options.map((o) => o.toJson()).toList(),
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'points': points,
    };
  }
}

class QuizOption {
  final String id;
  final String text;
  final bool isCorrect;

  QuizOption({
    required this.id,
    required this.text,
    this.isCorrect = false,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['_id'] ?? json['id'] ?? '',
      text: json['text'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCorrect': isCorrect,
    };
  }
}

class QuizResult {
  final String id;
  final String quizId;
  final String userId;
  final String userName;
  final List<QuizAnswer> answers;
  final int totalQuestions;
  final int correctAnswers;
  final int score;
  final double percentage;
  final int timeSpent; // in seconds
  final DateTime completedAt;
  final Map<String, dynamic>? analysis;

  QuizResult({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.userName,
    required this.answers,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
    required this.percentage,
    required this.timeSpent,
    required this.completedAt,
    this.analysis,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['_id'] ?? json['id'] ?? '',
      quizId: json['quizId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      answers: (json['answers'] as List<dynamic>?)
          ?.map((a) => QuizAnswer.fromJson(a))
          .toList() ?? [],
      totalQuestions: json['totalQuestions'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      score: json['score'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
      timeSpent: json['timeSpent'] ?? 0,
      completedAt: DateTime.parse(json['completedAt'] ?? DateTime.now().toIso8601String()),
      analysis: json['analysis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'userId': userId,
      'userName': userName,
      'answers': answers.map((a) => a.toJson()).toList(),
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'score': score,
      'percentage': percentage,
      'timeSpent': timeSpent,
      'completedAt': completedAt.toIso8601String(),
      'analysis': analysis,
    };
  }

  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C+';
    if (percentage >= 40) return 'C';
    return 'F';
  }

  String get performance {
    if (percentage >= 80) return 'Excellent';
    if (percentage >= 60) return 'Good';
    if (percentage >= 40) return 'Average';
    return 'Needs Improvement';
  }
}

class QuizAnswer {
  final String questionId;
  final int selectedOptionIndex;
  final bool isCorrect;
  final int timeSpent; // in seconds

  QuizAnswer({
    required this.questionId,
    required this.selectedOptionIndex,
    required this.isCorrect,
    required this.timeSpent,
  });

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      questionId: json['questionId'] ?? '',
      selectedOptionIndex: json['selectedOptionIndex'] ?? 0,
      isCorrect: json['isCorrect'] ?? false,
      timeSpent: json['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedOptionIndex': selectedOptionIndex,
      'isCorrect': isCorrect,
      'timeSpent': timeSpent,
    };
  }
}




