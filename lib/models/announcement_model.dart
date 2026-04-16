class Announcement {
  final String id;
  final String title;
  final String description;
  final String date;
  final String location;
  final String eventTime;
  final String fee;

  const Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.location = '',
    this.eventTime = '',
    this.fee = '',
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['message'] ?? '',
      date: json['publish_date'] != null
          ? _formatDate(json['publish_date'])
          : '',
      location: json['location'] ?? '',
      eventTime: json['event_time'] ?? '',
      fee: json['fee'] ?? '',
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