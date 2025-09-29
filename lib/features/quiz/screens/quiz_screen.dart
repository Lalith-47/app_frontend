import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/quiz_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared/models/quiz_model.dart';
import '../../../shared/widgets/common/loading_overlay.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String quizId;

  const QuizScreen({super.key, required this.quizId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentQuestionIndex = 0;
  List<QuizAnswer> _answers = [];
  int _timeSpent = 0;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _loadQuiz();
  }

  void _loadQuiz() {
    ref.read(quizProvider.notifier).loadQuizById(widget.quizId);
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);
    final currentQuiz = quizState.currentQuiz;

    ref.listen<QuizState>(quizProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        ref.read(quizProvider.notifier).clearError();
      }
    });

    if (quizState.isLoading && currentQuiz == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (currentQuiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(
          child: Text('Quiz not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentQuiz.title),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentQuestionIndex + 1}/${currentQuiz.questions.length}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: quizState.isLoading,
        child: Column(
          children: [
            // Progress Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / currentQuiz.questions.length,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            
            // Question
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Text
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        currentQuiz.questions[_currentQuestionIndex].question,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Options
                    ...currentQuiz.questions[_currentQuestionIndex].options.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final option = entry.value;
                        final isSelected = _answers.any((a) => 
                          a.questionId == currentQuiz.questions[_currentQuestionIndex].id &&
                          a.selectedOptionIndex == index
                        );
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () => _selectOption(index),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected 
                                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                  : Theme.of(context).cardColor,
                                border: Border.all(
                                  color: isSelected 
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected 
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected 
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.grey.shade400,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected 
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      option.text,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: isSelected 
                                          ? Theme.of(context).colorScheme.primary
                                          : null,
                                        fontWeight: isSelected 
                                          ? FontWeight.w600 
                                          : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousQuestion,
                        child: const Text('Previous'),
                      ),
                    ),
                  
                  if (_currentQuestionIndex > 0) const SizedBox(width: 16),
                  
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canProceed() ? _nextQuestion : null,
                      child: Text(
                        _currentQuestionIndex == currentQuiz.questions.length - 1
                          ? 'Submit Quiz'
                          : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectOption(int optionIndex) {
    setState(() {
      final questionId = ref.read(quizProvider).currentQuiz!.questions[_currentQuestionIndex].id;
      
      // Remove existing answer for this question
      _answers.removeWhere((a) => a.questionId == questionId);
      
      // Add new answer
      _answers.add(QuizAnswer(
        questionId: questionId,
        selectedOptionIndex: optionIndex,
        isCorrect: optionIndex == ref.read(quizProvider).currentQuiz!.questions[_currentQuestionIndex].correctAnswerIndex,
        timeSpent: DateTime.now().difference(_startTime).inSeconds,
      ));
    });
  }

  bool _canProceed() {
    final questionId = ref.read(quizProvider).currentQuiz!.questions[_currentQuestionIndex].id;
    return _answers.any((a) => a.questionId == questionId);
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _nextQuestion() {
    final currentQuiz = ref.read(quizProvider).currentQuiz!;
    
    if (_currentQuestionIndex < currentQuiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitQuiz();
    }
  }

  void _submitQuiz() {
    final currentQuiz = ref.read(quizProvider).currentQuiz!;
    final currentUser = ref.read(currentUserProvider);
    
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
      return;
    }

    _timeSpent = DateTime.now().difference(_startTime).inSeconds;
    
    ref.read(quizProvider.notifier).submitQuiz(
      quizId: currentQuiz.id,
      userId: currentUser.id,
      userName: currentUser.name,
      answers: _answers,
      timeSpent: _timeSpent,
    );

    // Navigate to results screen
    context.go('/student/results');
  }
}

