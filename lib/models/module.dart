import 'package:cloud_firestore/cloud_firestore.dart';

class Module {
  final String id;
  final String courseId;
  final String title;
  final String description;

  Module({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
  });

  factory Module.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Module(
      id: doc.id,
      courseId: data['courseId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'courseId': courseId,
      'title': title,
      'description': description,
    };
  }
}
