import 'package:flutter/material.dart';
import '../../../models/class_attendance_model.dart';

class StudentAttendanceList extends StatelessWidget {
  final List<StudentAttendance> students;
  final int selectedCount;
  final Function(String id, bool selected) onToggleSelect;

  const StudentAttendanceList({
    super.key,
    required this.students,
    required this.selectedCount,
    required this.onToggleSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Student List',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (selectedCount > 0)
              Text(
                '$selectedCount Selected',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...students.map((s) => _StudentTile(
          student: s,
          onToggle: (val) => onToggleSelect(s.id, val),
        )),
      ],
    );
  }
}

class _StudentTile extends StatelessWidget {
  final StudentAttendance student;
  final ValueChanged<bool> onToggle;
  const _StudentTile({required this.student, required this.onToggle});

  Widget _statusWidget(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Color(0xFF22C55E), size: 16),
            SizedBox(width: 4),
            Text('Present', style: TextStyle(color: Color(0xFF22C55E), fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        );
      case AttendanceStatus.late:
        return Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFFF59E0B), size: 16),
            const SizedBox(width: 4),
            Text('Late', style: TextStyle(color: Colors.orange[700], fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        );
      case AttendanceStatus.absent:
        return const Row(
          children: [
            Icon(Icons.cancel_outlined, color: Color(0xFFEF4444), size: 16),
            SizedBox(width: 4),
            Text('Absent', style: TextStyle(color: Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        );
      default:
        return Text('Not Marked', style: TextStyle(color: Colors.grey[400], fontSize: 12));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: student.isSelected
            ? Border.all(color: const Color(0xFF1C1C1E), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => onToggle(!student.isSelected),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: student.isSelected ? const Color(0xFF1C1C1E) : Colors.transparent,
                border: Border.all(
                  color: student.isSelected ? const Color(0xFF1C1C1E) : Colors.grey.shade400,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: student.isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset('assets/icons/profile.png', width: 28, height: 28),
            ),
          ),
          const SizedBox(width: 12),
          // Name + Belt
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: student.beltColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        student.beltLevel,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      student.checkInMethod,
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status
          _statusWidget(student.status),
        ],
      ),
    );
  }
}