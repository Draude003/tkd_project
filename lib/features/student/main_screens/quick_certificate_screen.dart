import 'package:flutter/material.dart';
import '../studprofile_module/widgets/certificate_tab.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
         iconTheme: const IconThemeData(color: Colors.white),
         titleSpacing: 0,
        title: const Text(
          'Certificates',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: CertificateTab(),
      ),
    );
  }
}