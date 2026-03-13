// widgets/promotion_stats_widget.dart

import 'package:flutter/material.dart';

class PromotionStatsWidget extends StatelessWidget {
  final int totalCandidates;
  final int readyCount;
  final int needsWorkCount;

  const PromotionStatsWidget({
    super.key,
    required this.totalCandidates,
    required this.readyCount,
    required this.needsWorkCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          label: 'Total',
          value: '$totalCandidates',
          color: const Color(0xFF1A1A2E),
          icon: Icons.people_rounded,
        ),
        const SizedBox(width: 10),
        _StatCard(
          label: 'Ready',
          value: '$readyCount',
          color: const Color(0xFF1A1A2E),
          icon: Icons.check_circle_rounded,
        ),
        const SizedBox(width: 10),
        _StatCard(
          label: 'Needs Work',
          value: '$needsWorkCount',
          color: const Color(0xFF1A1A2E),
          icon: Icons.warning_rounded,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
