import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String departmentId;
  final String name;
  final String description;

  Course({
    required this.id,
    required this.departmentId,
    required this.name,
    required this.description,
  });

  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      departmentId: data['departmentId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'departmentId': departmentId,
      'name': name,
      'description': description,
    };
  }
}
