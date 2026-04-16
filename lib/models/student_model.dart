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
      linkedParent: '',
    );
  }
}

final sampleStudent = Student(
  name: 'Juan dela cruz',
  beltLevel: 'Green Belt',
  instructor: 'Benedick caber',
  nextClass: 'Today - 5:00 PM',
  classesAttended: 7,
  totalClasses: 9,
  progressScore: 82,
  checkInTime: '4:58 PM',
  loginType: 'face_scan',
  alerts: ['Belt exam scheduled for September 20'],
  age: 15,
  program: 'Junior Sparring',
  branch: 'TKD Main Dojang',
  linkedParent: 'Maria Dela Cruz',
);