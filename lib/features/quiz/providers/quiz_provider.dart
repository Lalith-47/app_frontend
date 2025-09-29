import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/quiz_model.dart';
import '../services/quiz_service.dart';

class QuizState {
  final bool isLoading;
  final List<QuizModel> availableQuizzes;
  final List<QuizResult> userResults;
  final QuizModel? currentQuiz;
  final QuizResult? currentResult;
  final Map<String, dynamic>? analytics;
  final String? error;

  const QuizState({
    this.isLoading = false,
    this.availableQuizzes = const [],
    this.userResults = const [],
    this.currentQuiz,
    this.currentResult,
    this.analytics,
    this.error,
  });

  QuizState copyWith({
    bool? isLoading,
    List<QuizModel>? availableQuizzes,
    List<QuizResult>? userResults,
    QuizModel? currentQuiz,
    QuizResult? currentResult,
    Map<String, dynamic>? analytics,
    String? error,
  }) {
    return QuizState(
      isLoading: isLoading ?? this.isLoading,
      availableQuizzes: availableQuizzes ?? this.availableQuizzes,
      userResults: userResults ?? this.userResults,
      currentQuiz: currentQuiz ?? this.currentQuiz,
      currentResult: currentResult ?? this.currentResult,
      analytics: analytics ?? this.analytics,
      error: error,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  final QuizService _quizService;

  QuizNotifier(this._quizService) : super(const QuizState());

  Future<void> loadAvailableQuizzes() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final quizzes = await _quizService.getAvailableQuizzes();
      state = state.copyWith(
        isLoading: false,
        availableQuizzes: quizzes,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadQuizById(String quizId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final quiz = await _quizService.getQuizById(quizId);
      state = state.copyWith(
        isLoading: false,
        currentQuiz: quiz,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadUserResults(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final results = await _quizService.getQuizResultsByUserId(userId);
      state = state.copyWith(
        isLoading: false,
        userResults: results,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> submitQuiz({
    required String quizId,
    required String userId,
    required String userName,
    required List<QuizAnswer> answers,
    required int timeSpent,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _quizService.submitQuiz(
        quizId: quizId,
        userId: userId,
        userName: userName,
        answers: answers,
        timeSpent: timeSpent,
      );
      
      if (result['success']) {
        final quizResult = result['result'] as QuizResult;
        state = state.copyWith(
          isLoading: false,
          currentResult: quizResult,
          userResults: [...state.userResults, quizResult],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['message'] ?? 'Quiz submission failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadStudentAnalytics(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final analytics = await _quizService.getStudentAnalytics(userId);
      state = state.copyWith(
        isLoading: false,
        analytics: analytics,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMentorAnalytics(String mentorId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final analytics = await _quizService.getMentorAnalytics(mentorId);
      state = state.copyWith(
        isLoading: false,
        analytics: analytics,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearCurrentQuiz() {
    state = state.copyWith(currentQuiz: null, currentResult: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final quizServiceProvider = Provider<QuizService>((ref) => QuizService());

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  final quizService = ref.watch(quizServiceProvider);
  return QuizNotifier(quizService);
});

// Convenience providers
final availableQuizzesProvider = Provider<List<QuizModel>>((ref) {
  return ref.watch(quizProvider).availableQuizzes;
});

final userResultsProvider = Provider<List<QuizResult>>((ref) {
  return ref.watch(quizProvider).userResults;
});

final currentQuizProvider = Provider<QuizModel?>((ref) {
  return ref.watch(quizProvider).currentQuiz;
});

final currentResultProvider = Provider<QuizResult?>((ref) {
  return ref.watch(quizProvider).currentResult;
});

final quizAnalyticsProvider = Provider<Map<String, dynamic>?>((ref) {
  return ref.watch(quizProvider).analytics;
});

final quizLoadingProvider = Provider<bool>((ref) {
  return ref.watch(quizProvider).isLoading;
});

final quizErrorProvider = Provider<String?>((ref) {
  return ref.watch(quizProvider).error;
});
