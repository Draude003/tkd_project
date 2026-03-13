// screens/belt_promotion_screen.dart

import 'package:flutter/material.dart';
import '/../models/belt_promotion_model.dart';
import '../widgets/candidate_card_widget.dart';
import '../widgets/exam_date_picker_widget.dart';
import '../widgets/promotion_stats_widget.dart';
import '../widgets/promotion_action_buttons_widget.dart';
import '../widgets/division_selector_widget.dart';
import '../widgets/belt_selector_widget.dart';
import '../widgets/student_picker_sheet.dart';

class BeltPromotionScreen extends StatefulWidget {
  final Division? initialDivision;
  final BeltLevel? initialBelt;

  const BeltPromotionScreen({
    super.key,
    this.initialDivision,
    this.initialBelt,
  });

  @override
  State<BeltPromotionScreen> createState() => _BeltPromotionScreenState();
}

class _BeltPromotionScreenState extends State<BeltPromotionScreen> {
  late Division _selectedDivision;
  late BeltLevel _promotingTo;
  DateTime? _examDate;
  List<BeltPromotionCandidate> _candidates = [];

  @override
  void initState() {
    super.initState();
    _selectedDivision = widget.initialDivision ?? Division.teensIntermediate;
    _promotingTo = widget.initialBelt ?? BeltLevel.yellow;
  }

  // ── Candidate helpers ──────────────────────────────────────────────────────
  void _toggleCandidate(String id, bool? value) {
    setState(() {
      _candidates = _candidates.map((c) {
        if (c.id == id) return c.copyWith(isSelected: value ?? false);
        return c;
      }).toList();
    });
  }

  void _removeCandidate(String id) {
    setState(() => _candidates.removeWhere((c) => c.id == id));
  }

  void _onDivisionChanged(Division div) {
    setState(() {
      _selectedDivision = div;
      _candidates = [];
    });
  }

  void _onBeltChanged(BeltLevel belt) {
    setState(() {
      _promotingTo = belt;
      _candidates = _candidates
          .map((c) => c.copyWith(isSelected: false))
          .toList();
    });
  }

  void _openStudentPicker() {
    showStudentPickerSheet(
      context: context,
      division: _selectedDivision,
      alreadyAddedIds: _candidates.map((c) => c.id).toList(),
      onConfirm: (picked) {
        setState(() {
          _candidates = [..._candidates, ...picked.map((s) => s.toCandidate())];
        });
      },
    );
  }

  // ── Date picker ────────────────────────────────────────────────────────────
  Future<void> _pickExamDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _examDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1A1A2E)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _examDate = picked);
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  void _autoSelect() {
    if (_candidates.isEmpty) {
      _openStudentPicker();
      return;
    }
    setState(() {
      _candidates = _candidates.map((c) {
        final ok =
            c.attendanceCount >= 30 &&
            c.skillScore >= 4.0 &&
            c.instructorRating >= 4.0;
        return c.copyWith(isSelected: ok);
      }).toList();
    });
    final count = _candidates.where((c) => c.isSelected).length;
    _showSnack('$count candidate(s) auto-selected', const Color(0xFF1A1A2E));
  }

  void _printEvaluation() => _showSnack(
    'Preparing evaluation sheet for print...',
    const Color(0xFF1A1A2E),
  );

  void _approvePromotion() {
    final selected = _candidates.where((c) => c.isSelected).toList();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.verified_rounded, color: Color(0xFF1A1A2E)),
            SizedBox(width: 8),
            Text(
              'Confirm Promotion',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _InfoChip(
                  label: _selectedDivision.label,
                  icon: _selectedDivision.icon,
                ),
                const SizedBox(width: 8),
                _BeltChip(belt: _promotingTo),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Approve promotion for ${selected.length} candidate(s)?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            ...selected.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: Colors.grey.shade400),
                    const SizedBox(width: 8),
                    Text(c.name, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A2E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _showSnack(
                '${selected.length} candidate(s) promoted to ${_promotingTo.label}! 🥋',
                const Color(0xFF2ECC71),
              );
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final hasSelected = _candidates.any((c) => c.isSelected);
    final readyCount = _candidates
        .where((c) => c.status == PromotionStatus.ready)
        .length;
    final needsWork = _candidates
        .where((c) => c.status == PromotionStatus.needsWork)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Belt Promotion',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header card ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0),
                  ],

                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.military_tech_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedDivision.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Promoting to ${_promotingTo.label}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _promotingTo.color.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_candidates.length} Students',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Stats ────────────────────────────────────────────
            PromotionStatsWidget(
              totalCandidates: _candidates.length,
              readyCount: readyCount,
              needsWorkCount: needsWork,
            ),

            const SizedBox(height: 20),

            // ── Division selector ────────────────────────────────
            DivisionSelectorWidget(
              selected: _selectedDivision,
              onChanged: _onDivisionChanged,
            ),

            const SizedBox(height: 16),

            // ── Belt selector ────────────────────────────────────
            BeltSelectorWidget(
              selected: _promotingTo,
              onChanged: _onBeltChanged,
            ),

            const SizedBox(height: 20),

            // ── Candidates header ────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Promotion Candidates',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                Row(
                  children: [
                    // Add students button
                    GestureDetector(
                      onTap: _openStudentPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_add_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Auto-select button
                    if (_candidates.isNotEmpty)
                      TextButton.icon(
                        onPressed: _autoSelect,
                        icon: const Icon(Icons.auto_awesome_rounded, size: 14),
                        label: const Text('Auto-select'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1A1A2E),
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 6),

            // ── Criteria hint ────────────────────────────────────
            if (_candidates.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: Color(0xFF1A1A2E),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Based on attendance · skill scores · instructor ratings',
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color.fromARGB(
                          255,
                          0,
                          0,
                          0,
                        ).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 6),

            // ── Candidate list or empty state ─────────────────────
            if (_candidates.isEmpty)
              _EmptyCandidates(onAdd: _openStudentPicker)
            else
              ..._candidates.map(
                (c) => Dismissible(
                  key: Key(c.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  onDismissed: (_) => _removeCandidate(c.id),
                  child: CandidateCardWidget(
                    candidate: c,
                    onCheckChanged: (val) => _toggleCandidate(c.id, val),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // ── Exam Date ────────────────────────────────────────
            const Text(
              'Exam Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            ExamDatePickerWidget(selectedDate: _examDate, onTap: _pickExamDate),

            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade200, thickness: 1),
            const SizedBox(height: 12),

            // ── Action buttons ───────────────────────────────────
            PromotionActionButtonsWidget(
              onGenerateList: _autoSelect,
              onPrintEvaluation: _printEvaluation,
              onApprovePromotion: _approvePromotion,
              hasSelectedCandidates: hasSelected,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ── Empty state when no candidates added yet ──────────────────────────────────
class _EmptyCandidates extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyCandidates({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add_rounded,
                color: Color.fromARGB(255, 0, 0, 0),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No candidates yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to add students from this division',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dialog helper chips ───────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF1A1A2E)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _BeltChip extends StatelessWidget {
  final BeltLevel belt;
  const _BeltChip({required this.belt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: belt.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: belt.color,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            belt.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: belt == BeltLevel.white
                  ? Colors.grey.shade700
                  : belt.color,
            ),
          ),
        ],
      ),
    );
  }
}
