class CertificateModel {
  final String id;
  final String title;
  final String date;
  final String studentName;
  final String achievement;
  final String dateAwarded;
  final String instructor;
  final String school;
  final bool hasQr;

  const CertificateModel({
    required this.id,
    required this.title,
    required this.date,
    required this.studentName,
    required this.achievement,
    required this.dateAwarded,
    required this.instructor,
    required this.school,
    this.hasQr = false,
  });
}

// ── Sample Data ───────────────────────────────────────────────────────────────
final List<CertificateModel> sampleCertificates = [
  const CertificateModel(
    id: 'CERT-001',
    title: 'Green Belt Promotion',
    date: 'Nov 2024',
    studentName: 'Benedick James Caber',
    achievement: 'Green Belt Promotion',
    dateAwarded: 'September 15, 2025',
    instructor: 'Master Kim',
    school: 'TKD Main',
    hasQr: true,
  ),
  const CertificateModel(
    id: 'CERT-002',
    title: 'Competition Silver Medal',
    date: 'Nov 2024',
    studentName: 'Benedick James Caber',
    achievement: 'Competition Silver Medal',
    dateAwarded: 'November 10, 2024',
    instructor: 'Master Kim',
    school: 'TKD Main',
    hasQr: false,
  ),
];
