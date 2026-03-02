enum AttendanceStatus { present, absent, late }

class AttendanceRecord {
  final DateTime date;
  final AttendanceStatus status;
  final String method; // e.g. "Face Scan"
  final String? time; // e.g. "4:58 PM"

  const AttendanceRecord({
    required this.date,
    required this.status,
    required this.method,
    this.time,
  });

  String get formattedDay {
    return date.day.toString();
  }

  String get formattedMonth {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEPT',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[date.month - 1];
  }
}

// ── Sample Data ───────────────────────────────────────────────────────────────
final List<AttendanceRecord> sampleAttendance = [
  AttendanceRecord(
    date: DateTime(2024, 9, 7),
    status: AttendanceStatus.present,
    method: 'Face Scan',
    time: '4:58 PM',
  ),
  AttendanceRecord(
    date: DateTime(2024, 9, 3),
    status: AttendanceStatus.present,
    method: 'Face Scan',
    time: '5:15 PM',
  ),
  AttendanceRecord(
    date: DateTime(2024, 9, 5),
    status: AttendanceStatus.absent,
    method: 'Face Scan',
    time: null,
  ),
  AttendanceRecord(
    date: DateTime(2024, 9, 8),
    status: AttendanceStatus.present,
    method: 'Face Scan',
    time: '4:52 PM',
  ),
  AttendanceRecord(
    date: DateTime(2024, 9, 1),
    status: AttendanceStatus.late,
    method: 'Face Scan',
    time: '5:45 PM',
  ),
  AttendanceRecord(
    date: DateTime(2024, 8, 29),
    status: AttendanceStatus.present,
    method: 'Face Scan',
    time: '4:59 PM',
  ),
  AttendanceRecord(
    date: DateTime(2024, 8, 27),
    status: AttendanceStatus.absent,
    method: 'Face Scan',
    time: null,
  ),
];
