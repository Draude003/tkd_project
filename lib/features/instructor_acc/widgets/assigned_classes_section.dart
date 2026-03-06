import 'package:flutter/material.dart';
import '../../../models/instructor_account_model.dart';

class AssignedClassesSection extends StatelessWidget {
  final List<AssignedClassModel> classes;

  const AssignedClassesSection({super.key, required this.classes});

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
                'Assigned Classes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
        ),
        ...classes.map((c) => _ClassCard(assignedClass: c)),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  final AssignedClassModel assignedClass;
  const _ClassCard({required this.assignedClass});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          // Emoji icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                assignedClass.emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name + schedule
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignedClass.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      assignedClass.schedule,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    const Text(
                      ' • ',
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                    Text(
                      assignedClass.status,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF43A047),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
