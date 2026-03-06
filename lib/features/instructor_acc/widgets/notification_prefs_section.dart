import 'package:flutter/material.dart';
import '../../../models/instructor_account_model.dart';

class NotificationPrefsSection extends StatefulWidget {
  final NotificationPrefsModel prefs;

  const NotificationPrefsSection({super.key, required this.prefs});

  @override
  State<NotificationPrefsSection> createState() =>
      _NotificationPrefsSectionState();
}

class _NotificationPrefsSectionState extends State<NotificationPrefsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Container(width: 4, height: 16, color: const Color(0xFF1C1C1E)),
              const SizedBox(width: 8),
              const Text(
                'Notification Preferences',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Column(
            children: [
              _ToggleRow(
                label: 'Billing reminders',
                value: widget.prefs.billingReminders,
                onChanged: (v) => setState(() {
                  widget.prefs.billingReminders = v;
                  _showToast(context, 'Billing reminders ${v ? 'on' : 'off'}');
                }),
              ),
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Color(0xFFF0F0F0),
              ),
              _ToggleRow(
                label: 'Attendance alerts',
                value: widget.prefs.attendanceAlerts,
                onChanged: (v) => setState(() {
                  widget.prefs.attendanceAlerts = v;
                  _showToast(context, 'Attendance alerts ${v ? 'on' : 'off'}');
                }),
              ),
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Color(0xFFF0F0F0),
              ),
              _ToggleRow(
                label: 'Belt exam notices',
                value: widget.prefs.beltExamNotices,
                onChanged: (v) => setState(() {
                  widget.prefs.beltExamNotices = v;
                  _showToast(context, 'Belt exam notices ${v ? 'on' : 'off'}');
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF1C1C1E),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1C1C1E),
          ),
        ],
      ),
    );
  }
}
