class InstructorClass {
  final String time;
  final String title;
  final String description;
  final String bgColor;

  const InstructorClass({
    required this.time,
    required this.title,
    required this.description,
    required this.bgColor,
  });
}

class InstructorAlert {
  final String message;
  final int count;

  const InstructorAlert({
    required this.message,
    required this.count,
  });
}

class InstructorModel {
  final String name;
  final String date;
  final List<InstructorClass> todaysClasses;
  final List<InstructorAlert> alerts;
  final int presentCount;
  final int absentCount;
  final int lateCount;

  const InstructorModel({
    required this.name,
    required this.date,
    required this.todaysClasses,
    required this.alerts,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
  });
}

final sampleInstructor = InstructorModel(
  name: 'Coach Miguel',
  date: 'Today: Feb 7, 2026',
  todaysClasses: const [
    InstructorClass(
      time: '4:00 PM',
      title: 'Kids Beginner',
      description: 'White to Yellow Belt',
      bgColor: 'orange',
    ),
    InstructorClass(
      time: '5:30 PM',
      title: 'Teens Intermediate',
      description: 'Teens Intermediate',
      bgColor: 'teal',
    ),
    InstructorClass(
      time: '7:00 PM',
      title: 'Adults Sparring',
      description: 'Red Belt & Above',
      bgColor: 'red',
    ),
  ],
  alerts: const [
    InstructorAlert(message: 'Students with expiring membership', count: 6),
    InstructorAlert(message: 'Belt exam candidates ready', count: 3),
  ],
  presentCount: 3,
  absentCount: 8,
  lateCount: 3,
);