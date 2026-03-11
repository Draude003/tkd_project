import 'package:flutter/material.dart';
import '../../../../models/instructor_account_model.dart';

class AccountProfileHeader extends StatelessWidget {
  final InstructorAccountModel account;

  const AccountProfileHeader({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 83), // ← increased para hindi masagi ang title
        // Avatar
        Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF3A3A3C), width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white54,
                  size: 40,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E88E5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Name
        Text(
          account.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),

        // Role badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1E88E5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            account.role,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
