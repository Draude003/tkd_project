import 'package:flutter/material.dart';
import '../../../models/class_attendance_model.dart';

class ClassStatsRow extends StatelessWidget {
  final List<StudentAttendance> students;
  const ClassStatsRow({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    final total = students.length;
    final present = students.where((s) => s.status == AttendanceStatus.present).length;
    final late = students.where((s) => s.status == AttendanceStatus.late).length;
    final absent = students.where((s) => s.status == AttendanceStatus.absent).length;

    return Row(
      children: [
        Expanded(child: _StatBox(count: total, label: 'Total', color: const Color(0xFF1C1C1E))),
        const SizedBox(width: 10),
        Expanded(child: _StatBox(count: present, label: 'Present', color: const Color(0xFF22C55E))),
        const SizedBox(width: 10),
        Expanded(child: _StatBox(count: late, label: 'Late', color: const Color(0xFFF59E0B))),
        const SizedBox(width: 10),
        Expanded(child: _StatBox(count: absent, label: 'Absent', color: const Color(0xFFEF4444))),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _StatBox({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}