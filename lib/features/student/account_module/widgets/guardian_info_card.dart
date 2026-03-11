import 'package:flutter/material.dart';

class GuardianInfoCard extends StatelessWidget {
  const GuardianInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _sectionCard(
      label: 'Guardian Information',
      child: Column(
        children: [
          _infoRow(label: 'Full Name', value: 'Peter Caber', isLast: false),
          _infoRow(label: 'Mobile Number', value: '+63 917 123 4567', isLast: false),
          _infoRow(label: 'Email Address', value: 'peter@email.com', isLast: true),
        ],
      ),
    );
  }

  Widget _infoRow({required String label, required String value, required bool isLast}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                child: Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}

Widget _sectionCard({required String label, required Widget child}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(width: 4, height: 18, color: const Color(0xFF1C1C1E)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        width: double.infinity,
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
        child: child,
      ),
    ],
  );
}