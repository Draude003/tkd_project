import 'package:flutter/material.dart';

class AlertStatCard extends StatelessWidget {
  final String value;
  final String label;

  const AlertStatCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(
            0xFFF5F5F5,
          ), // ← light grey para visible sa white bg
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0), // ← black na
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Color.fromARGB(137, 0, 0, 0), // ← black na
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
