import 'package:flutter/material.dart';
import 'package:tkd/features/parent/main_screens/quick_parent_competition_screen.dart';
import 'package:tkd/features/student/main_screens/quick_attendance_screen.dart';
import 'package:tkd/features/student/main_screens/quick_certificate_screen.dart';
import 'package:tkd/features/student/main_screens/quick_billing_screen.dart';

class ParentQuickAction {
  final String icon;
  final String label;
  final VoidCallback? onTap;

  const ParentQuickAction({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class ParentQuickActionsCard extends StatelessWidget {
  const ParentQuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
      final List<ParentQuickAction> actions = [
      ParentQuickAction(
        icon: 'assets/icons/attendance.png',
        label: 'Attendance',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AttendanceScreen()),
        ),
      ),
      ParentQuickAction(
        icon: 'assets/icons/billing.png',
        label: 'Billing',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BillingScreen()),
        ),
       
      ),
      ParentQuickAction(
        icon: 'assets/icons/certificates.png', 
        label: 'Certificates',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CertificateScreen()),
        ),
        
      ),
      ParentQuickAction(
        icon: 'assets/icons/competition.png',
        label: 'Competitions ',
         onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ParentCompetitionScreen()),
        ),
       
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Row(
          children: [
            Container(width: 4, height: 18, color: const Color(0xFF1C1C1E)),
            SizedBox(width: 8),
            Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: actions.map((action) => _ActionTile(action: action)).toList(),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final ParentQuickAction action;
  const _ActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.grey.shade200,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(action.icon, width: 32, height: 32),
              const SizedBox(height: 8),
              Text(
                action.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}