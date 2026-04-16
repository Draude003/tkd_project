import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
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
    return SectionCard(
      label: 'STATUS TODAY',
      child: Row(
        children: [
          _CheckInIcon(),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Checked In',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (checkInTime.isNotEmpty)
                    Text(checkInTime, style: AppTheme.bodySmall),
                  if (loginType.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    _LoginTypeBadge(loginType: loginType),
                  ],
                ],
              ),
            ],
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isFaceScan
            ? Colors.green.withOpacity(0.15)
            : Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFaceScan ? Colors.green : Colors.orange,
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
            size: 12,
            color: isFaceScan ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isFaceScan ? 'Face Scan' : 'Manual',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isFaceScan ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckInIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.accentBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.check_rounded, color: Colors.white, size: 26),
    );
  }
}