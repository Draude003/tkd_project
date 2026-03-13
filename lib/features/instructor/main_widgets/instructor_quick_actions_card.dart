import 'package:flutter/material.dart';
import '../competition_module/screens/compitition_tracking_screen.dart';
import '../belt_promotion/screens/belt_promotion_screen.dart';

class _QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickAction({required this.icon, required this.label, this.onTap});
}

class InstructorQuickActionsCard extends StatelessWidget {
  const InstructorQuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_QuickAction> actions = [
      _QuickAction(
        icon: Icons.play_circle_outline_rounded,
        label: 'Start Class',
      ),
      _QuickAction(icon: Icons.people_alt_outlined, label: 'Take Attendance'),

      _QuickAction(
        icon: Icons.track_changes,
        label: 'Competition Tracking',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompetitionTrackingScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.flag_outlined,
        label: 'Belt Promotion',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BeltPromotionScreen()),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 18, color: const Color(0xFF1C1C1E)),
            const SizedBox(width: 8),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
          children: actions.map((a) => _ActionTile(action: a)).toList(),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final _QuickAction action;
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
              Icon(action.icon, size: 32, color: const Color(0xFF1C1C1E)),
              const SizedBox(height: 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
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
