import 'package:flutter/material.dart';
import '../../../../models/class_attendance_model.dart';
import '../widgets/class_header_card.dart';
import '../widgets/class_stats_row.dart';
import '../widgets/student_attendance_list.dart';

class ClassAttendanceScreen extends StatefulWidget {
  const ClassAttendanceScreen({super.key});

  @override
  State<ClassAttendanceScreen> createState() => _ClassAttendanceScreenState();
}

class _ClassAttendanceScreenState extends State<ClassAttendanceScreen> {
  late List<StudentAttendance> _students;
  late ClassSession _session;

  @override
  void initState() {
    super.initState();
    _session = sampleClassSession;
    _students = List.from(_session.students);
  }

  int get _selectedCount => _students.where((s) => s.isSelected).length;

  void _toggleSelect(String id, bool selected) {
    setState(() {
      final student = _students.firstWhere((s) => s.id == id);
      student.isSelected = selected;
    });
  }

  void _markSelected(AttendanceStatus status) {
    setState(() {
      for (final s in _students.where((s) => s.isSelected)) {
        s.status = status;
        s.isSelected = false;
      }
    });
  }

  void _showClassNotesDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Class Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write notes for this class...',
                filled: true,
                fillColor: const Color(0xFFF2F2F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C1C1E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('SAVE NOTES', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: _selectedCount > 0 ? onTap : null,
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1C1C1E),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClassHeaderCard(session: _session),
                  const SizedBox(height: 16),
                  ClassStatsRow(students: _students),
                  const SizedBox(height: 20),
                  StudentAttendanceList(
                    students: _students,
                    selectedCount: _selectedCount,
                    onToggleSelect: _toggleSelect,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _actionButton(
                      icon: Icons.check_circle_outline,
                      label: 'Mark Present',
                      onTap: () => _markSelected(AttendanceStatus.present),
                    ),
                    const SizedBox(width: 10),
                    _actionButton(
                      icon: Icons.access_time,
                      label: 'Mark Late',
                      onTap: () => _markSelected(AttendanceStatus.late),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _actionButton(
                      icon: Icons.person_off_outlined,
                      label: 'Excuse',
                      onTap: () => _markSelected(AttendanceStatus.excused),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showClassNotesDialog,
                        icon: const Icon(Icons.note_alt_outlined, size: 16),
                        label: const Text('Class Notes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C1C1E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
  }
}