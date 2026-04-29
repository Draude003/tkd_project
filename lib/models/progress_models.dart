class SkillProgress {
  final String name;
  final double percentage;

  const SkillProgress({required this.name, required this.percentage});
}

class CoachNote {
  final String coachName;
  final String updatedLabel;
  final String note;

  const CoachNote({
    required this.coachName,
    required this.updatedLabel,
    required this.note,
  });
}

class ReadinessStatus {
  final int percentage;
  final String label;
  final String statusText;

  const ReadinessStatus({
    required this.percentage,
    required this.label,
    required this.statusText,
  });
}