import 'package:flutter/material.dart';
import '../../../../../models/competition_tracking_model.dart';

class StudentCompetitionPrepScreen extends StatefulWidget {
  final CompetitionModel competition;
  final int participantIndex; // which student in the competition

  const StudentCompetitionPrepScreen({
    super.key,
    required this.competition,
    required this.participantIndex,
  });

  @override
  State<StudentCompetitionPrepScreen> createState() =>
      _StudentCompetitionPrepScreenState();
}

class _StudentCompetitionPrepScreenState
    extends State<StudentCompetitionPrepScreen> {
  late CompetitionParticipant _participant;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _participant = widget.competition.participants[widget.participantIndex];
    _notesController.text = _participant.coachNotes;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  List<CompetitionEvent> get _completedEvents => _participant.events
      .where((e) => e.status == EventStatus.completed)
      .toList();

  List<CompetitionEvent> get _upcomingEvents => _participant.events
      .where((e) => e.status == EventStatus.upcoming)
      .toList();

  void _toggleEvent(CompetitionEvent event) {
    setState(() {
      final idx = _participant.events.indexWhere((e) => e.id == event.id);
      if (idx == -1) return;
      final updated = List<CompetitionEvent>.from(_participant.events);
      final current = updated[idx];
      updated[idx] = current.copyWith(
        isCompleted: !current.isCompleted,
        status: current.status == EventStatus.upcoming
            ? EventStatus.completed
            : EventStatus.upcoming,
      );
      _participant = _participant.copyWith(events: updated);
    });
  }

  void _toggleTrainingFocus(TrainingFocus focus) {
    setState(() {
      final list = List<TrainingFocus>.from(_participant.trainingFocus);
      if (list.contains(focus)) {
        list.remove(focus);
      } else {
        list.add(focus);
      }
      _participant = _participant.copyWith(trainingFocus: list);
    });
  }

  String _formatDate(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Competition Tracking',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildHeaderCard(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStudentCard(),
                  const SizedBox(height: 16),
                  _buildEventsSection(),
                  const SizedBox(height: 16),
                  _buildTrainingFocusSection(),
                  const SizedBox(height: 16),
                  _buildCoachNotesSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Color(0xFFF59E0B),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.competition.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(widget.competition.eventDate),
                    style: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Breadcrumb + Student Card ──────────────────────────────────────────────

  Widget _buildStudentCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Breadcrumb
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              children: [
                const Icon(
                  Icons.emoji_events_outlined,
                  size: 14,
                  color: Color(0xFFF59E0B),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Competition Tracking',
                    style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: Color(0xFF888888),
                ),
                Text(
                  _participant.studentName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 16, color: Color(0xFFF0F0F0)),
          // Avatar + name
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFE5E7EB),
                  child: Text(
                    _participant.avatarInitial,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _participant.studentName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      _participant.studentRole,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF888888),
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

  // ── Events Section ────────────────────────────────────────────────────────

  Widget _buildEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Events',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_completedEvents.isNotEmpty) ...[
                _buildEventGroupHeader('COMPLETED'),
                ..._completedEvents.map((e) => _buildEventRow(e)),
              ],
              if (_upcomingEvents.isNotEmpty) ...[
                if (_completedEvents.isNotEmpty)
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                _buildEventGroupHeader('UPCOMING'),
                ..._upcomingEvents.map((e) => _buildEventRow(e)),
              ],
              if (_participant.events.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No events added yet.',
                      style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventGroupHeader(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFFAAAAAA),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildEventRow(CompetitionEvent event) {
    final isCompleted = event.status == EventStatus.completed;
    return InkWell(
      onTap: () => _toggleEvent(event),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF22C55E)
                    : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFCCCCCC),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                event.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isCompleted
                      ? const Color(0xFF555555)
                      : const Color(0xFF1A1A1A),
                  decoration: isCompleted ? TextDecoration.none : null,
                ),
              ),
            ),
            if (event.medal != null && event.medal != MedalResult.none)
              _buildMedalBadge(event.medal!)
            else if (!isCompleted)
              _buildUpcomingBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildMedalBadge(MedalResult medal) {
    Color bg;
    switch (medal) {
      case MedalResult.gold:
        bg = const Color(0xFFF59E0B);
        break;
      case MedalResult.silver:
        bg = const Color(0xFF9CA3AF);
        break;
      case MedalResult.bronze:
        bg = const Color(0xFFB45309);
        break;
      default:
        bg = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.15),
        border: Border.all(color: bg.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(medal.emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            medal.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: bg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Upcoming',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  // ── Training Focus ────────────────────────────────────────────────────────

  Widget _buildTrainingFocusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Training Focus',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: TrainingFocus.values.map((focus) {
              final isSelected = _participant.trainingFocus.contains(focus);
              return GestureDetector(
                onTap: () => _toggleTrainingFocus(focus),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(focus.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(
                        focus.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Coach Notes ───────────────────────────────────────────────────────────

  Widget _buildCoachNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coach Notes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _notesController,
                maxLines: 6,
                onChanged: (val) {
                  setState(() {
                    _participant = _participant.copyWith(coachNotes: val);
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Write notes here .....',
                  hintStyle: TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 8),
              Text(
                '${_notesController.text.length} characters',
                style: const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Bottom bar ────────────────────────────────────────────────────────────

  bool _isSaving = false;

  Widget _buildBottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
              disabledBackgroundColor: const Color(0xFF555555),
            ),
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 20),
            label: Text(
              _isSaving ? 'Saving...' : 'Save Changes',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  // ── Save Logic ────────────────────────────────────────────────────────────

  Future<void> _onSave() async {
    setState(() => _isSaving = true);

    // Save latest notes from controller
    _participant = _participant.copyWith(coachNotes: _notesController.text);

    // Build updated competition with the modified participant
    final updatedParticipants = List<CompetitionParticipant>.from(
      widget.competition.participants,
    );
    updatedParticipants[widget.participantIndex] = _participant;

    final updatedCompetition = CompetitionModel(
      id: widget.competition.id,
      title: widget.competition.title,
      eventDate: widget.competition.eventDate,
      status: widget.competition.status,
      participants: updatedParticipants,
    );

    // Simulate brief save delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() => _isSaving = false);

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text('${_participant.studentName}\'s data saved!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF22C55E),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );

    // Return updated competition model to parent so the list updates
    Navigator.pop(context, updatedCompetition);
  }
}
