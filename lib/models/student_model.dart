class Student {
  final String name;
  final String beltLevel;
  final String instructor;
  final String nextClass;
  final int classesAttended;
  final int totalClasses;
  final int progressScore;
  final String checkInTime;
  final String loginType;
  final List<String> alerts;
  final int age;
  final String program;
  final String branch;
  final String linkedParent;
  final String? planName;
  final String? photoUrl;

  const Student({
    required this.name,
    required this.beltLevel,
    required this.instructor,
    required this.nextClass,
    required this.classesAttended,
    required this.totalClasses,
    required this.progressScore,
    required this.checkInTime,
    this.loginType = '',
    required this.alerts,
    required this.age,
    required this.program,
    required this.branch,
    required this.linkedParent,
    this.planName,
    this.photoUrl,
  });

  String get classAttendanceSummary => '$classesAttended/$totalClasses';
  String get progressScoreLabel => '$progressScore%';

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] ?? '',
      beltLevel: json['belt'] ?? 'No Belt',
      instructor: json['instructor'] ?? 'TBA',
      nextClass: json['next_class'] ?? 'No class scheduled',
      classesAttended: json['classes_attended'] ?? 0,
      totalClasses: json['total_classes'] ?? 0,
      progressScore: 0,
      checkInTime: json['check_in_time'] ?? '',
      loginType: json['login_type'] ?? '',
      alerts: [],
      age: json['age'] ?? 0,
      program: '',
      branch: json['branch']?.toString() ?? '',
      linkedParent: json['linked_parent'] ?? '',
      planName: json['plan_name'],
      photoUrl: json['photo_url'],
    );
  }
}
