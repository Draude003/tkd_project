import 'package:flutter/material.dart';
import '../../../../../models/competition_tracking_model.dart';

// ── Sample student roster (replace with your actual data source / provider) ──

class _StudentRosterItem {
  final String id;
  final String name;
  final String className;
  final String beltLevel;
  final Color beltColor;

  const _StudentRosterItem({
    required this.id,
    required this.name,
    required this.className,
    required this.beltLevel,
    required this.beltColor,
  });
}

final _allStudents = [
  const _StudentRosterItem(
    id: 's1',
    name: 'Juan Cruz',
    className: 'Kids Beginner',
    beltLevel: 'YELLOW',
    beltColor: Color(0xFFF59E0B),
  ),
  const _StudentRosterItem(
    id: 's2',
    name: 'Ana Santos',
    className: 'Kids Beginner',
    beltLevel: 'WHITE',
    beltColor: Color(0xFF9CA3AF),
  ),
  const _StudentRosterItem(
    id: 's3',
    name: 'Mark Lee',
    className: 'Kids Beginner',
    beltLevel: 'GREEN',
    beltColor: Color(0xFF22C55E),
  ),
  const _StudentRosterItem(
    id: 's4',
    name: 'Rica Dela Cruz',
    className: 'Teens Intermediate',
    beltLevel: 'BLUE',
    beltColor: Color(0xFF3B82F6),
  ),
  const _StudentRosterItem(
    id: 's5',
    name: 'Karl Reyes',
    className: 'Teens Intermediate',
    beltLevel: 'YELLOW',
    beltColor: Color(0xFFF59E0B),
  ),
  const _StudentRosterItem(
    id: 's6',
    name: 'Lara Pangilinan',
    className: 'Adults Sparring',
    beltLevel: 'WHITE',
    beltColor: Color(0xFF9CA3AF),
  ),
  const _StudentRosterItem(
    id: 's7',
    name: 'Paolo Torres',
    className: 'Adults Sparring',
    beltLevel: 'GREEN',
    beltColor: Color(0xFF22C55E),
  ),
];

// ── Student Picker Bottom Sheet ───────────────────────────────────────────────

class _StudentPickerSheet extends StatefulWidget {
  final List<String> alreadyAddedIds;

  const _StudentPickerSheet({required this.alreadyAddedIds});

  @override
  State<_StudentPickerSheet> createState() => _StudentPickerSheetState();
}

