import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'section_card.dart';

class RecentAlertsCard extends StatelessWidget {
  final List<String> alerts;

  const RecentAlertsCard({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      label: 'Recent Alerts',
      child: Column(
        children: List.generate(alerts.length, (i) {
          return Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
            child: _AlertItem(text: alerts[i]),
          );
        }),
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final String text;

  const _AlertItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(fontSize: 16, color: Colors.black87)),
        Expanded(child: Text(text, style: AppTheme.bodyMedium)),
      ],
    );
  }
}
