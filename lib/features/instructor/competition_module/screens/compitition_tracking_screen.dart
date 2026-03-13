import 'package:flutter/material.dart';
import '../../../../../models/competition_tracking_model.dart';
import '../screens/student_competition_prep_screen.dart';
import '../widgets/competition_card_widget.dart';
import '../widgets/competition_filter_tabs.dart';
import '../widgets/add_competition_sheet.dart';

class CompetitionTrackingScreen extends StatefulWidget {
  const CompetitionTrackingScreen({super.key});

  @override
  State<CompetitionTrackingScreen> createState() =>
      _CompetitionTrackingScreenState();
}

class _CompetitionTrackingScreenState extends State<CompetitionTrackingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  // ── Sample data ──────────────────────────────────────────────────────────

  final List<CompetitionModel> _competitions = [
    CompetitionModel(
      id: '1',
      title: 'Student Competition Prep',
      eventDate: DateTime(2026, 2, 11),
      status: CompetitionStatus.completed,
      participants: [
        CompetitionParticipant(
          studentId: 's2',
          studentName: 'Ana Santos',
          studentRole: 'Student',
          avatarInitial: 'A',
          trainingFocus: [
            TrainingFocus.speed,
            TrainingFocus.power,
            TrainingFocus.defense,
          ],
          coachNotes: '',
          events: const [
            CompetitionEvent(
              id: 'e1',
              name: 'Direct Meet',
              isCompleted: true,
              status: EventStatus.completed,
              medal: MedalResult.gold,
            ),
            CompetitionEvent(
              id: 'e2',
              name: 'Regional',
              isCompleted: true,
              status: EventStatus.completed,
              medal: MedalResult.silver,
            ),
            CompetitionEvent(
              id: 'e3',
              name: 'Breaking',
              isCompleted: false,
              status: EventStatus.upcoming,
            ),
          ],
        ),
        CompetitionParticipant(
          studentId: 's1',
          studentName: 'Juan Cruz',
          studentRole: 'Student',
          avatarInitial: 'J',
          events: const [
            CompetitionEvent(
              id: 'e4',
              name: 'Poomsae',
              isCompleted: true,
              status: EventStatus.completed,
              medal: MedalResult.bronze,
            ),
            CompetitionEvent(
              id: 'e5',
              name: 'Sparring',
              isCompleted: false,
              status: EventStatus.upcoming,
            ),
          ],
        ),
      ],
    ),
    CompetitionModel(
      id: '2',
      title: 'Metro Cup Championship',
      eventDate: DateTime(2026, 3, 15),
      status: CompetitionStatus.ongoing,
      participants: [
        CompetitionParticipant(
          studentId: 's3',
          studentName: 'Rica Dela Cruz',
          studentRole: 'Student',
          avatarInitial: 'R',
          events: const [
            CompetitionEvent(
              id: 'e6',
              name: 'Open Sparring',
              isCompleted: false,
              status: EventStatus.upcoming,
            ),
          ],
        ),
        CompetitionParticipant(
          studentId: 's4',
          studentName: 'Karl Reyes',
          studentRole: 'Student',
          avatarInitial: 'K',
          events: const [],
        ),
      ],
    ),
    CompetitionModel(
      id: '3',
      title: 'Regional Taekwondo Open',
      eventDate: DateTime(2026, 4, 10),
      status: CompetitionStatus.upcoming,
      participants: [
        CompetitionParticipant(
          studentId: 's5',
          studentName: 'Lara Pangilinan',
          studentRole: 'Student',
          avatarInitial: 'L',
          events: const [
            CompetitionEvent(
              id: 'e7',
              name: 'Pattern Forms',
              isCompleted: false,
              status: EventStatus.upcoming,
            ),
            CompetitionEvent(
              id: 'e8',
              name: 'Freestyle Sparring',
              isCompleted: false,
              status: EventStatus.upcoming,
            ),
          ],
        ),
        CompetitionParticipant(
          studentId: 's6',
          studentName: 'Paolo Torres',
          studentRole: 'Student',
          avatarInitial: 'P',
          events: const [],
        ),
      ],
    ),
    CompetitionModel(
      id: '4',
      title: 'City Invitational Tournament',
      eventDate: DateTime(2026, 1, 5),
      status: CompetitionStatus.cancelled,
      participants: [],
    ),
  ];

  // ── Filtering ─────────────────────────────────────────────────────────────

  List<CompetitionModel> get _filtered {
    return _competitions.where((c) {
      final matchFilter =
          _selectedFilter == 'All' || c.status.label == _selectedFilter;
      final matchSearch =
          _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchFilter && matchSearch;
    }).toList();
  }

  Map<CompetitionStatus, int> get _counts {
    final m = <CompetitionStatus, int>{};
    for (final c in _competitions) {
      m[c.status] = (m[c.status] ?? 0) + 1;
    }
    return m;
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void _onCompetitionTap(CompetitionModel competition) {
    if (competition.participants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No participants in this competition.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    // If only 1 participant, go directly to detail
    if (competition.participants.length == 1) {
      Navigator.push<CompetitionModel>(
        context,
        MaterialPageRoute(
          builder: (_) => StudentCompetitionPrepScreen(
            competition: competition,
            participantIndex: 0,
          ),
        ),
      ).then(_handlePrepScreenResult);
      return;
    }
    // Multiple participants → show bottom sheet to pick student
    _showParticipantPicker(competition);
  }

  // Handle updated competition returned from StudentCompetitionPrepScreen
  void _handlePrepScreenResult(CompetitionModel? updated) {
    if (updated == null) return;
    setState(() {
      final idx = _competitions.indexWhere((c) => c.id == updated.id);
      if (idx != -1) _competitions[idx] = updated;
    });
  }

  void _showParticipantPicker(CompetitionModel competition) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Student',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...competition.participants.asMap().entries.map((entry) {
              final idx = entry.key;
              final p = entry.value;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE5E7EB),
                  child: Text(
                    p.avatarInitial,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ),
                title: Text(
                  p.studentName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('${p.events.length} events'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context); // close bottom sheet
                  Navigator.push<CompetitionModel>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudentCompetitionPrepScreen(
                        competition: competition,
                        participantIndex: idx,
                      ),
                    ),
                  ).then(_handlePrepScreenResult);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final counts = _counts;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Competition Tracking',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary row
          Container(
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                _summaryChip(
                  Icons.event_outlined,
                  '${counts[CompetitionStatus.upcoming] ?? 0}',
                  'Upcoming',
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 8),
                _summaryChip(
                  Icons.sports_martial_arts,
                  '${counts[CompetitionStatus.ongoing] ?? 0}',
                  'Ongoing',
                  const Color(0xFF22C55E),
                ),
                const SizedBox(width: 8),
                _summaryChip(
                  Icons.emoji_events_outlined,
                  '${counts[CompetitionStatus.completed] ?? 0}',
                  'Done',
                  const Color(0xFFF59E0B),
                ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search competition...',
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
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
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
          ),

          // Filter tabs
          CompetitionFilterTabs(
            selectedFilter: _selectedFilter,
            onFilterChanged: (f) => setState(() => _selectedFilter = f),
          ),
          const SizedBox(height: 10),

          // List
          Expanded(
            child: filtered.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (_, i) => CompetitionCardWidget(
                      competition: filtered[i],
                      onTap: () => _onCompetitionTap(filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddCompetition,
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Competition',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ── Add Competition ───────────────────────────────────────────────────────

  Future<void> _onAddCompetition() async {
    final result = await showModalBottomSheet<CompetitionModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddCompetitionSheet(),
    );

    if (result != null) {
      setState(() => _competitions.add(result));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${result.title}" added successfully!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF22C55E),
          ),
        );
      }
    }
  }

  Widget _summaryChip(IconData icon, String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            'No competitions found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Try a different filter or search',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
