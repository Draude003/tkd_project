import 'package:flutter/material.dart';
import '../screens/quick_attendance_screen.dart';
import '../screens/quick_billing_screen.dart';
import '../screens/quick_certificate_screen.dart';
import '../screens/quick_competition_screen.dart';
import 'section_card.dart';

class StudentQuickAction {
  final String icon; 
  final String label;
  final VoidCallback? onTap;

  const StudentQuickAction({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class StudentQuickActionsCard extends StatelessWidget {
  const StudentQuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<StudentQuickAction> actions = [
      StudentQuickAction(
        icon: 'assets/icons/attendance.png',
        label: 'Attendance',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AttendanceScreen()),
        ),
      ),
      StudentQuickAction(
        icon: 'assets/icons/billing.png',
        label: 'Billing',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BillingScreen()),
        ),
      ),
      StudentQuickAction(
        icon: 'assets/icons/certificates.png', 
        label: 'Certificates',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CertificateScreen()),
        ),
      ),
      StudentQuickAction(
        icon: 'assets/icons/competition.png',
        label: 'Competitions',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompetitionScreen()),
        ),
      ),
    ];

    return SectionCard(
      label: '⚡ Quick Actions',
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: actions.map((action) => _ActionTile(action: action)).toList(),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final StudentQuickAction action;
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
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 240, 239, 239),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                action.icon,
                color: const Color.fromARGB(255, 20, 20, 20),
                width: 36,
                height: 36,
              ),
              const SizedBox(height: 10),
              Text(
                action.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}