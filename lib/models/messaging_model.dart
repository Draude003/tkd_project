enum MessageRecipientType { parents, student, classGroup }

class MessageRecipientModel {
  final MessageRecipientType type;
  final String label;
  final String description;
  bool isSelected;

  MessageRecipientModel({
    required this.type,
    required this.label,
    required this.description,
    this.isSelected = false,
  });

  String get iconAsset {
    switch (type) {
      case MessageRecipientType.parents:
        return '👨‍👩‍👧';
      case MessageRecipientType.student:
        return '🧑‍🎓';
      case MessageRecipientType.classGroup:
        return '💬';
    }
  }
}

class SentMessageModel {
  final String id;
  final String content;
  final String sentTo; // e.g. "All Parents", "Kids Beginner"
  final String time; // e.g. "10:32 AM", "Yesterday", "Feb 22"
  final int sentCount;
  final int readCount;

  const SentMessageModel({
    required this.id,
    required this.content,
    required this.sentTo,
    required this.time,
    required this.sentCount,
    required this.readCount,
  });
}

class BroadcastTypeModel {
  final String title;
  final String description;
  final String emoji;

  const BroadcastTypeModel({
    required this.title,
    required this.description,
    required this.emoji,
  });
}

// ── Sample Data ───────────────────────────────────────────────────────────────
final List<SentMessageModel> sampleSentMessages = [
  const SentMessageModel(
    id: 'msg-001',
    sentTo: 'All Parents',
    time: '10:32 AM',
    content:
        'Belt exam this Saturday at 9AM. Please have students arrive 15 minutes early.',
    sentCount: 18,
    readCount: 14,
  ),
  const SentMessageModel(
    id: 'msg-002',
    sentTo: 'Kids Beginner',
    time: 'Yesterday',
    content:
        'No class this Friday due to gym maintenance. Classes resume Monday.',
    sentCount: 18,
    readCount: 14,
  ),
  const SentMessageModel(
    id: 'msg-003',
    sentTo: 'All Students',
    time: 'Feb 22',
    content:
        'Reminder: Tournament sign-up deadline is Feb 15. See Coach Angel for forms.',
    sentCount: 18,
    readCount: 14,
  ),
  const SentMessageModel(
    id: 'msg-004',
    sentTo: 'Kids Beginner',
    time: 'Yesterday',
    content:
        'No class this Friday due to gym maintenance. Classes resume Monday.',
    sentCount: 18,
    readCount: 14,
  ),
];

final List<BroadcastTypeModel> sampleBroadcastTypes = [
  const BroadcastTypeModel(
    title: 'Class Broadcast',
    description: 'Send to all student in a specific class',
    emoji: '👥',
  ),
  const BroadcastTypeModel(
    title: 'Parent - Only Notice',
    description: 'Private message to parent contacts only',
    emoji: '👤',
  ),
  const BroadcastTypeModel(
    title: 'Belt Exam Reminder',
    description: 'Auto - notify exam candidates & parents',
    emoji: '🔔',
  ),
  const BroadcastTypeModel(
    title: 'School Wide Announcement',
    description: 'Broadcast to entire school community',
    emoji: '📢',
  ),
];