class _StudentPickerSheetState extends State<_StudentPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedClass = 'All Classes';

  static const _classFilters = [
    'All Classes',
    'Kids Beginner',
    'Teens Intermediate',
    'Adults Sparring',
  ];

  List<_StudentRosterItem> get _filtered {
    return _allStudents.where((s) {
      final notAdded = !widget.alreadyAddedIds.contains(s.id);
      final matchClass =
          _selectedClass == 'All Classes' || s.className == _selectedClass;
      final matchSearch =
          _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return notAdded && matchClass && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
            child: Column(
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDDDDD),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Students',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF888888),
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search student...',
                    hintStyle: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFAAAAAA),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFEEEEEE),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1A1A1A),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Class filter chips
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _classFilters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final f = _classFilters[i];
                      final selected = _selectedClass == f;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedClass = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF1A1A1A)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF1A1A1A)
                                  : const Color(0xFFE5E5E5),
                            ),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF555555),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Student List ──────────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 48,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No students found',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final s = filtered[i];
                      return GestureDetector(
                        onTap: () => Navigator.pop(context, s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Avatar
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFFE5E7EB),
                                child: Text(
                                  s.name[0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Name + class
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    Text(
                                      s.className,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF888888),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Belt badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: s.beltColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  s.beltLevel,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.chevron_right,
                                color: Color(0xFFCCCCCC),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Add Competition Sheet ─────────────────────────────────────────────────────

class AddCompetitionSheet extends StatefulWidget {
  const AddCompetitionSheet({super.key});

  @override
  State<AddCompetitionSheet> createState() => _AddCompetitionSheetState();
}

class _AddCompetitionSheetState extends State<AddCompetitionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  CompetitionStatus _selectedStatus = CompetitionStatus.upcoming;
  final List<_ParticipantEntry> _participants = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // ── Date Picker ───────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1A1A1A),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // ── Student Picker ────────────────────────────────────────────────────────

  Future<void> _openStudentPicker() async {
    final alreadyIds = _participants.map((p) => p.studentId).toList();

    final selected = await showModalBottomSheet<_StudentRosterItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _StudentPickerSheet(alreadyAddedIds: alreadyIds),
    );

    if (selected != null) {
      setState(() {
        _participants.add(
          _ParticipantEntry(
            studentId: selected.id,
            studentName: selected.name,
            avatarInitial: selected.name[0].toUpperCase(),
            className: selected.className,
            beltLevel: selected.beltLevel,
            beltColor: selected.beltColor,
          ),
        );
      });
    }
  }

  void _removeParticipant(int index) {
    setState(() => _participants.removeAt(index));
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 400), () {
      final newCompetition = CompetitionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        eventDate: _selectedDate,
        status: _selectedStatus,
        participants: _participants
            .map(
              (p) => CompetitionParticipant(
                studentId: p.studentId,
                studentName: p.studentName,
                studentRole: 'Student',
                avatarInitial: p.avatarInitial,
                events: const [],
                trainingFocus: const [],
                coachNotes: '',
              ),
            )
            .toList(),
      );

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pop(context, newCompetition);
      }
    });
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDDDDD),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Competition',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF888888),
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Competition Title
                _label('Competition Title'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                  decoration: _inputDeco('e.g. Regional Taekwondo Open'),
                ),
                const SizedBox(height: 16),

                // Event Date
                _label('Event Date'),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Color(0xFF888888),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _formatDate(_selectedDate),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: Color(0xFFAAAAAA),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Status
                _label('Status'),
                const SizedBox(height: 6),
                _buildStatusSelector(),
                const SizedBox(height: 16),

                // Students header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _label('Students'),
                    GestureDetector(
                      onTap: _openStudentPicker,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.add_circle_outline,
                            size: 16,
                            color: Color(0xFF1A1A1A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Add Student',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildParticipantsList(),
                const SizedBox(height: 24),

                // Save btn
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save Competition',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Sub-widgets ───────────────────────────────────────────────────────────

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFF555555),
    ),
  );

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
    filled: true,
    fillColor: const Color(0xFFF5F5F5),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
    ),
  );

  Widget _buildStatusSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: CompetitionStatus.values.map((s) {
        final isSelected = _selectedStatus == s;
        Color color;
        switch (s) {
          case CompetitionStatus.upcoming:
            color = const Color(0xFF3B82F6);
            break;
          case CompetitionStatus.ongoing:
            color = const Color(0xFF22C55E);
            break;
          case CompetitionStatus.completed:
            color = const Color(0xFFF59E0B);
            break;
          case CompetitionStatus.cancelled:
            color = const Color(0xFFEF4444);
            break;
        }
        return GestureDetector(
          onTap: () => setState(() => _selectedStatus = s),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? color : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : const Color(0xFFE5E7EB),
              ),
            ),
            child: Text(
              s.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF555555),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildParticipantsList() {
    if (_participants.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: const Center(
          child: Text(
            'No students added yet',
            style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: _participants.asMap().entries.map((entry) {
          final i = entry.key;
          final p = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFE5E7EB),
                      child: Text(
                        p.avatarInitial,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.studentName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          Text(
                            p.className,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Belt badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: p.beltColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        p.beltLevel,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _removeParticipant(i),
                      child: const Icon(
                        Icons.remove_circle_outline,
                        color: Color(0xFFEF4444),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < _participants.length - 1)
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Internal model for form entries ──────────────────────────────────────────

class _ParticipantEntry {
  final String studentId;
  final String studentName;
  final String avatarInitial;
  final String className;
  final String beltLevel;
  final Color beltColor;

  _ParticipantEntry({
    required this.studentId,
    required this.studentName,
    required this.avatarInitial,
    required this.className,
    required this.beltLevel,
    required this.beltColor,
  });
}
