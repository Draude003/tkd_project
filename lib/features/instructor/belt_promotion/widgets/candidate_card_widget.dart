// widgets/candidate_card_widget.dart

import 'package:flutter/material.dart';
import '/../models/belt_promotion_model.dart';

class CandidateCardWidget extends StatelessWidget {
  final BeltPromotionCandidate candidate;
  final ValueChanged<bool?> onCheckChanged;

  const CandidateCardWidget({
    super.key,
    required this.candidate,
    required this.onCheckChanged,
  });

  Color _statusColor(PromotionStatus status) {
    switch (status) {
      case PromotionStatus.ready:
        return const Color(0xFF2ECC71);
      case PromotionStatus.needsWork:
        return const Color(0xFFE74C3C);
      case PromotionStatus.pending:
        return const Color(0xFFF39C12);
    }
  }

  String _statusLabel(PromotionStatus status) {
    switch (status) {
      case PromotionStatus.ready:
        return 'Ready';
      case PromotionStatus.needsWork:
        return 'Needs Work';
      case PromotionStatus.pending:
        return 'Pending';
    }
  }

  IconData _statusIcon(PromotionStatus status) {
    switch (status) {
      case PromotionStatus.ready:
        return Icons.check_circle_rounded;
      case PromotionStatus.needsWork:
        return Icons.warning_rounded;
      case PromotionStatus.pending:
        return Icons.hourglass_empty_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(candidate.status);
    final beltColor = candidate.currentBelt.color;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: candidate.isSelected ? statusColor : Colors.grey.shade200,
          width: candidate.isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            // ── Checkbox ──────────────────────────────────────────
            SizedBox(
              width: 30,
              height: 30,
              child: Checkbox(
                value: candidate.isSelected,
                onChanged: onCheckChanged,
                activeColor: const Color.fromARGB(255, 0, 0, 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // ── Avatar with belt ring ─────────────────────────────
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: beltColor, width: 2.5),
              ),
              child: CircleAvatar(
                radius: 19,
                backgroundColor: const Color(0xFF1A1A2E),
                child: Text(
                  candidate.name.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // ── Name + belt + stats ───────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidate.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Belt chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: beltColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          candidate.currentBelt.label,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: beltColor == const Color(0xFFBDBDBD)
                                ? Colors.grey.shade700
                                : beltColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      _MiniStat(
                        icon: Icons.calendar_today_rounded,
                        value: '${candidate.attendanceCount}',
                        label: 'days',
                      ),
                      const SizedBox(width: 6),
                      _MiniStat(
                        icon: Icons.star_rounded,
                        value: candidate.skillScore.toStringAsFixed(1),
                        label: 'skill',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),

            // ── Status badge ──────────────────────────────────────
            Container(
              constraints: const BoxConstraints(maxWidth: 100),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _statusIcon(candidate.status),
                    color: statusColor,
                    size: 13,
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      _statusLabel(candidate.status),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: Colors.grey.shade500),
        const SizedBox(width: 2),
        Text(
          '$value $label',
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
