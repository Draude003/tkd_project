import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../services/api_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ApiService.getInstructorReports();
    setState(() {
      _data = data;
      _loading = false;
    });
  }

  Future<void> _exportPdf() async {
    if (_data == null) return;
    setState(() => _exporting = true);

    final pdf = pw.Document();
    final students = _data!['student_reports'] as List;
    final now = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Class Performance Report',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Generated: ${now.day}/${now.month}/${now.year}',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 24),

          // Summary Stats
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _pdfStat('Attendance Rate',
                    '${_data!['attendance_rate']}%'),
                _pdfStat('Active Students',
                    '${_data!['active_students']}'),
                _pdfStat('Promotion Ready',
                    '${_data!['promotion_ready']}'),
                _pdfStat('Delinquent', '${_data!['delinquent']}'),
              ],
            ),
          ),
          pw.SizedBox(height: 24),

          // Table header
          pw.Text(
            'Student Breakdown',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),

          // Table
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1.5),
            },
            children: [
              // Header row
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey800,
                ),
                children: [
                  _pdfTableHeader('Student'),
                  _pdfTableHeader('Belt'),
                  _pdfTableHeader('Attendance'),
                  _pdfTableHeader('Ready'),
                  _pdfTableHeader('Delinquent'),
                ],
              ),
              // Data rows
              ...students.asMap().entries.map((entry) {
                final i = entry.key;
                final s = entry.value;
                final isEven = i % 2 == 0;
                return pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: isEven ? PdfColors.white : PdfColors.grey50,
                  ),
                  children: [
                    _pdfTableCell(s['name']),
                    _pdfTableCell(s['belt']),
                    _pdfTableCell('${s['attendance_rate']}%'),
                    _pdfTableCell(
                        s['promotion_ready'] == true ? 'yes' : 'No'),
                    _pdfTableCell(
                        s['delinquent'] == true ? 'Yes' : 'No'),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );

    setState(() => _exporting = false);

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'class_report_${now.day}_${now.month}_${now.year}.pdf',
    );
  }

  pw.Widget _pdfStat(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: const pw.TextStyle(
            fontSize: 9,
            color: PdfColors.grey600,
          ),
        ),
      ],
    );
  }

  pw.Widget _pdfTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }

  pw.Widget _pdfTableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_data == null) {
      return const Center(child: Text('Failed to load reports.'));
    }

    final students = _data!['student_reports'] as List;

    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Class Performance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    Text(
                      'Overview of your students',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _exporting ? null : _exportPdf,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _exporting
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.picture_as_pdf_rounded, size: 16),
                  label: Text(_exporting ? 'Exporting...' : 'Export PDF'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  '${_data!['attendance_rate']}%',
                  'Attendance Rate',
                  Icons.calendar_today_rounded,
                  const Color(0xFF3B82F6),
                ),
                _buildStatCard(
                  '${_data!['active_students']}',
                  'Active Students',
                  Icons.people_rounded,
                  const Color(0xFF22C55E),
                ),
                _buildStatCard(
                  '${_data!['promotion_ready']}',
                  'Promotion Ready',
                  Icons.military_tech_rounded,
                  const Color(0xFFF59E0B),
                ),
                _buildStatCard(
                  '${_data!['delinquent']}',
                  'Delinquent',
                  Icons.warning_amber_rounded,
                  const Color(0xFFEF4444),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Student breakdown header
            const Text(
              'Student Breakdown',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 10),

            // Student list
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: students.asMap().entries.map((entry) {
                  final i = entry.key;
                  final s = entry.value;
                  final isReady = s['promotion_ready'] == true;
                  final isDelinquent = s['delinquent'] == true;
                  final rate = s['attendance_rate'] as int;
                  final rateColor = rate >= 75
                      ? const Color(0xFF22C55E)
                      : rate >= 50
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFFEF4444);

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            // Name + belt
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s['name'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1C1C1E),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    s['belt'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Tags
                            Row(
                              children: [
                                // Attendance rate
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: rateColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$rate%',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: rateColor,
                                    ),
                                  ),
                                ),
                                if (isReady) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF59E0B)
                                          .withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      '🏅 Ready',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFF59E0B),
                                      ),
                                    ),
                                  ),
                                ],
                                if (isDelinquent) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF4444)
                                          .withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      '⚠ Balance',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFEF4444),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (i < students.length - 1)
                        Divider(
                          height: 1,
                          color: Colors.grey.shade100,
                          indent: 16,
                          endIndent: 16,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}