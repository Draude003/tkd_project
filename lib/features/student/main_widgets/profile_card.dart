import 'package:flutter/material.dart';
import 'package:tkd/features/student/studprofile_module/screens/student_profile_screen.dart';
import '../../../models/student_model.dart';
import '../../../theme/app_theme.dart';

class ProfileCard extends StatelessWidget {
  final Student student;

  const ProfileCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentProfileScreen(student: student),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 26, 26, 26),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _Avatar(),
            const SizedBox(width: 14),
            _StudentInfo(student: student),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Center(
        child: Image.asset(
          'assets/icons/profile.png',
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}

class _StudentInfo extends StatelessWidget {
  final Student student;

  const _StudentInfo({required this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          student.name,
          style: const TextStyle(
            color: AppTheme.textOnDark,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        _BeltBadge(label: student.beltLevel),
        const SizedBox(height: 8),
        _InfoRow(label: 'Instructor:', value: student.instructor),
        _InfoRow(label: 'Next Class:', value: student.nextClass),
      ],
    );
  }
}

class _BeltBadge extends StatelessWidget {
  final String label;

  const _BeltBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textOnDark,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: AppTheme.textOnDark),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(color: AppTheme.textOnDarkMuted),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
