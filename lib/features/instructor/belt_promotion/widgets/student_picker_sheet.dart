// widgets/student_picker_sheet.dart

import 'package:flutter/material.dart';
import '/../models/belt_promotion_model.dart';

// ── Simple student data model used in the picker ─────────────────────────────
class StudentPickerEntry {
  final String id;
  final String name;
  final BeltLevel currentBelt;
  final Division division;
  final int attendanceCount;
  final double skillScore;
  final double instructorRating;

  const StudentPickerEntry({
    required this.id,
    required this.name,
    required this.currentBelt,
    required this.division,
    required this.attendanceCount,
    required this.skillScore,
    required this.instructorRating,
  });

  PromotionStatus get suggestedStatus {
    if (attendanceCount >= 30 && skillScore >= 4.0 && instructorRating >= 4.0) {
      return PromotionStatus.ready;
    }
    return PromotionStatus.needsWork;
  }

  BeltPromotionCandidate toCandidate() => BeltPromotionCandidate(
    id: id,
    name: name,
    currentBelt: currentBelt,
    attendanceCount: attendanceCount,
    skillScore: skillScore,
    instructorRating: instructorRating,
    status: suggestedStatus,
    isSelected: suggestedStatus == PromotionStatus.ready,
  );
}

// ── Sample student pool — replace with your real data ────────────────────────
final List<StudentPickerEntry> allStudents = [
  StudentPickerEntry(
    id: 'c1',
    name: 'Maria D.',
    currentBelt: BeltLevel.white,
    division: Division.teensIntermediate,
    attendanceCount: 42,
    skillScore: 4.7,
    instructorRating: 4.8,
  ),
  StudentPickerEntry(
    id: 'c2',
    name: 'John R.',
    currentBelt: BeltLevel.white,
    division: Division.teensIntermediate,
    attendanceCount: 38,
    skillScore: 4.4,
    instructorRating: 4.5,
  ),
  StudentPickerEntry(
    id: 'c3',
    name: 'Paolo T.',
    currentBelt: BeltLevel.white,
    division: Division.teensIntermediate,
    attendanceCount: 21,
    skillScore: 3.1,
    instructorRating: 3.0,
  ),
  StudentPickerEntry(
    id: 'c4',
    name: 'Ana L.',
    currentBelt: BeltLevel.yellow,
    division: Division.teensIntermediate,
    attendanceCount: 35,
    skillScore: 4.2,
    instructorRating: 4.3,
  ),
  StudentPickerEntry(
    id: 'c5',
    name: 'Rico M.',
    currentBelt: BeltLevel.yellow,
    division: Division.teensIntermediate,
    attendanceCount: 18,
    skillScore: 2.9,
    instructorRating: 3.1,
  ),
  StudentPickerEntry(
    id: 'c6',
    name: 'Juan Cruz',
    currentBelt: BeltLevel.yellow,
    division: Division.kidsBeginner,
    attendanceCount: 40,
    skillScore: 4.5,
    instructorRating: 4.6,
  ),
  StudentPickerEntry(
    id: 'c7',
    name: 'Ana Santos',
    currentBelt: BeltLevel.white,
    division: Division.kidsBeginner,
    attendanceCount: 15,
    skillScore: 3.0,
    instructorRating: 2.8,
  ),
  StudentPickerEntry(
    id: 'c8',
    name: 'Mark Lee',
    currentBelt: BeltLevel.green,
    division: Division.kidsBeginner,
    attendanceCount: 33,
    skillScore: 4.1,
    instructorRating: 4.2,
  ),
  StudentPickerEntry(
    id: 'c9',
    name: 'Lara Pangilinan',
    currentBelt: BeltLevel.white,
    division: Division.adultsSparring,
    attendanceCount: 28,
    skillScore: 3.8,
    instructorRating: 3.9,
  ),
  StudentPickerEntry(
    id: 'c10',
    name: 'Paolo Torres',
    currentBelt: BeltLevel.green,
    division: Division.adultsSparring,
    attendanceCount: 45,
    skillScore: 4.9,
    instructorRating: 4.8,
  ),
];

