import 'package:flutter/material.dart';
import 'package:tkd/models/parent_model.dart';
import 'package:tkd/features/parent/main_widgets/guardian_info_card.dart';
import 'package:tkd/features/parent/main_widgets/child_card.dart';
import 'package:tkd/features/parent/childprofile_module/screens/child_profile_screen.dart';
import 'package:tkd/services/api_service.dart';
import 'package:tkd/features/login/screens/login_screen.dart';

class ParentAccountScreen extends StatefulWidget {
  const ParentAccountScreen({super.key});

  @override
  State<ParentAccountScreen> createState() => _ParentAccountScreenState();
}

class _ParentAccountScreenState extends State<ParentAccountScreen> {
  ParentUser? _parent;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await ApiService.getParentProfile();
    if (mounted) {
      setState(() {
        _parent = data != null ? ParentUser.fromJson(data) : null;
        _isLoading = false;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C1C1E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_parent == null) {
      return const Center(child: Text('Failed to load profile.'));
    }

    final parent = _parent!;

    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ── Guardian Information ──
            GuardianInfoCard(
              name: parent.name,
              email: parent.email,
              mobile: parent.mobile,
            ),

            const SizedBox(height: 24),

            // ── Linked Children ──
            _sectionHeader('Linked Children', '${parent.children.length} child${parent.children.length != 1 ? 'ren' : ''}'),
            const SizedBox(height: 12),

            if (parent.children.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.child_care, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No children linked', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            else
              ...parent.children.map(
                (child) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ChildCard(
                    child: child,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChildProfileScreen(childId: child.id),
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // ── Logout ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showLogoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C1C1E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Row(
      children: [
        Container(width: 4, height: 18, color: const Color(0xFF1C1C1E)),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const Spacer(),
        Text(subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      ],
    );
  }
}