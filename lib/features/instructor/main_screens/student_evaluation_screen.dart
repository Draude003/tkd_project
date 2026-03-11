import 'package:flutter/material.dart';
import '../../../../models/student_evaluation_model.dart';
import '../main_widgets/evaluation_header_card.dart';
import '../main_widgets/skills_checklist_card.dart';
import '../main_widgets/performance_scores_card.dart';
import '../main_widgets/instructor_notes_card.dart';

class StudentEvaluationScreen extends StatefulWidget {
  final InstructorStudent student;
  const StudentEvaluationScreen({super.key, required this.student});

  @override
  State<StudentEvaluationScreen> createState() => _StudentEvaluationScreenState();
}

class _StudentEvaluationScreenState extends State<StudentEvaluationScreen> {
  final TextEditingController _notesController = TextEditingController();

  // Belt readiness — average ng scores
  double get _beltReadiness {
    final total = widget.student.scores.fold(0.0, (sum, s) => sum + s.score);
    return total / widget.student.scores.length;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final readiness = _beltReadiness;
    final isReady = readiness >= 0.75;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Student Evaluation', 
          style: TextStyle(
          color: Colors.white, 
          fontSize: 16, 
          fontWeight: 
          FontWeight.w500
          ),
          ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  EvaluationHeaderCard(student: widget.student),
                  const SizedBox(height: 20),

                  // Skills Checklist
                  SkillsChecklistCard(skills: widget.student.skills),
                  const SizedBox(height: 20),

                  // Performance Scores
                  PerformanceScoresCard(scores: widget.student.scores),
                  const SizedBox(height: 20),

                  // Instructor Notes
                  InstructorNotesCard(controller: _notesController),
                  const SizedBox(height: 20),

                  // Belt Readiness
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isReady
                          ? const Color(0xFF22C55E).withOpacity(0.1)
                          : const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isReady
                            ? const Color(0xFF22C55E).withOpacity(0.3)
                            : const Color(0xFFF59E0B).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          isReady ? '🥋' : '⏳',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Belt Readiness: ${(readiness * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isReady ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isReady ? '✓ Ready for Exam' : '⏳ Needs More Training',
                              style: TextStyle(
                                fontSize: 12,
                                color: isReady ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Save Button
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Evaluation saved!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C1C1E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'SAVE EVALUATION',
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}