// ── Bottom sheet function ─────────────────────────────────────────────────────
Future<void> showStudentPickerSheet({
  required BuildContext context,
  required Division division,
  required List<String> alreadyAddedIds,
  required void Function(List<StudentPickerEntry>) onConfirm,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _StudentPickerSheet(
      division: division,
      alreadyAddedIds: alreadyAddedIds,
      onConfirm: onConfirm,
    ),
  );
}

// ── Sheet widget ──────────────────────────────────────────────────────────────
class _StudentPickerSheet extends StatefulWidget {
  final Division division;
  final List<String> alreadyAddedIds;
  final void Function(List<StudentPickerEntry>) onConfirm;

  const _StudentPickerSheet({
    required this.division,
    required this.alreadyAddedIds,
    required this.onConfirm,
  });

  @override
  State<_StudentPickerSheet> createState() => _StudentPickerSheetState();
}

class _StudentPickerSheetState extends State<_StudentPickerSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(
      () => setState(() => _query = _searchCtrl.text.toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<StudentPickerEntry> get _filtered {
    return allStudents.where((s) {
      final matchDiv = s.division == widget.division;
      final notAdded = !widget.alreadyAddedIds.contains(s.id);
      final matchSearch =
          _query.isEmpty || s.name.toLowerCase().contains(_query);
      return matchDiv && notAdded && matchSearch;
    }).toList();
  }

  void _toggle(String id) {
    setState(() {
      _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
    });
  }

  void _confirm() {
    final picked = allStudents.where((s) => _selected.contains(s.id)).toList();
    Navigator.pop(context);
    widget.onConfirm(picked);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6FA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // ── Handle ───────────────────────────────────────────
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // ── Header ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.division.icon,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add Candidates',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        Text(
                          widget.division.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_selected.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_selected.length} selected',
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
            const SizedBox(height: 14),

            // ── Search ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search student...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.grey.shade400,
                              size: 18,
                            ),
                            onPressed: () => _searchCtrl.clear(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── List ─────────────────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _query.isEmpty
                                ? 'All students already added'
                                : 'No results for "$_query"',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final s = filtered[i];
                        final isChosen = _selected.contains(s.id);
                        final belt = s.currentBelt;
                        final isReady =
                            s.suggestedStatus == PromotionStatus.ready;

                        return GestureDetector(
                          onTap: () => _toggle(s.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isChosen
                                    ? const Color(0xFF1A1A2E)
                                    : Colors.grey.shade200,
                                width: isChosen ? 2 : 1,
                              ),
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
                                // Avatar
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: belt.color,
                                      width: 2.5,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: const Color(0xFF1A1A2E),
                                    child: Text(
                                      s.name.substring(0, 1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF1A1A2E),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: belt.color.withOpacity(
                                                0.12,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              belt.label,
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                                color: belt == BeltLevel.white
                                                    ? Colors.grey.shade700
                                                    : belt.color,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            Icons.calendar_today_rounded,
                                            size: 10,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${s.attendanceCount} days',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            Icons.star_rounded,
                                            size: 10,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${s.skillScore.toStringAsFixed(1)} skill',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Ready / Needs Work tag
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isReady
                                        ? const Color(
                                            0xFF2ECC71,
                                          ).withOpacity(0.12)
                                        : const Color(
                                            0xFFE74C3C,
                                          ).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    isReady ? 'Ready' : 'Needs Work',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isReady
                                          ? const Color(0xFF2ECC71)
                                          : const Color(0xFFE74C3C),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Checkmark
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: isChosen
                                        ? const Color(0xFF1A1A2E)
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isChosen
                                          ? const Color(0xFF1A1A2E)
                                          : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: isChosen
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // ── Confirm button ────────────────────────────────────
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selected.isNotEmpty ? _confirm : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A2E),
                      disabledBackgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _selected.isEmpty
                          ? 'Select students to add'
                          : 'Add ${_selected.length} Student${_selected.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
