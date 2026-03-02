enum AlertCategory { important, event, general }

class AlertModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final AlertCategory category;
  final bool isRead;

  const AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.isRead = false,
  });

  AlertModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    AlertCategory? category,
    bool? isRead,
  }) {
    return AlertModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
    );
  }

  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

final List<AlertModel> sampleAlerts = [
  AlertModel(
    id: '1',
    title: 'Belt Exam Scheduled',
    description:
        'Green to Blue Belt examination scheduled for September 20, 2025.',
    date: DateTime(2025, 9, 20),
    category: AlertCategory.important,
    isRead: true,
  ),
  AlertModel(
    id: '2',
    title: 'No Classes - Holiday',
    description:
        'The TKD main will be closed on September 16-17 in observance of the national holiday.',
    date: DateTime(2025, 9, 20),
    category: AlertCategory.general,
    isRead: false,
  ),
  AlertModel(
    id: '3',
    title: 'Competition Open',
    description:
        'Registration is now open for the Regional Championship in October.',
    date: DateTime(2025, 9, 19),
    category: AlertCategory.event,
    isRead: false,
  ),
  AlertModel(
    id: '4',
    title: 'New Training Schedule',
    description:
        'Updated training hours for the month of October are now available.',
    date: DateTime(2025, 9, 15),
    category: AlertCategory.general,
    isRead: true,
  ),
  AlertModel(
    id: '5',
    title: 'Guest Instructor Visit',
    description:
        'World champion Master Kim will be visiting for a special session.',
    date: DateTime(2025, 9, 12),
    category: AlertCategory.event,
    isRead: true,
  ),
];
