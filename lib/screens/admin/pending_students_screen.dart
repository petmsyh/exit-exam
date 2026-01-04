import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class PendingStudentsScreen extends StatefulWidget {
  const PendingStudentsScreen({super.key});

  @override
  State<PendingStudentsScreen> createState() => _PendingStudentsScreenState();
}

class _PendingStudentsScreenState extends State<PendingStudentsScreen> {
  final _databaseService = DatabaseService();
  List<UserModel> _pendingStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingStudents();
  }

  void _loadPendingStudents() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final departmentId = authService.userModel?.departmentId;

    if (departmentId != null) {
      try {
        final students =
            await _databaseService.getPendingStudents(departmentId);
        setState(() {
          _pendingStudents = students;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load students: $e')),
          );
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateStudentStatus(UserModel student, UserStatus status) async {
    try {
      await _databaseService.updateUserStatus(student.id, status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == UserStatus.approved
                  ? 'Student approved successfully'
                  : 'Student rejected',
            ),
          ),
        );
        _loadPendingStudents();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $e')),
        );
      }
    }
  }

  void _showStudentDetails(UserModel student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Student Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(label: 'Name', value: student.name),
            const SizedBox(height: 8),
            _DetailRow(label: 'Email', value: student.email),
            const SizedBox(height: 8),
            _DetailRow(label: 'University', value: student.university),
            const SizedBox(height: 8),
            _DetailRow(
              label: 'Registered',
              value: student.createdAt.toString().split(' ')[0],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _updateStudentStatus(student, UserStatus.rejected);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reject'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _updateStudentStatus(student, UserStatus.approved);
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Students'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingStudents.isEmpty
              ? const Center(
                  child: Text(
                    'No pending approvals',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pendingStudents.length,
                  itemBuilder: (context, index) {
                    final student = _pendingStudents[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            student.name[0].toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          student.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(student.email),
                            Text(
                              student.university,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _updateStudentStatus(
                                student,
                                UserStatus.approved,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _updateStudentStatus(
                                student,
                                UserStatus.rejected,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _showStudentDetails(student),
                      ),
                    );
                  },
                ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}
