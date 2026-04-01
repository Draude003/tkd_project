import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tkd/services/auth_services.dart';

class FaceRecognitionScreen extends StatefulWidget {
  const FaceRecognitionScreen({super.key});

  @override
  State<FaceRecognitionScreen> createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  bool _faceIdEnabled = true;
  bool _isRegistering = false;
  bool _hasRegisteredFace = false;

  static const String baseUrl = 'http://192.168.68.107:8000/api';

  @override
  void initState() {
    super.initState();
    _checkRegisteredFace();
  }

  Future<void> _checkRegisteredFace() async {
    try {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/student/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data']['has_face'] == true) {
        setState(() => _hasRegisteredFace = true);
      }
    } catch (e) {
      debugPrint('Check face error: $e');
    }
  }

  void _openCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _CaptureScreen()),
    ).then((result) {
      if (result == true) {
        setState(() => _hasRegisteredFace = true);
      }
    });
  }

  Future<void> _resetFace() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Face Data', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This will remove your registered face. You will need to re-register to use face login.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final token = await AuthService.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/student/reset-face'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true && mounted) {
        setState(() => _hasRegisteredFace = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Face data reset successfully'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF22C55E),
          ),
        );
      }
    } catch (e) {
      debugPrint('Reset face error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Face Recognition'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Face Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Icon(Icons.face_retouching_natural_rounded, color: Colors.white, size: 52),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Biometric Authentication',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1E)),
            ),
            const SizedBox(height: 8),
            Text(
              'Use your face to securely check in and authenticate',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
            const SizedBox(height: 24),

            // Status Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  // Face ID Toggle
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _faceIdEnabled ? const Color(0xFF22C55E) : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.face_retouching_natural, color: Colors.white, size: 22),
                    ),
                    title: const Text('Face ID', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      _faceIdEnabled ? 'Enabled' : 'Disabled',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                    trailing: Switch(
                      value: _faceIdEnabled,
                      onChanged: (val) => setState(() => _faceIdEnabled = val),
                      activeColor: const Color(0xFF1C1C1E),
                    ),
                  ),

                  if (_faceIdEnabled) ...[
                    Divider(height: 1, color: Colors.grey.shade100),

                    // Registration Status
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _hasRegisteredFace
                              ? const Color(0xFF22C55E).withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _hasRegisteredFace ? Icons.check_circle_rounded : Icons.warning_rounded,
                          color: _hasRegisteredFace ? const Color(0xFF22C55E) : Colors.orange,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        _hasRegisteredFace ? 'Face Registered' : 'No Face Registered',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        _hasRegisteredFace
                            ? 'Your face is set up for quick login'
                            : 'Register your face to use face login',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_faceIdEnabled) ...[
              // Register / Re-register button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openCamera,
                  icon: const Icon(Icons.camera_alt_rounded, size: 18),
                  label: Text(
                    _hasRegisteredFace ? 'RE-REGISTER FACE' : 'REGISTER FACE',
                    style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              if (_hasRegisteredFace) ...[
                const SizedBox(height: 12),
                // Reset button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _resetFace,
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text(
                      'RESET FACE DATA',
                      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ],

            const SizedBox(height: 24),

            // Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1C1C1E).withOpacity(0.1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF1C1C1E)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your face data is stored securely and only used for authentication purposes.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Camera Capture Screen ──
class _CaptureScreen extends StatefulWidget {
  const _CaptureScreen();

  @override
  State<_CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<_CaptureScreen> {
  CameraController? _cameraController;
  bool _cameraReady = false;
  bool _isCapturing = false;
  bool _isUploading = false;
  String? _capturedImagePath;

  static const String baseUrl = 'http://192.168.68.107:8000/api';

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) setState(() => _cameraReady = true);
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _capture() async {
    if (_cameraController == null || !_cameraReady || _isCapturing) return;
    setState(() => _isCapturing = true);
    try {
      final image = await _cameraController!.takePicture();
      setState(() => _capturedImagePath = image.path);
    } catch (e) {
      debugPrint('Capture error: $e');
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  Future<void> _upload() async {
    if (_capturedImagePath == null) return;
    setState(() => _isUploading = true);

    try {
      final token = await AuthService.getToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/student/register-face'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('face_photo', _capturedImagePath!),
      );

      final response = await request.send();
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);

      if (mounted) {
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Face registered successfully!'),
              backgroundColor: Color(0xFF22C55E),
              behavior: SnackBarBehavior.floating,
            ),
          );
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Failed to register face'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          setState(() => _capturedImagePath = null);
        }
      }
    } catch (e) {
      debugPrint('Upload error: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Capture Face', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _capturedImagePath != null
                  ? Image.file(File(_capturedImagePath!), fit: BoxFit.cover, width: double.infinity)
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_cameraReady && _cameraController != null)
                          CameraPreview(_cameraController!)
                        else
                          const Center(child: CircularProgressIndicator(color: Colors.white)),
                        Container(
                          width: 220,
                          height: 280,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54, width: 2),
                            borderRadius: BorderRadius.circular(120),
                          ),
                        ),
                        const Positioned(
                          bottom: 20,
                          child: Text(
                            'Center your face in the oval',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.black,
              child: _capturedImagePath != null
                  ? Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isUploading ? null : () => setState(() => _capturedImagePath = null),
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text('Retake'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white54),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isUploading ? null : _upload,
                            icon: _isUploading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Icon(Icons.check_rounded, size: 18),
                            label: Text(_isUploading ? 'Saving...' : 'Save Face'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF22C55E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: GestureDetector(
                        onTap: _isCapturing ? null : _capture,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: _isCapturing
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 32),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}