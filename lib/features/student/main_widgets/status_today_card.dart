import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'section_card.dart';

class StatusTodayCard extends StatelessWidget {
  final String checkInTime;

  const StatusTodayCard({super.key, required this.checkInTime});

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
              const SizedBox(height: 2),
              Text(checkInTime, style: AppTheme.bodySmall),
            ],
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
