import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tkd/features/student/main_screens/student_home_screen.dart';
import 'package:tkd/features/parent/main_screens/parent_home_screen.dart';
import 'package:tkd/features/instructor/main_screens/instructor_home_screen.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:tkd/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _cameraReady = false;
  bool _isScanning = false;
  bool _showManualLogin = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? _matchedStudent;

  static const String baseUrl = 'http://192.168.68.105:8000/api';

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;
      final frontCamera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );
      _cameraController = CameraController(frontCamera, ResolutionPreset.medium, enableAudio: false);
      await _cameraController!.initialize();
      if (mounted) {
        setState(() => _cameraReady = true);
        _startAutoScan();
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _startAutoScan() {
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted || _isScanning || _showManualLogin || _matchedStudent != null) return;
      await _scanFace();
      if (mounted && _matchedStudent == null) _startAutoScan();
    });
  }

  Future<void> _scanFace() async {
  if (_cameraController == null || !_cameraReady || _isScanning) return;
  setState(() => _isScanning = true);
  try {
    final image = await _cameraController!.takePicture();

    // Check muna kung may face
    final hasFace = await _hasFace(image.path);
    if (!hasFace) {
      // Walang face — huwag mag-send sa server
      setState(() => _isScanning = false);
      _startAutoScan();
      return;
    }

    
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/auth/face-login'));
    request.files.add(await http.MultipartFile.fromPath('face_photo', image.path));
    final response = await request.send();
    final body = await response.stream.bytesToString();
    final data = jsonDecode(body);
    if (mounted && data['success'] == true) {
      setState(() => _matchedStudent = data['student']);
    }
  } catch (e) {
    debugPrint('Scan error: $e');
  } finally {
    if (mounted) setState(() => _isScanning = false);
  }
}

  Future<void> _checkIn() async {
    if (_matchedStudent == null) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/face-checkin'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'user_id': _matchedStudent!['user_id']}),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true && mounted) {
        await AuthService.saveFromFaceLogin(data);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentHomeScreen()));
      }
    } catch (e) {
      debugPrint('CheckIn error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _manualLogin() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    final result = await AuthService.login(_emailController.text.trim(), _passwordController.text.trim());
    if (!mounted) return;
    if (result['success'] == true) {
      final role = result['user']['role'];
      if (role == 'student') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentHomeScreen()));
      } else if (role == 'instructor') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const InstructorHomeScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ParentHomeScreen()));
      }
    } else {
      setState(() { _isLoading = false; _errorMessage = result['message'] ?? 'Invalid credentials.'; });
    }
  }

  Future<bool> _hasFace(String imagePath) async {
  try {
    final inputImage = InputImage.fromFilePath(imagePath);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
      ),
    );
    final faces = await faceDetector.processImage(inputImage);
    await faceDetector.close();
    return faces.isNotEmpty;
  } catch (e) {
    debugPrint('Face detection error: $e');
    return false;
  }
}

  @override
  void dispose() {
    _cameraController?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: _showManualLogin ? _buildManualLogin() : _buildFaceLogin(),
      ),
    );
  }

  Widget _buildFaceLogin() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              Image.asset('assets/icons/imagess.png', width: 36, height: 36),
              const SizedBox(width: 10),
              const Text(
                'TrainNova',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                _isScanning ? Icons.radar : _matchedStudent != null ? Icons.check_circle_rounded : Icons.face_retouching_natural_rounded,
                size: 16,
                color: _matchedStudent != null ? const Color(0xFF22C55E) : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                _isScanning ? 'Scanning...' : _matchedStudent != null ? 'Face recognized!' : 'Position your face in the frame',
                style: TextStyle(
                  fontSize: 13,
                  color: _matchedStudent != null ? const Color(0xFF22C55E) : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Camera Box — not full screen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Camera preview
                  if (_cameraReady && _cameraController != null)
                    CameraPreview(_cameraController!)
                  else
                    Container(
                      color: const Color(0xFF1C1C1E),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),

                  // Face frame overlay
                  Center(
                    child: Container(
                      width: 180,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _matchedStudent != null
                              ? const Color(0xFF22C55E)
                              : _isScanning
                                  ? Colors.amber
                                  : Colors.white60,
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),

                  // Scanning indicator
                  if (_isScanning)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text('Scanning...', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        const Spacer(),

        // Matched student card
        if (_matchedStudent != null)
          _buildStudentCard()
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      _cameraController?.pausePreview();
                      setState(() => _showManualLogin = true);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1C1C1E),
                      side: const BorderSide(color: Color(0xFF1C1C1E)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Manual Login', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStudentCard() {
  final student = _matchedStudent!;
  return Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4)),
      ],
    ),
    child: Column(
      children: [
        // Handle bar
        Container(
          width: 36,
          height: 4,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF1C1C1E),
              child: Text(
                (student['name'] as String? ?? '?')[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        'Age:  ${student['age']}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Belt:  ${student['belt'] ?? 'No Belt'}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Close
            GestureDetector(
              onTap: () => setState(() => _matchedStudent = null),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.close_rounded, color: Colors.grey, size: 16),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        Divider(color: Colors.grey.shade100, height: 1),
        const SizedBox(height: 16),

        // Check In button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _checkIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C1C1E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('CHECK IN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 14)),
                    ],
                  ),
          ),
        ),
      ],
    ),
  );
}

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _buildManualLogin() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              _cameraController?.resumePreview();
              setState(() { _showManualLogin = false; _errorMessage = null; _matchedStudent = null; });
              _startAutoScan();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_ios_rounded, size: 15, color: Color(0xFF1C1C1E)),
                const SizedBox(width: 4),
                Text('Back to Face Login', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Center(child: Image.asset('assets/icons/imagess.png', width: 72, height: 72)),
          const SizedBox(height: 14),
          const Center(
            child: Text('TrainNova', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1E))),
          ),
          Center(child: Text('Sign in to continue', style: TextStyle(color: Colors.grey[500], fontSize: 13))),
          const SizedBox(height: 28),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('EMAIL'),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(hint: 'Enter your email', icon: Icons.email_outlined),
                ),
                const SizedBox(height: 16),
                _fieldLabel('PASSWORD'),
                const SizedBox(height: 6),
                TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: _inputDecoration(hint: 'Enter your password', icon: Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                      onPressed: () => setState(() => _showPassword = !_showPassword),
                    ),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 16),
                      const SizedBox(width: 6),
                      Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13))),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _manualLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C1C1E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) => Text(
    label,
    style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
  );

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey, size: 20),
      filled: true,
      fillColor: const Color(0xFFF2F2F7),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}