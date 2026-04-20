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
  final String monthsTraining;
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
  
  factory ChildProfileModel.fromJson(Map<String, dynamic> json) {
    return ChildProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      age: json['age'] != null ? '${json['age']} years old' : 'N/A',
      belt: json['belt'] ?? 'No Belt',
      instructor: json['instructor'] ?? 'TBA',
      classSchedule: json['next_class'] ?? 'No class scheduled',
      memberSince: json['member_since'] ?? 'N/A',
      nextBeltTest: json['next_belt_test'] ?? 'TBA',
      classesPerWeek: json['classes_per_week'] ?? 0,
      attendancePercentage: (json['attendance_percentage'] ?? 0).toDouble(),
      monthsTraining: (json['months_training'] as num?)?.toInt().toString() ?? '0',
      awardsCount: json['awards_count'] ?? 0,
      skills: [],
    );
  }
}




