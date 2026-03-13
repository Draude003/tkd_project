import 'package:flutter/material.dart';
import '../../../../../models/competition_tracking_model.dart';

class CompetitionCardWidget extends StatelessWidget {
  final CompetitionModel competition;
  final VoidCallback? onTap;

  const CompetitionCardWidget({
    super.key,
    required this.competition,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    competition.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: Color(0xFFAAAAAA),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(competition.eventDate),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.person_outline,
                        size: 12,
                        color: Color(0xFFAAAAAA),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${competition.participants.length} students',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildStatusBadge(competition.status),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(CompetitionStatus status) {
    Color bg;
    switch (status) {
      case CompetitionStatus.upcoming:
        bg = const Color(0xFF3B82F6);
        break;
      case CompetitionStatus.ongoing:
        bg = const Color(0xFF22C55E);
        break;
      case CompetitionStatus.completed:
        bg = const Color(0xFFF59E0B);
        break;
      case CompetitionStatus.cancelled:
        bg = const Color(0xFFEF4444);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${m[date.month - 1]} ${date.day}, ${date.year}';
  }
}
