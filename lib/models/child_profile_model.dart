class ChildProfileSkill {
  final String name;
  final double percentage;

  const ChildProfileSkill({required this.name, required this.percentage});
}

class ChildProfileModel {
  final String id;
  final String name;
  final String age;
  final String belt;
  final String instructor;
  final String classSchedule;
  final String memberSince;
  final String nextBeltTest;
  final int classesPerWeek;
  final double attendancePercentage;
  final int monthsTraining;
  final int awardsCount;
  final List<ChildProfileSkill> skills;

  const ChildProfileModel({
    required this.id,
    required this.name,
    required this.age,
    required this.belt,
    required this.instructor,
    required this.classSchedule,
    required this.memberSince,
    required this.nextBeltTest,
    required this.classesPerWeek,
    required this.attendancePercentage,
    required this.monthsTraining,
    required this.awardsCount,
    required this.skills,
  });
}

// ── Sample Data ──────────────────────────────────────────────────────────────
final sampleChildProfile = ChildProfileModel(
  id: '1',
  name: 'Benedick James Caber',
  age: '21 years old',
  belt: 'Green Belt',
  instructor: 'Master Kagami',
  classSchedule: 'Tuesday / Thursday - 5:00 PM',
  memberSince: 'March 2024',
  nextBeltTest: 'Sept 20, 2024',
  classesPerWeek: 2,
  attendancePercentage: 94,
  monthsTraining: 6,
  awardsCount: 3,
  skills: const [
    ChildProfileSkill(name: 'Kicks', percentage: 0.78),
    ChildProfileSkill(name: 'Forms', percentage: 0.81),
    ChildProfileSkill(name: 'Sparring', percentage: 0.69),
    ChildProfileSkill(name: 'Discipline', percentage: 0.73),
  ],
);
