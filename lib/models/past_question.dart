import 'package:cloud_firestore/cloud_firestore.dart';

class PastQuestion {
  final String id;
  final String departmentId;
  final String courseId;
  final String moduleId;
  final int year;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  PastQuestion({
    required this.id,
    required this.departmentId,
    required this.courseId,
    required this.moduleId,
    required this.year,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory PastQuestion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PastQuestion(
      id: doc.id,
      departmentId: data['departmentId'] ?? '',
      courseId: data['courseId'] ?? '',
      moduleId: data['moduleId'] ?? '',
      year: data['year'] ?? 0,
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
      explanation: data['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'departmentId': departmentId,
      'courseId': courseId,
      'moduleId': moduleId,
      'year': year,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }
}
