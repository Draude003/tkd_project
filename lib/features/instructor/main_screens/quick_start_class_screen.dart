import 'package:flutter/material.dart';
import '../../../models/instructor_model.dart';
import '../../../models/class_attendance_model.dart';
import 'package:tkd/features/instructor/classes_module/widgets/student_attendance_list.dart';
import 'package:tkd/features/instructor/classes_module/widgets/class_header_card.dart';
import 'package:tkd/features/instructor/classes_module/widgets/class_stats_row.dart';
import 'package:tkd/features/instructor/classes_module/widgets/session_plan_tab.dart';
import 'package:tkd/services/api_service.dart';

class QuickStartClassScreen extends StatefulWidget {
  final InstructorClass instructorClass;
  final int initialTab;

  const QuickStartClassScreen({
    super.key,
    required this.instructorClass,
    this.initialTab = 0,
  });

  @override
  State<QuickStartClassScreen> createState() => _QuickStartClassScreenState();
}

class _QuickStartClassScreenState extends State<QuickStartClassScreen>
    with SingleTickerProviderStateMixin {
  late List<StudentAttendance> _students;
  late ClassSession _session;
  late TabController _tabController;
   bool _isLoadingStudents = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _session = ClassSession(
      className: widget.instructorClass.title,
      coachName: 'Coach Eduard',
      schedule: widget.instructorClass.time,
      isActive: true,
      students: [],
    );
    _students = [];
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final result = await ApiService.getClassStudents(widget.instructorClass.id);
    final rawStudents = result['students'] as List;

    final mapped = rawStudents.map((s) {
      return StudentAttendance(
        id: s['id'].toString(),
        name: s['name'] ?? 'Unknown',
        beltLevel: s['belt'] ?? 'No Belt',
        beltColor: _beltColor(s['belt'] ?? ''),
        checkInMethod: 'Manual',
      );
    }).toList();

    setState(() {
      _students = mapped;
      _session = ClassSession(
        className: widget.instructorClass.title,
        coachName: 'Coach',
        schedule: widget.instructorClass.time,
        isActive: true,
        students: _students,
      );
      _isLoadingStudents = false;
    });
  }

  Color _beltColor(String belt) {
    final b = belt.toLowerCase();
    if (b.contains('yellow')) return const Color(0xFFEAB308);
    if (b.contains('green')) return const Color(0xFF22C55E);
    if (b.contains('orange')) return const Color(0xFFF97316);
    if (b.contains('red')) return const Color(0xFFEF4444);
    if (b.contains('black')) return const Color(0xFF1C1C1E);
    if (b.contains('blue')) return const Color(0xFF3B82F6);
    return const Color(0xFF9E9E9E);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Class Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write notes for this class...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF2F2F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'SAVE NOTES',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
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
    required VoidCallback? onTap,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1C1C1E),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade200,
          disabledForegroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Class',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // TabBar — dito sa taas
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF1C1C1E),
              labelColor: const Color(0xFF1C1C1E),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              tabs: const [
                Tab(text: 'Session Plan'),
                Tab(text: 'Attendance'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1 — Session Plan
                SessionPlanTab(className: widget.instructorClass.title),

                // Tab 2 — Attendance
                Column(
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
                            _isLoadingStudents
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : StudentAttendanceList(
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
                                onTap: _selectedCount > 0
                                    ? () => _markSelected(
                                        AttendanceStatus.present,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              _actionButton(
                                icon: Icons.access_time,
                                label: 'Mark Late',
                                onTap: _selectedCount > 0
                                    ? () => _markSelected(AttendanceStatus.late)
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _actionButton(
                                icon: Icons.person_off_outlined,
                                label: 'Excuse',
                                onTap: _selectedCount > 0
                                    ? () => _markSelected(
                                        AttendanceStatus.excused,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _showClassNotesDialog,
                                  icon: const Icon(
                                    Icons.note_alt_outlined,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Class Notes',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1C1C1E),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
