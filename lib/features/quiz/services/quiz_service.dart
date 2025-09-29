import '../../../core/services/mock_data_service.dart';
import '../../../shared/models/quiz_model.dart';

class QuizService {
  final MockDataService _mockDataService = MockDataService();

  Future<List<QuizModel>> getAvailableQuizzes() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockDataService.mockQuizzes.where((quiz) => quiz.isActive).toList();
  }

  Future<QuizModel?> getQuizById(String quizId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDataService.getQuizById(quizId);
  }

  Future<List<QuizResult>> getQuizResultsByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockDataService.getQuizResultsByUserId(userId);
  }

  Future<Map<String, dynamic>> submitQuiz({
    required String quizId,
    required String userId,
    required String userName,
    required List<QuizAnswer> answers,
    required int timeSpent,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final quiz = await getQuizById(quizId);
    if (quiz == null) {
      throw Exception('Quiz not found');
    }

    // Calculate results
    int correctAnswers = 0;
    int totalScore = 0;
    
    for (int i = 0; i < answers.length; i++) {
      final answer = answers[i];
      final question = quiz.questions.firstWhere(
        (q) => q.id == answer.questionId,
        orElse: () => throw Exception('Question not found'),
      );
      
      if (answer.selectedOptionIndex == question.correctAnswerIndex) {
        correctAnswers++;
        totalScore += question.points;
      }
    }

    final percentage = (correctAnswers / quiz.questions.length) * 100;
    
    // Create quiz result
    final result = QuizResult(
      id: 'result_${DateTime.now().millisecondsSinceEpoch}',
      quizId: quizId,
      userId: userId,
      userName: userName,
      answers: answers,
      totalQuestions: quiz.questions.length,
      correctAnswers: correctAnswers,
      score: totalScore,
      percentage: percentage,
      timeSpent: timeSpent,
      completedAt: DateTime.now(),
      analysis: _generateAnalysis(quiz, answers, percentage),
    );

    // Add to mock data (in real app, this would be saved to server)
    _mockDataService.mockQuizResults.add(result);

    return {
      'success': true,
      'result': result,
      'message': 'Quiz submitted successfully',
    };
  }

  Map<String, dynamic> _generateAnalysis(QuizModel quiz, List<QuizAnswer> answers, double percentage) {
    final analysis = <String, dynamic>{};
    
    // Generate career recommendations based on quiz type and performance
    if (quiz.title.contains('Career Aptitude')) {
      analysis['careerRecommendations'] = _getCareerRecommendations(percentage);
      analysis['strengths'] = _getStrengths(answers);
      analysis['developmentAreas'] = _getDevelopmentAreas(answers);
    } else if (quiz.title.contains('Leadership')) {
      analysis['leadershipStyle'] = _getLeadershipStyle(answers);
      analysis['leadershipStrengths'] = _getLeadershipStrengths(answers);
      analysis['leadershipDevelopmentAreas'] = _getLeadershipDevelopmentAreas(answers);
    } else if (quiz.title.contains('Technical')) {
      analysis['technicalLevel'] = _getTechnicalLevel(percentage);
      analysis['recommendedTechnologies'] = _getRecommendedTechnologies(answers);
      analysis['skillGaps'] = _getSkillGaps(answers);
    }

    analysis['overallPerformance'] = _getOverallPerformance(percentage);
    analysis['nextSteps'] = _getNextSteps(percentage, quiz.title);

    return analysis;
  }

  List<String> _getCareerRecommendations(double percentage) {
    if (percentage >= 80) {
      return ['Software Engineer', 'Product Manager', 'Data Scientist', 'Tech Lead'];
    } else if (percentage >= 60) {
      return ['Business Analyst', 'Project Manager', 'UX Designer', 'Marketing Manager'];
    } else {
      return ['Customer Success', 'Sales Representative', 'Content Creator', 'Support Specialist'];
    }
  }

  List<String> _getStrengths(List<QuizAnswer> answers) {
    final strengths = <String>[];
    if (answers.any((a) => a.selectedOptionIndex == 0)) {
      strengths.add('Collaboration');
    }
    if (answers.any((a) => a.selectedOptionIndex == 1)) {
      strengths.add('Creativity');
    }
    if (answers.any((a) => a.selectedOptionIndex == 2)) {
      strengths.add('Problem Solving');
    }
    return strengths.isNotEmpty ? strengths : ['Adaptability'];
  }

  List<String> _getDevelopmentAreas(List<QuizAnswer> answers) {
    return ['Time Management', 'Public Speaking', 'Technical Skills', 'Leadership'];
  }

  String _getLeadershipStyle(List<QuizAnswer> answers) {
    final collaborativeAnswers = answers.where((a) => a.selectedOptionIndex == 0).length;
    if (collaborativeAnswers > answers.length / 2) {
      return 'Collaborative';
    } else if (answers.any((a) => a.selectedOptionIndex == 1)) {
      return 'Transformational';
    } else {
      return 'Directive';
    }
  }

  List<String> _getLeadershipStrengths(List<QuizAnswer> answers) {
    return ['Team Building', 'Conflict Resolution', 'Communication'];
  }

  List<String> _getLeadershipDevelopmentAreas(List<QuizAnswer> answers) {
    return ['Strategic Thinking', 'Decision Making', 'Delegation'];
  }

  String _getTechnicalLevel(double percentage) {
    if (percentage >= 80) return 'Advanced';
    if (percentage >= 60) return 'Intermediate';
    return 'Beginner';
  }

  List<String> _getRecommendedTechnologies(List<QuizAnswer> answers) {
    return ['Python', 'JavaScript', 'React', 'Node.js', 'AWS'];
  }

  List<String> _getSkillGaps(List<QuizAnswer> answers) {
    return ['Database Design', 'System Architecture', 'DevOps'];
  }

  String _getOverallPerformance(double percentage) {
    if (percentage >= 90) return 'Excellent';
    if (percentage >= 80) return 'Very Good';
    if (percentage >= 70) return 'Good';
    if (percentage >= 60) return 'Satisfactory';
    return 'Needs Improvement';
  }

  List<String> _getNextSteps(double percentage, String quizTitle) {
    final nextSteps = <String>[];
    
    if (percentage < 70) {
      nextSteps.add('Review the quiz questions and explanations');
      nextSteps.add('Take practice quizzes to improve your skills');
    }
    
    if (quizTitle.contains('Career Aptitude')) {
      nextSteps.add('Explore the recommended career paths');
      nextSteps.add('Connect with a mentor in your field of interest');
    } else if (quizTitle.contains('Leadership')) {
      nextSteps.add('Join leadership development programs');
      nextSteps.add('Practice leading small projects or teams');
    } else if (quizTitle.contains('Technical')) {
      nextSteps.add('Enroll in technical courses');
      nextSteps.add('Build projects using the recommended technologies');
    }
    
    nextSteps.add('Schedule a session with your mentor to discuss results');
    
    return nextSteps;
  }

  Future<Map<String, dynamic>> getStudentAnalytics(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDataService.getStudentAnalytics(userId);
  }

  Future<Map<String, dynamic>> getMentorAnalytics(String mentorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDataService.getMentorAnalytics(mentorId);
  }
}
