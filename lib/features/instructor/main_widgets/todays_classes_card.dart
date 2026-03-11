import 'package:flutter/material.dart';
import '../../../models/instructor_model.dart';

class TodaysClassesCard extends StatelessWidget {
  final List<InstructorClass> classes;
  const TodaysClassesCard({super.key, required this.classes});

  Color _getBgColor(String colorName) {
    switch (colorName) {
      case 'orange': return const Color(0xFFE8682A);
      case 'teal':   return const Color(0xFF2A7A6F);
      case 'red':    return const Color(0xFFB91C1C);
      default:       return const Color(0xFF1C1C1E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 18, color: const Color(0xFF1C1C1E)),
            const SizedBox(width: 8),
            const Text('Today\'s Classes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: classes.map((c) => _ClassTile(
              instructorClass: c,
              bgColor: _getBgColor(c.bgColor),
            )).toList(),
          ),
        ),
      ],
    );
  }
}

class _ClassTile extends StatelessWidget {
  final InstructorClass instructorClass;
  final Color bgColor;

  const _ClassTile({required this.instructorClass, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Time
          SizedBox(
            width: 52,
            child: Text(
              instructorClass.time,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(width: 1, height: 36, color: Colors.white24),
          const SizedBox(width: 12),
          // Title + Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                instructorClass.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                instructorClass.description,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}