import 'package:flutter/material.dart';
import '../../../../services/api_service.dart';
import 'instructor_student_progress_screen.dart';

class InstructorStudentsScreen extends StatefulWidget {
  const InstructorStudentsScreen({super.key});

  @override
  State<InstructorStudentsScreen> createState() =>
      _InstructorStudentsScreenState();
}

class _InstructorStudentsScreenState extends State<InstructorStudentsScreen> {
  List<dynamic> _students = [];
  List<dynamic> _filtered = [];
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final students = await ApiService.getEvaluationStudents();
    setState(() {
      _students = students;
      _filtered = students;
      _loading = false;
    });
  }

  void _applyFilter() {
    setState(() {
      _filtered = _students.where((s) {
        final name =
            '${s['first_name']} ${s['last_name']}'.toLowerCase();
        return name.contains(_search.toLowerCase());
      }).toList();
    });
  }

  Color _beltColor(String? hex) {
    if (hex == null) return Colors.grey;
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Container(
          color: const Color(0xFFF2F2F7),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (val) {
                _search = val;
                _applyFilter();
              },
              decoration: InputDecoration(
                hintText: 'Search student...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),

        // Student count
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            '${_filtered.length} student${_filtered.length != 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Student List
        Expanded(
          child: _filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_search,
                          size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        'No students found.',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final s = _filtered[index];
                    final beltColor = _beltColor(s['belt_color']);

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InstructorStudentProgressScreen(
                            studentId: s['id'] as int,
                            studentName:
                                '${s['first_name']} ${s['last_name']}',
                          ),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${s['first_name']} ${s['last_name']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1C1C1E),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: beltColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 0.5),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${s['belt_name']} Belt',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: Colors.grey.shade400),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}