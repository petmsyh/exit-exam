import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'auth/login_screen.dart';

class PendingApprovalScreen extends StatelessWidget {
  final UserStatus status;

  const PendingApprovalScreen({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIcon(),
                  size: 100,
                  color: _getColor(),
                ),
                const SizedBox(height: 30),
                Text(
                  _getTitle(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  _getMessage(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    final authService =
                        Provider.of<AuthService>(context, listen: false);
                    await authService.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (status) {
      case UserStatus.pending:
        return Icons.hourglass_empty;
      case UserStatus.rejected:
        return Icons.cancel;
      default:
        return Icons.check_circle;
    }
  }

  Color _getColor() {
    switch (status) {
      case UserStatus.pending:
        return Colors.orange;
      case UserStatus.rejected:
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  String _getTitle() {
    switch (status) {
      case UserStatus.pending:
        return 'Pending Approval';
      case UserStatus.rejected:
        return 'Registration Rejected';
      default:
        return 'Account Status';
    }
  }

  String _getMessage() {
    switch (status) {
      case UserStatus.pending:
        return 'Your registration is under review. You will be notified once your account is approved by the department admin.';
      case UserStatus.rejected:
        return 'Your registration has been rejected. Please contact your department admin for more information.';
      default:
        return 'Please check your account status.';
    }
  }
}
