import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, admin, superAdmin }

enum UserStatus { pending, approved, rejected }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String university;
  final String? departmentId;
  final UserStatus status;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.university,
    this.departmentId,
    required this.status,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: _parseRole(data['role']),
      university: data['university'] ?? '',
      departmentId: data['departmentId'],
      status: _parseStatus(data['status']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'university': university,
      'departmentId': departmentId,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static UserRole _parseRole(String? roleString) {
    switch (roleString) {
      case 'admin':
        return UserRole.admin;
      case 'superAdmin':
      case 'super_admin':
        return UserRole.superAdmin;
      default:
        return UserRole.student;
    }
  }

  static UserStatus _parseStatus(String? statusString) {
    switch (statusString) {
      case 'approved':
        return UserStatus.approved;
      case 'rejected':
        return UserStatus.rejected;
      default:
        return UserStatus.pending;
    }
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? university,
    String? departmentId,
    UserStatus? status,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      university: university ?? this.university,
      departmentId: departmentId ?? this.departmentId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
