import 'package:flutter/material.dart';

class NotificationPreferencesCard extends StatefulWidget {
  const NotificationPreferencesCard({super.key});

  @override
  State<NotificationPreferencesCard> createState() => _NotificationPreferencesCardState();
}

class _NotificationPreferencesCardState extends State<NotificationPreferencesCard> {
  final List<Map<String, dynamic>> _prefs = [
    {'label': 'Billing reminders', 'value': true},
    {'label': 'Attendance alerts', 'value': true},
    {'label': 'Belt exam notices', 'value': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 18, color: const Color(0xFF1C1C1E)),
            const SizedBox(width: 8),
            const Text('Notification Preferences', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(_prefs.length, (index) {
              final isLast = index == _prefs.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _prefs[index]['label'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Switch(
                          value: _prefs[index]['value'],
                          onChanged: (val) => setState(() => _prefs[index]['value'] = val),
                          activeColor: const Color(0xFF1C1C1E),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(height: 1, indent: 16, color: Colors.grey.shade200),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}