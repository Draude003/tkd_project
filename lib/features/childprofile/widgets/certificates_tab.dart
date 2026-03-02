import 'package:flutter/material.dart';
import '../../../models/certificates_model.dart';

class CertificatesTab extends StatelessWidget {
  const CertificatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Section Header ───────────────────────────────────────
        const Row(
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              size: 20,
              color: Color(0xFF111111),
            ),
            SizedBox(width: 8),
            Text(
              'Competition History',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111111),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Certificate List ─────────────────────────────────────
        ...sampleCertificates.map(
          (cert) => _CertificateCard(certificate: cert),
        ),
      ],
    );
  }
}

// ── Certificate Card ──────────────────────────────────────────────────────────
class _CertificateCard extends StatelessWidget {
  final CertificateModel certificate;
  const _CertificateCard({required this.certificate});

  void _showPreview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CertificatePreviewSheet(certificate: certificate),
    );
  }

  void _showQr(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _QrVerificationSheet(certificate: certificate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            certificate.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            certificate.date,
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
          const SizedBox(height: 14),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showPreview(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF111111),
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'View PDF',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (certificate.hasQr) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showQr(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF111111),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Verify QR',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── Certificate Preview Sheet ─────────────────────────────────────────────────
class _CertificatePreviewSheet extends StatelessWidget {
  final CertificateModel certificate;
  const _CertificatePreviewSheet({required this.certificate});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Certificate Preview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Certificate Paper
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1C1C1E),
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Top border decoration
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      const Text(
                        'CERTIFICATE OF ACHIEVEMENT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'This is to certify that',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),

                      // Student Name
                      _CertField(
                        label: 'STUDENT NAME',
                        value: certificate.studentName,
                        valueStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Achievement
                      _CertField(
                        label: 'ACHIEVEMENT',
                        value: certificate.achievement,
                        valueStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date Awarded
                      _CertField(
                        label: 'DATE AWARDED',
                        value: certificate.dateAwarded.toUpperCase(),
                        valueStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFE0E0E0)),
                      const SizedBox(height: 16),

                      // Signatories
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _SignatoryBlock(
                            name: certificate.instructor,
                            role: 'Head Instructor',
                          ),
                          _SignatoryBlock(
                            name: certificate.school,
                            role: 'Official Seal',
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // QR code placeholder
                      if (certificate.hasQr) ...[
                        const Divider(color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 12),
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF1C1C1E),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            size: 56,
                            color: Color(0xFF1C1C1E),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Scan to Verify',
                          style: TextStyle(fontSize: 11, color: Colors.black45),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Bottom border
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── QR Verification Sheet ─────────────────────────────────────────────────────
class _QrVerificationSheet extends StatelessWidget {
  final CertificateModel certificate;
  const _QrVerificationSheet({required this.certificate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Certificate Verification',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // White card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Scan to Verify',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 20),

                // QR code placeholder
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF1C1C1E),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.qr_code_2_rounded,
                    size: 150,
                    color: Color(0xFF1C1C1E),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Scan this QR code to verify the authenticity of this\ncertificate on the TKD official verification portal.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.black45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────
class _CertField extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _CertField({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.black45,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: valueStyle, textAlign: TextAlign.center),
      ],
    );
  }
}

class _SignatoryBlock extends StatelessWidget {
  final String name;
  final String role;

  const _SignatoryBlock({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111111),
          ),
        ),
        Text(role, style: const TextStyle(fontSize: 11, color: Colors.black45)),
      ],
    );
  }
}
