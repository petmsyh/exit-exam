import 'package:cloud_firestore/cloud_firestore.dart';

enum Difficulty { easy, medium, hard }

class AIQuestion {
  final String id;
  final String departmentId;
  final String courseId;
  final String moduleId;
  final Difficulty difficulty;
  final bool approved;
  final String question;
  final List<String> options;
  final String correctAnswer;

  AIQuestion({
    required this.id,
    required this.departmentId,
    required this.courseId,
    required this.moduleId,
    required this.difficulty,
    required this.approved,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory AIQuestion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AIQuestion(
      id: doc.id,
      departmentId: data['departmentId'] ?? '',
      courseId: data['courseId'] ?? '',
      moduleId: data['moduleId'] ?? '',
      difficulty: _parseDifficulty(data['difficulty']),
      approved: data['approved'] ?? false,
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'departmentId': departmentId,
      'courseId': courseId,
      'moduleId': moduleId,
      'difficulty': difficulty.toString().split('.').last,
      'approved': approved,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }

  static Difficulty _parseDifficulty(String? difficultyString) {
    switch (difficultyString) {
      case 'easy':
        return Difficulty.easy;
      case 'hard':
        return Difficulty.hard;
      default:
        return Difficulty.medium;
    }
  }
}
