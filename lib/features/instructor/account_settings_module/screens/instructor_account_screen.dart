import 'package:flutter/material.dart';
import '../../../../models/instructor_account_model.dart';
import '../widgets/account_profile_header.dart';
import '../widgets/instructor_info_section.dart';
import '../widgets/assigned_classes_section.dart';
import '../widgets/notification_prefs_section.dart';
import '../widgets/security_settings_section.dart';

class InstructorAccountScreen extends StatefulWidget {
  const InstructorAccountScreen({super.key});

  @override
  State<InstructorAccountScreen> createState() =>
      _InstructorAccountScreenState();
}

class _InstructorAccountScreenState extends State<InstructorAccountScreen> {
  late InstructorAccountModel _account;

  @override
  void initState() {
    super.initState();
    // Copy so edits don't mutate the global sample directly
    _account = sampleInstructorAccount;
  }

  void _onEdit(String field, String value) {
    setState(() {
      switch (field) {
        case 'Full Name':
          _account = InstructorAccountModel(
            name: value,
            role: _account.role,
            mobileNumber: _account.mobileNumber,
            email: _account.email,
            branch: _account.branch,
            assignedClasses: _account.assignedClasses,
            notificationPrefs: _account.notificationPrefs,
          );
          break;
        case 'Mobile Number':
          _account = InstructorAccountModel(
            name: _account.name,
            role: _account.role,
            mobileNumber: value,
            email: _account.email,
            branch: _account.branch,
            assignedClasses: _account.assignedClasses,
            notificationPrefs: _account.notificationPrefs,
          );
          break;
        case 'Email Address':
          _account = InstructorAccountModel(
            name: _account.name,
            role: _account.role,
            mobileNumber: _account.mobileNumber,
            email: value,
            branch: _account.branch,
            assignedClasses: _account.assignedClasses,
            notificationPrefs: _account.notificationPrefs,
          );
          break;
      }
    });
  }

  void _confirmLogOut() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: clear session and navigate to login
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out.'),
                  backgroundColor: Color(0xFF1C1C1E),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // ── Dark collapsible app bar ───────────────────────────
          SliverAppBar(
            backgroundColor: const Color(0xFF0A0A0A),
            expandedHeight: 200,
            pinned: true,
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Account Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF0A0A0A),
                child: AccountProfileHeader(account: _account),
              ),
            ),
          ),

          // ── Scrollable content ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instructor Information
                  InstructorInfoSection(
                    fullName: _account.name,
                    mobileNumber: _account.mobileNumber,
                    email: _account.email,
                    branch: _account.branch,
                    onEdit: _onEdit,
                  ),
                  const SizedBox(height: 20),

                  // Assigned Classes
                  AssignedClassesSection(classes: _account.assignedClasses),
                  const SizedBox(height: 20),

                  // Notification Preferences
                  NotificationPrefsSection(prefs: _account.notificationPrefs),
                  const SizedBox(height: 20),

                  // Security Settings
                  const SecuritySettingsSection(),
                  const SizedBox(height: 24),

                  // Log Out Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmLogOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C1C1E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
