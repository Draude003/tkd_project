import 'package:flutter/material.dart';
import 'package:tkd/features/instructor/main_screens/quick_start_class_screen.dart';
import '../../../models/instructor_model.dart';
import '../competition_module/screens/compitition_tracking_screen.dart';
import '../belt_promotion/screens/belt_promotion_screen.dart';

class _QuickAction {
  final IconData icon;
  final String label;
  final void Function(BuildContext) onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});
}

class InstructorQuickActionsCard extends StatefulWidget {
  final List<InstructorClass> classes;
  const InstructorQuickActionsCard({super.key, required this.classes});

  @override
  State<InstructorQuickActionsCard> createState() => _InstructorQuickActionsCardState();
}

class _InstructorQuickActionsCardState extends State<InstructorQuickActionsCard> {
  InstructorClass? _activeClass;

  String _classStatus(String timeRange) {
    final now = TimeOfDay.now();
    final parts = timeRange.split('\u2013');
    if (parts.length < 2) return 'upcoming';
    final startParts = parts[0].trim().split(':');
    final endParts = parts[1].trim().split(':');
    if (startParts.length < 2 || endParts.length < 2) return 'upcoming';
    final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
    final nowMinutes = now.hour * 60 + now.minute;
    if (nowMinutes < startMinutes) return 'upcoming';
    if (nowMinutes > endMinutes) return 'done';
    return 'now';
  }

  String _formatTime(String raw) {
    try {
      final parts = raw.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '$hour:${minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return raw;
    }
  }

  void _showClassSelector(BuildContext context, {int initialTab = 0}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.play_circle_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Class to Start',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C1C1E),
                        ),
                      ),
                      Text(
                        'Tap a class to begin session',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...widget.classes.asMap().entries.map((entry) {
              final c = entry.value;
              final colors = [
                const Color(0xFF2C7873),
                const Color(0xFFD4773A),
                const Color(0xFF8B3A3A),
                const Color(0xFF3A5F8B),
              ];
              final color = colors[entry.key % colors.length];
              final status = _classStatus(c.time);

              Color badgeColor;
              String badgeText;
              IconData badgeIcon;
              switch (status) {
                case 'now':
                  badgeColor = const Color(0xFF22C55E);
                  badgeText = 'Now';
                  badgeIcon = Icons.circle;
                  break;
                case 'done':
                  badgeColor = Colors.grey;
                  badgeText = 'Done';
                  badgeIcon = Icons.check_circle_outline;
                  break;
                default:
                  badgeColor = const Color(0xFF3B82F6);
                  badgeText = 'Upcoming';
                  badgeIcon = Icons.schedule;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      setState(() => _activeClass = c);
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuickStartClassScreen(
                            instructorClass: c,
                            initialTab: initialTab,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: color.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: status == 'done'
                                    ? Colors.grey.shade400
                                    : color,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(13),
                                  bottomLeft: Radius.circular(13),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: () {
                                  final parts = c.time.split('\u2013');
                                  final start = _formatTime(parts[0].trim());
                                  final end = parts.length > 1
                                      ? _formatTime(parts[1].trim())
                                      : '';
                                  return [
                                    Text(
                                      start,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Container(
                                        height: 1,
                                        width: 24,
                                        color: Colors.white30),
                                    const SizedBox(height: 3),
                                    Text(
                                      end,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ];
                                }(),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      c.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: status == 'done'
                                            ? Colors.grey
                                            : const Color(0xFF1C1C1E),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        c.description,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: status == 'done'
                                              ? Colors.grey
                                              : color,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(badgeIcon,
                                            size: 10, color: badgeColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          badgeText,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: badgeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
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
        onTap: (ctx) => _activeClass != null
            ? Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => QuickStartClassScreen(
                    instructorClass: _activeClass!,
                    initialTab: 1,
                  ),
                ),
              )
            : _showClassSelector(ctx, initialTab: 1),
      ),
<<<<<<< HEAD
      _QuickAction(icon: Icons.people_alt_outlined, label: 'Take Attendance'),

=======
>>>>>>> 9213d41a22bad7bd84ec5dc79c49dc5921bbdc0f
      _QuickAction(
        icon: Icons.track_changes,
        label: 'Competition Tracking',
        onTap: (ctx) => Navigator.push(
          ctx,
          MaterialPageRoute(
              builder: (_) => const CompetitionTrackingScreen()),
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