import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
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
  bool _hasRegisteredFace = false;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _checkRegisteredFace();
  }

  Future<void> _checkRegisteredFace() async {
    try {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse('http://192.168.68.105:8000/api/student/profile'),
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
      MaterialPageRoute(builder: (_) => const _BlinkCaptureScreen()),
    ).then((result) {
      if (result == true) {
        setState(() => _hasRegisteredFace = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Face registered successfully!'),
            backgroundColor: Color(0xFF22C55E),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  Future<void> _resetFace() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Reset Face Data',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('This will remove your registered face.'),
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
        Uri.parse('http://192.168.68.105:8000/api/student/reset-face'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true && mounted) {
        setState(() => _hasRegisteredFace = false);
      }
    } catch (e) {
      debugPrint('Reset error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Face Recognition',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Icon(
                  Icons.face_retouching_natural_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Biometric Authentication',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Register your face for quick login',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
            const SizedBox(height: 24),

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
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _faceIdEnabled
                            ? const Color(0xFF22C55E)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.face_retouching_natural,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    title: const Text(
                      'Face ID',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
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
                          _hasRegisteredFace
                              ? Icons.check_circle_rounded
                              : Icons.warning_rounded,
                          color: _hasRegisteredFace
                              ? const Color(0xFF22C55E)
                              : Colors.orange,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        _hasRegisteredFace
                            ? 'Face Registered'
                            : 'No Face Registered',
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openCamera,
                  icon: const Icon(
                    Icons.face_retouching_natural_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _hasRegisteredFace ? 'RE-REGISTER FACE' : 'REGISTER FACE',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (_hasRegisteredFace) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _resetFace,
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text(
                      'RESET FACE DATA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],

            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1C1C1E).withOpacity(0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: Color(0xFF1C1C1E),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Blink your eyes when prompted to register your face. Your face data is stored securely.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        height: 1.5,
                      ),
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

// ── Blink Capture Screen ──
class _BlinkCaptureScreen extends StatefulWidget {
  const _BlinkCaptureScreen();

  @override
  State<_BlinkCaptureScreen> createState() => _BlinkCaptureScreenState();
}

class _BlinkCaptureScreenState extends State<_BlinkCaptureScreen> {
  CameraController? _cameraController;
  bool _cameraReady = false;
  bool _faceDetected = false;
  bool _blinkDetected = false;
  bool _isUploading = false;
  bool _isProcessing = false;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  static const String baseUrl = 'http://192.168.68.105:8000/api';

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
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() => _cameraReady = true);
        _startFaceDetection();
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _startFaceDetection() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (_isProcessing || _blinkDetected) return;
      _isProcessing = true;

      try {
        final inputImage = _convertToInputImage(image);
        if (inputImage == null) {
          _isProcessing = false;
          return;
        }

        final faces = await _faceDetector.processImage(inputImage);

        if (faces.isNotEmpty) {
          final face = faces.first;
          final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
          final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;

          if (mounted) {
            setState(() => _faceDetected = true);
          }

          if (leftEyeOpen < 0.2 && rightEyeOpen < 0.2 && !_blinkDetected) {
            if (mounted) setState(() => _blinkDetected = true);
            await _cameraController?.stopImageStream();
            await _captureAndUpload();
          }
        } else {
          if (mounted) setState(() => _faceDetected = false);
        }
      } catch (e) {
        debugPrint('Face detection error: $e');
      } finally {
        _isProcessing = false;
      }
    });
  }

  InputImage? _convertToInputImage(CameraImage image) {
    try {
      final camera = _cameraController!.description;
      final rotation = InputImageRotationValue.fromRawValue(
        camera.sensorOrientation,
      );
      if (rotation == null) return null;

      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) return null;

      final plane = image.planes.first;
      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _captureAndUpload() async {
    if (_isUploading) return;
    setState(() => _isUploading = true);

    try {
      final image = await _cameraController!.takePicture();
      final token = await AuthService.getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/student/register-face'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('face_photo', image.path),
      );

      final response = await request.send();
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);

      if (mounted) {
        if (data['success'] == true) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Failed to register face'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          setState(() {
            _blinkDetected = false;
            _isUploading = false;
          });
          _startFaceDetection();
        }
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      if (mounted) {
        setState(() {
          _blinkDetected = false;
          _isUploading = false;
        });
        _startFaceDetection();
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Register Face',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Camera Preview (full screen, centered) ──
            if (_cameraReady && _cameraController != null)
              Center(
                child: AspectRatio(
                  aspectRatio: 1 / _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // ── Face Frame (centered) ──
            Center(
              child: Container(
                width: 240,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _blinkDetected
                        ? const Color(0xFF22C55E)
                        : _faceDetected
                            ? Colors.amber
                            : Colors.white54,
                    width: 2.5,
                  ),
                ),
              ),
            ),

            // ── Status Message (bottom center) ──
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isUploading
                        ? 'Saving face...'
                        : _blinkDetected
                            ? 'Blink detected! Processing...'
                            : _faceDetected
                                ? 'Face detected! Now blink your eyes'
                                : 'Position your face in the frame',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // ── Upload Loading Overlay ──
            if (_isUploading)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}