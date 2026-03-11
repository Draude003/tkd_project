import 'package:flutter/material.dart';
import '../../../models/student_model.dart';
import '../../../theme/app_theme.dart';
import 'section_card.dart';

class ThisMonthCard extends StatelessWidget {
  final Student student;

  const ThisMonthCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      label: '🗓 This Month',
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: student.classAttendanceSummary,
              label: 'Class Attended',
            ),
          ),
          Container(width: 1, height: 48, color: Colors.grey.shade200),
          Expanded(
            child: _StatItem(
              value: student.progressScoreLabel,
              label: 'Progress Score',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTheme.statValue),
        const SizedBox(height: 4),
        Text(label, style: AppTheme.statLabel),
      ],
    );
  }
}
