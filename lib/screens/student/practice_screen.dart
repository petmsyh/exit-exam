import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/module.dart';
import '../../models/past_question.dart';
import '../../models/ai_question.dart';

class PracticeScreen extends StatefulWidget {
  final Module module;

  const PracticeScreen({super.key, required this.module});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _databaseService = DatabaseService();
  List<dynamic> _questions = []; // Can hold PastQuestion or AIQuestion
  bool _isLoading = true;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showExplanation = false;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    try {
      final pastQuestions =
          await _databaseService.getPastQuestionsByModule(widget.module.id);
      final aiQuestions = await _databaseService
          .getApprovedAIQuestionsByModule(widget.module.id);

      final allQuestions = [...pastQuestions, ...aiQuestions];
      allQuestions.shuffle(); // Shuffle for variety

      setState(() {
        _questions = allQuestions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load questions: $e')),
        );
      }
    }
  }

  void _checkAnswer() {
    final currentQuestion = _questions[_currentQuestionIndex];
    final correctAnswer = currentQuestion is PastQuestion
        ? currentQuestion.correctAnswer
        : (currentQuestion as AIQuestion).correctAnswer;

    if (_selectedAnswer == correctAnswer) {
      _correctAnswers++;
    }

    setState(() {
      _showExplanation = true;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showExplanation = false;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Practice Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $_correctAnswers / ${_questions.length}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Percentage: ${((_correctAnswers / _questions.length) * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Back to Module'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestionIndex = 0;
                _selectedAnswer = null;
                _showExplanation = false;
                _correctAnswers = 0;
              });
              _loadQuestions();
            },
            child: const Text('Practice Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Practice')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Practice')),
        body: const Center(
          child: Text(
            'No questions available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final question = currentQuestion is PastQuestion
        ? currentQuestion.question
        : (currentQuestion as AIQuestion).question;
    final options = currentQuestion is PastQuestion
        ? currentQuestion.options
        : (currentQuestion as AIQuestion).options;
    final correctAnswer = currentQuestion is PastQuestion
        ? currentQuestion.correctAnswer
        : (currentQuestion as AIQuestion).correctAnswer;
    final explanation = currentQuestion is PastQuestion
        ? currentQuestion.explanation
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1}/${_questions.length}'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = _selectedAnswer == option;
                    final isCorrect = option == correctAnswer;
                    
                    Color? tileColor;
                    if (_showExplanation) {
                      if (isCorrect) {
                        tileColor = Colors.green.withOpacity(0.2);
                      } else if (isSelected && !isCorrect) {
                        tileColor = Colors.red.withOpacity(0.2);
                      }
                    }

                    return Card(
                      color: tileColor,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: _selectedAnswer,
                        onChanged: _showExplanation
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedAnswer = value;
                                });
                              },
                      ),
                    );
                  }),
                  if (_showExplanation && explanation != null) ...[
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.blue.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Explanation:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(explanation),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _showExplanation
                  ? ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _currentQuestionIndex < _questions.length - 1
                            ? 'Next Question'
                            : 'Finish',
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _selectedAnswer == null ? null : _checkAnswer,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Check Answer'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
