import 'package:flutter/material.dart';

class ParentRecentAlerts extends StatelessWidget {
  final List<String> alerts;
  const ParentRecentAlerts({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Notifications',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1E)),
          ),
          const SizedBox(height: 12),
          ...alerts.map((alert) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    alert,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}