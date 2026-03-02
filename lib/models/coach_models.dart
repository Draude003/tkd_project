class CoachModel {
  final String id;
  final String name;
  final String role;

  const CoachModel({required this.id, required this.name, required this.role});
}

// ── Sample Data ───────────────────────────────────────────────────────────────
final List<CoachModel> sampleCoaches = [
  const CoachModel(
    id: 'coach-001',
    name: 'Master Kagami',
    role: 'Head Instructor',
  ),
  const CoachModel(
    id: 'coach-002',
    name: 'Master Kagami',
    role: 'Assistant Instructor',
  ),
];
