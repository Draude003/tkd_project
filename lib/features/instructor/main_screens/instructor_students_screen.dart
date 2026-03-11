import 'package:flutter/material.dart';
import '../../../../models/student_evaluation_model.dart';
import '../main_widgets/student_search_bar.dart';
import '../main_widgets/class_filter_chips.dart';
import '../main_widgets/student_list_tile.dart';
import 'student_evaluation_screen.dart';

class InstructorStudentsScreen extends StatefulWidget {
  const InstructorStudentsScreen({super.key});

  @override
  State<InstructorStudentsScreen> createState() => _InstructorStudentsScreenState();
}

class _InstructorStudentsScreenState extends State<InstructorStudentsScreen> {
  String _search = '';
  String _selectedFilter = 'All Classes';

  List<InstructorStudent> get _filtered {
    return sampleInstructorStudents.where((s) {
      final matchSearch = s.name.toLowerCase().contains(_search.toLowerCase());
      final matchFilter = _selectedFilter == 'All Classes' || s.className == _selectedFilter;
      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search + Filter
        Container(
          color: const Color(0xFFF2F2F7),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            children: [
              StudentSearchBar(onChanged: (val) => setState(() => _search = val)),
              const SizedBox(height: 12),
              ClassFilterChips(
                selected: _selectedFilter,
                filters: classFilters,
                onSelected: (val) => setState(() => _selectedFilter = val),
              ),
            ],
          ),
        ),

        // Student List
        Expanded(
          child: _filtered.isEmpty
              ? const Center(child: Text('No students found.', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final student = _filtered[index];
                    return StudentListTile(
                      student: student,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentEvaluationScreen(student: student),
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