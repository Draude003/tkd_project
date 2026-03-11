import 'package:flutter/material.dart';
import '/models/progress_models.dart';
import '../widgets/skill_progress_card.dart';
import '../widgets/coach_notes_card.dart';
import '../widgets/readlines_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const List<SkillProgress> _skills = [
    SkillProgress(name: 'Kicks', percentage: 0.78),
    SkillProgress(name: 'Forms', percentage: 0.81),
    SkillProgress(name: 'Sparring', percentage: 0.69),
    SkillProgress(name: 'Discipline', percentage: 0.73),
  ];

  static const CoachNote _coachNote = CoachNote(
    coachName: "Coach's Notes",
    icon: 'assets/icons/profile.png',
    updatedLabel: 'Master Kim Updated 2 days ago',
    note: 'Improve guard and balance',
  );

  static const ReadinessStatus _readiness = ReadinessStatus(
    percentage: 82,
    label: 'READY',
    statusText: 'On Track',
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          SkillProgressCard(skills: _skills),
          const SizedBox(height: 16),
          CoachNotesCard(coachNote: _coachNote),
          const SizedBox(height: 16),
          ReadinessCard(readiness: _readiness),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
