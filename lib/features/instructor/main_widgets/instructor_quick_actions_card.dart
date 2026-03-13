import 'package:flutter/material.dart';
import 'package:tkd/features/instructor/main_screens/quick_start_class_screen.dart';
import '../../../models/instructor_model.dart';
import 'package:tkd/features/instructor/classes_module/screens/class_attendance_screen.dart';
import '../competition_module/screens/compitition_tracking_screen.dart';
import '../belt_promotion/screens/belt_promotion_screen.dart';

class _QuickAction {
  final IconData icon;
  final String label;
  final void Function(BuildContext) onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});
}

class InstructorQuickActionsCard extends StatelessWidget {
  const InstructorQuickActionsCard({super.key});

  void _showClassSelector(BuildContext context) {
    final instructor = sampleInstructor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.play_circle_outline_rounded, size: 20),
                SizedBox(width: 8),
                Text(
                  'Select Class to Start',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Divider(height: 1, color: Colors.grey.shade200),

          // Class List
          ...instructor.todaysClasses.map((c) {
            return Column(
              children: [
                Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuickStartClassScreen(
                            instructorClass: c
                            ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          // Time badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              c.time,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Class info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1C1C1E),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  c.description,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(height: 1, indent: 16, color: Colors.grey.shade100),
              ],
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<_QuickAction> actions = [
      _QuickAction(
        icon: Icons.play_circle_outline_rounded,
        label: 'Start Class',
        onTap: _showClassSelector,
      ),
      _QuickAction(
        icon: Icons.people_alt_outlined,
        label: 'Take Attendance',
        onTap: (ctx) => Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => const ClassAttendanceScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.track_changes,
        label: 'Competition Tracking',
        onTap: (ctx) => Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => const CompetitionTrackingScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.flag_outlined,
        label: 'Belt Promotion',
        onTap: (ctx) => Navigator.push(
          ctx,
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
        onTap: () => action.onTap(context),
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
