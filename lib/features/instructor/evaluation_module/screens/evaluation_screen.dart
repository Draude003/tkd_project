import 'package:flutter/material.dart';
import '../../../../services/api_service.dart';

class EvaluationScreen extends StatefulWidget {
  final Map<String, dynamic> student;
  final List<dynamic> students;

  const EvaluationScreen({
    super.key,
    required this.student,
    required this.students,
  });

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  List<dynamic> _skills = [];
  Map<String, dynamic>? _selectedStudent;

  bool _loadingSkills = false;
  bool _saving = false;

  double _technique = 5;
  double _discipline = 5;
  double _fitness = 5;
  double _sparring = 5;

  bool _beltReady = false;
  final TextEditingController _notesController = TextEditingController();
  Map<int, bool> _skillResults = {};

  @override
  void initState() {
    super.initState();
    _initStudent(widget.student);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _initStudent(Map<String, dynamic> student) async {
    setState(() {
      _selectedStudent = student;
      _technique = 5;
      _discipline = 5;
      _fitness = 5;
      _sparring = 5;
      _beltReady = false;
      _notesController.clear();
      _skills = [];
      _skillResults = {};
      _loadingSkills = true;
    });

    // Run both calls in parallel
    final evalFuture = ApiService.getLatestEvaluation(student['id'] as int);
    final skillsFuture = ApiService.getSkillsByBelt(
      student['belt_name'] as String,
    );

    final existing = await evalFuture;
    final skills = await skillsFuture;

    if (existing != null) {
      setState(() {
        _technique = (existing['technique_score'] as num).toDouble();
        _discipline = (existing['discipline_score'] as num).toDouble();
        _fitness = (existing['fitness_score'] as num).toDouble();
        _sparring = (existing['sparring_score'] as num).toDouble();
        _beltReady = existing['belt_ready_flag'] == true;
        _notesController.text = existing['notes'] ?? '';
      });
    }

    final skillResults = <int, bool>{};
    for (var s in skills) {
      final skillId = s['id'] as int;
      if (existing != null) {
        final rawResults = existing['skill_results'];
        // Handle both List (empty) and Map cases
        if (rawResults is Map) {
          final existingSkill = rawResults[skillId.toString()];
          skillResults[skillId] =
              existingSkill != null && existingSkill['status'] == 'completed';
        } else {
          skillResults[skillId] = false;
        }
      } else {
        skillResults[skillId] = false;
      }
    }

    setState(() {
      _skills = skills;
      _skillResults = skillResults;
      _loadingSkills = false;
    });
  }

  Future<void> _loadSkills(
    String beltLevel, {
    Map<String, dynamic>? existingEval,
  }) async {
    setState(() {
      _loadingSkills = true;
      _skillResults = {};
    });
    final skills = await ApiService.getSkillsByBelt(beltLevel);
    setState(() {
      _skills = skills;
      for (var s in skills) {
        final skillId = s['id'] as int;
        if (existingEval != null && existingEval['skill_results'] != null) {
          final existing = existingEval['skill_results'][skillId.toString()];
          _skillResults[skillId] =
              existing != null && existing['status'] == 'completed';
        } else {
          _skillResults[skillId] = false;
        }
      }
      _loadingSkills = false;
    });
  }

  Future<void> _saveEvaluation() async {
    if (_selectedStudent == null) return;
    setState(() => _saving = true);

    final skillResults = _skillResults.entries
        .map((e) => {'skill_id': e.key, 'is_passed': e.value})
        .toList();

    final payload = {
      'student_id': _selectedStudent!['id'],
      'technique_score': _technique.round(),
      'discipline_score': _discipline.round(),
      'fitness_score': _fitness.round(),
      'sparring_score': _sparring.round(),
      'notes': _notesController.text.trim(),
      'belt_ready_flag': _beltReady,
      'skill_results': skillResults,
    };

    final success = await ApiService.saveEvaluation(payload);
    setState(() => _saving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Evaluation saved!' : 'Failed to save. Try again.',
        ),
        backgroundColor: success ? const Color(0xFF22C55E) : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
    final s = _selectedStudent!;
    final beltColor = _beltColor(s['beltcolor']);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Student Evaluation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: _loadingSkills
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStudentDropdown(),
                  const SizedBox(height: 12),
                  _buildSelectedStudentCard(),
                  const SizedBox(height: 16),
                  _buildSkillsChecklist(),
                  const SizedBox(height: 16),
                  _buildScoreSliders(),
                  const SizedBox(height: 16),
                  _buildNotesAndBeltReady(),
                  const SizedBox(height: 24),
                  _buildSaveButton(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  // ── Selected Student Card ──────────────────────────────
  Widget _buildSelectedStudentCard() {
    final s = _selectedStudent!;
    final beltColor = _beltColor(s['belt_color']);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s['first_name']} ${s['last_name']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: beltColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${s['belt_name']} Belt',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (s['student_code'] != null)
            Text(
              s['student_code'],
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildStudentDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedStudent?['id'] as int?,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1C1C1E)),
          items: widget.students.map<DropdownMenuItem<int>>((s) {
            final beltColor = _beltColor(s['belt_color']);
            return DropdownMenuItem<int>(
              value: s['id'] as int,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: beltColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${s['first_name']} ${s['last_name']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${s['belt_name']})',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (id) {
            final newStudent = widget.students.firstWhere((s) => s['id'] == id);
            _initStudent(Map<String, dynamic>.from(newStudent));
          },
        ),
      ),
    );
  }

  // ── Skills Checklist ───────────────────────────────────
  Widget _buildSkillsChecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Skills Checklist'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _skills.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'No skills found for this belt level.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _skills.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Colors.grey.shade100,
                    indent: 16,
                  ),
                  itemBuilder: (_, i) {
                    final skill = _skills[i];
                    final id = skill['id'] as int;
                    final passed = _skillResults[id] ?? false;
                    return CheckboxListTile(
                      value: passed,
                      activeColor: const Color(0xFF1C1C1E),
                      title: Text(
                        skill['skill_name'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: passed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: passed ? Colors.grey : const Color(0xFF1C1C1E),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => _skillResults[id] = val ?? false);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Score Sliders ──────────────────────────────────────
  Widget _buildScoreSliders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Performance Scores'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _scoreSlider(
                'Technique',
                _technique,
                (v) => setState(() => _technique = v),
              ),
              _scoreSlider(
                'Discipline',
                _discipline,
                (v) => setState(() => _discipline = v),
              ),
              _scoreSlider(
                'Fitness',
                _fitness,
                (v) => setState(() => _fitness = v),
              ),
              _scoreSlider(
                'Sparring',
                _sparring,
                (v) => setState(() => _sparring = v),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _scoreSlider(
    String label,
    double value,
    ValueChanged<double> onChanged, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${value.round()}/10',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 10,
          divisions: 10,
          activeColor: const Color(0xFF1C1C1E),
          inactiveColor: Colors.grey.shade200,
          onChanged: onChanged,
        ),
        if (!isLast) Divider(height: 8, color: Colors.grey.shade100),
      ],
    );
  }

  // ── Notes + Belt Ready ─────────────────────────────────
  Widget _buildNotesAndBeltReady() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Notes & Belt Readiness'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add instructor notes...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF1C1C1E)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Switch(
                    value: _beltReady,
                    activeColor: const Color(0xFF22C55E),
                    onChanged: (v) => setState(() => _beltReady = v),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Belt Promotion Ready',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _beltReady
                            ? 'Student is ready for promotion'
                            : 'Not yet ready',
                        style: TextStyle(
                          fontSize: 12,
                          color: _beltReady
                              ? const Color(0xFF22C55E)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Save Button ────────────────────────────────────────
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _saving ? null : _saveEvaluation,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1C1C1E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _saving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Save Evaluation',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
      ),
    );
  }

  // ── Section Label ──────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(width: 4, height: 16, color: const Color(0xFF1C1C1E)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}
