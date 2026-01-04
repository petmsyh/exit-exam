import 'package:cloud_firestore/cloud_firestore.dart';

enum MaterialType { pdf, note, link }

class Material {
  final String id;
  final String departmentId;
  final String courseId;
  final String moduleId;
  final MaterialType type;
  final String url;
  final String uploadedBy;
  final DateTime createdAt;

  Material({
    required this.id,
    required this.departmentId,
    required this.courseId,
    required this.moduleId,
    required this.type,
    required this.url,
    required this.uploadedBy,
    required this.createdAt,
  });

  factory Material.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Material(
      id: doc.id,
      departmentId: data['departmentId'] ?? '',
      courseId: data['courseId'] ?? '',
      moduleId: data['moduleId'] ?? '',
      type: _parseType(data['type']),
      url: data['url'] ?? '',
      uploadedBy: data['uploadedBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'departmentId': departmentId,
      'courseId': courseId,
      'moduleId': moduleId,
      'type': type.toString().split('.').last,
      'url': url,
      'uploadedBy': uploadedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static MaterialType _parseType(String? typeString) {
    switch (typeString) {
      case 'pdf':
        return MaterialType.pdf;
      case 'link':
        return MaterialType.link;
      default:
        return MaterialType.note;
    }
  }
}
