import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/department.dart';
import '../models/course.dart';
import '../models/module.dart';
import '../models/material.dart';
import '../models/past_question.dart';
import '../models/ai_question.dart';
import '../models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Department Operations
  Future<List<Department>> getDepartments() async {
    final snapshot = await _firestore.collection('departments').get();
    return snapshot.docs.map((doc) => Department.fromFirestore(doc)).toList();
  }

  Future<void> createDepartment(String name) async {
    await _firestore.collection('departments').add({
      'name': name,
      'createdAt': Timestamp.now(),
    });
  }

  // Course Operations
  Future<List<Course>> getCoursesByDepartment(String departmentId) async {
    final snapshot = await _firestore
        .collection('courses')
        .where('departmentId', isEqualTo: departmentId)
        .get();
    return snapshot.docs.map((doc) => Course.fromFirestore(doc)).toList();
  }

  Future<void> createCourse({
    required String departmentId,
    required String name,
    required String description,
  }) async {
    await _firestore.collection('courses').add({
      'departmentId': departmentId,
      'name': name,
      'description': description,
    });
  }

  // Module Operations
  Future<List<Module>> getModulesByCourse(String courseId) async {
    final snapshot = await _firestore
        .collection('modules')
        .where('courseId', isEqualTo: courseId)
        .get();
    return snapshot.docs.map((doc) => Module.fromFirestore(doc)).toList();
  }

  Future<void> createModule({
    required String courseId,
    required String title,
    required String description,
  }) async {
    await _firestore.collection('modules').add({
      'courseId': courseId,
      'title': title,
      'description': description,
    });
  }

  // Material Operations
  Future<List<Material>> getMaterialsByModule(String moduleId) async {
    final snapshot = await _firestore
        .collection('materials')
        .where('moduleId', isEqualTo: moduleId)
        .get();
    return snapshot.docs.map((doc) => Material.fromFirestore(doc)).toList();
  }

  Future<void> createMaterial({
    required String departmentId,
    required String courseId,
    required String moduleId,
    required MaterialType type,
    required String url,
    required String uploadedBy,
  }) async {
    await _firestore.collection('materials').add({
      'departmentId': departmentId,
      'courseId': courseId,
      'moduleId': moduleId,
      'type': type.toString().split('.').last,
      'url': url,
      'uploadedBy': uploadedBy,
      'createdAt': Timestamp.now(),
    });
  }

  // Question Operations
  Future<List<PastQuestion>> getPastQuestionsByModule(String moduleId) async {
    final snapshot = await _firestore
        .collection('past_questions')
        .where('moduleId', isEqualTo: moduleId)
        .get();
    return snapshot.docs
        .map((doc) => PastQuestion.fromFirestore(doc))
        .toList();
  }

  Future<List<AIQuestion>> getApprovedAIQuestionsByModule(
      String moduleId) async {
    final snapshot = await _firestore
        .collection('ai_questions')
        .where('moduleId', isEqualTo: moduleId)
        .where('approved', isEqualTo: true)
        .get();
    return snapshot.docs.map((doc) => AIQuestion.fromFirestore(doc)).toList();
  }

  // User Management
  Future<List<UserModel>> getPendingStudents(String departmentId) async {
    final snapshot = await _firestore
        .collection('users')
        .where('departmentId', isEqualTo: departmentId)
        .where('role', isEqualTo: 'student')
        .where('status', isEqualTo: 'pending')
        .get();
    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  Future<void> updateUserStatus(String userId, UserStatus status) async {
    await _firestore.collection('users').doc(userId).update({
      'status': status.toString().split('.').last,
    });
  }

  Future<UserModel?> getUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }
}
