import 'package:flutter/material.dart';
import 'section_card.dart';

class StatusTodayCard extends StatelessWidget {
  final String checkInTime;
  final String loginType;

  const StatusTodayCard({
    super.key,
    required this.checkInTime,
    this.loginType = '',
  });

  @override
  Widget build(BuildContext context) {
    final isFaceScan = loginType == 'face_scan';
    final isCheckedIn = checkInTime.isNotEmpty;

    return SectionCard(
      label: 'STATUS TODAY',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCheckedIn
                ? [const Color(0xFF0F2027), const Color(0xFF1C3A2E)]
                : [const Color(0xFF1C1C1E), const Color(0xFF2C2C2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isCheckedIn
                  ? const Color(0xFF22C55E).withOpacity(0.15)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Status Icon ──
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isCheckedIn
                    ? const Color(0xFF22C55E).withOpacity(0.15)
                    : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCheckedIn
                      ? const Color(0xFF22C55E).withOpacity(0.4)
                      : Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                isCheckedIn
                    ? Icons.check_circle_rounded
                    : Icons.check_circle_outline_rounded,
                color: isCheckedIn
                    ? const Color(0xFF22C55E)
                    : Colors.white38,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            // ── Status Info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Checked In',
                        style: TextStyle(
                          color: isCheckedIn
                              ? Colors.white
                              : Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (isCheckedIn) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (isCheckedIn) ...[
                        Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: Colors.white38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          checkInTime,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      if (loginType.isNotEmpty)
                        _LoginTypeBadge(loginType: loginType),
                    ],
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

class _LoginTypeBadge extends StatelessWidget {
  final String loginType;

  const _LoginTypeBadge({required this.loginType});

  @override
  Widget build(BuildContext context) {
    final isFaceScan = loginType == 'face_scan';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isFaceScan
            ? const Color(0xFF3B82F6).withOpacity(0.15)
            : Colors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFaceScan
              ? const Color(0xFF3B82F6).withOpacity(0.4)
              : Colors.amber.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFaceScan
                ? Icons.face_retouching_natural
                : Icons.keyboard_alt_outlined,
            size: 11,
            color: isFaceScan ? const Color(0xFF3B82F6) : Colors.amber,
          ),
          const SizedBox(width: 4),
          Text(
            isFaceScan ? 'Face Scan' : 'Manual',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isFaceScan ? const Color(0xFF3B82F6) : Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}