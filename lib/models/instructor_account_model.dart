class AssignedClassModel {
  final String name;
  final String schedule;
  final String status;
  final String emoji;

  const AssignedClassModel({
    required this.name,
    required this.schedule,
    required this.status,
    required this.emoji,
  });
}

class NotificationPrefsModel {
  bool billingReminders;
  bool attendanceAlerts;
  bool beltExamNotices;

  NotificationPrefsModel({
    this.billingReminders = true,
    this.attendanceAlerts = true,
    this.beltExamNotices = true,
  });
}

class InstructorAccountModel {
  final String name;
  final String role;
  final String mobileNumber;
  final String email;
  final String branch;
  final List<AssignedClassModel> assignedClasses;
  final NotificationPrefsModel notificationPrefs;

  InstructorAccountModel({
    required this.name,
    required this.role,
    required this.mobileNumber,
    required this.email,
    required this.branch,
    required this.assignedClasses,
    required this.notificationPrefs,
  });
}

// ── Sample Data ───────────────────────────────────────────────────────────────
final sampleInstructorAccount = InstructorAccountModel(
  name: 'Miguel Reyes',
  role: 'Instructor',
  mobileNumber: '+63 917 123 4567',
  email: 'miguel@dojo.ph',
  branch: 'Makati Branch',
  assignedClasses: const [
    AssignedClassModel(
      name: 'Kids Beginner',
      schedule: 'Mon / Wed / Fri • 4:00 PM',
      status: 'Active',
      emoji: '🥋',
    ),
    AssignedClassModel(
      name: 'Teens Intermediate',
      schedule: 'Tue / Thu • 5:30 PM',
      status: 'Active',
      emoji: '⚡',
    ),
    AssignedClassModel(
      name: 'Adults Sparring',
      schedule: 'Mon / Wed • 7:00 PM',
      status: 'Active',
      emoji: '🏆',
    ),
  ],
  notificationPrefs: NotificationPrefsModel(
    billingReminders: true,
    attendanceAlerts: true,
    beltExamNotices: true,
  ),
);
