class Announcement {
  final String id;
  final String title;
  final String description;
  final String date;
  final String sentAt;
  final String location;
  final String eventDate;
  final String eventTime;
  final String fee;
  final bool isRead;

  const Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.eventDate = '',
    this.sentAt = '',
    this.location = '',
    this.eventTime = '',
    this.fee = '',
    this.isRead = false, 
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['message'] ?? '',
      date: json['publish_date'] ?? '',
      sentAt: json['sent_at'] ?? '',
      location: json['location'] ?? '',
      eventDate: json['event_date'] ?? '',
      eventTime: json['event_time'] ?? '',
      fee: json['fee'] ?? '',
      isRead: json['is_read'] ?? false,
    );
  }
}