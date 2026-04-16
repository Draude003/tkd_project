enum MessageRecipientType { all, parents, student, classGroup }

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

  String get emoji {
    switch (type) {
      case MessageRecipientType.all:
        return '📢';
      case MessageRecipientType.parents:
        return '👨‍👩‍👧';
      case MessageRecipientType.student:
        return '🧑‍🎓';
      case MessageRecipientType.classGroup:
        return '💬';
    }
  }

  String get targetType {
    switch (type) {
      case MessageRecipientType.all:
        return 'all';
      case MessageRecipientType.parents:
        return 'parents';
      case MessageRecipientType.student:
        return 'students';
      case MessageRecipientType.classGroup:
        return 'class';
    }
  }
}

class SentMessageModel {
  final String id;
  final String title;
  final String content;
  final String sentTo;
  final String time;

  const SentMessageModel({
    required this.id,
    required this.title,
    required this.content,
    required this.sentTo,
    required this.time,
  });

  factory SentMessageModel.fromJson(Map<String, dynamic> json) {
    return SentMessageModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      content: json['message'] ?? '',
      sentTo: json['target_type'] ?? 'all',
      time: json['publish_date'] != null
          ? _formatDate(json['publish_date'])
          : '',
    );
  }

  static String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sept','Oct','Nov','Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}