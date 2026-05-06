import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../services/api_service.dart';
import '../../../../services/auth_services.dart';
import '../../../login/screens/login_screen.dart';

class InstructorAccountScreen extends StatefulWidget {
  const InstructorAccountScreen({super.key});

  @override
  State<InstructorAccountScreen> createState() =>
      _InstructorAccountScreenState();
}

class _InstructorAccountScreenState extends State<InstructorAccountScreen> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  bool _uploadingPhoto = false;

  static const String _storageBase = 'http://192.168.68.102:8000/storage/';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ApiService.getInstructorProfile();
    setState(() {
      _profile = data;
      _loading = false;
    });
  }

  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _uploadingPhoto = true);
    final url = await ApiService.updateInstructorPhoto(image.path);
    print('RETURNED PHOTO URL: $url');
    if (url != null) {
      setState(() {
        _profile!['photo_url'] = url;
        _uploadingPhoto = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo updated!'),
            backgroundColor: Color(0xFF22C55E),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      setState(() => _uploadingPhoto = false);
    }
  }

  void _showEditDialog(String field, String current, Function(String) onSave) {
    final controller = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit $field',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter $field',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1C1C1E)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              onSave(controller.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C1C1E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService.logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  String _photoUrl(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  if (raw.startsWith('http')) return raw;
  if (raw.startsWith('/storage/')) return 'http://192.168.68.102:8000$raw';
  return '$_storageBase$raw';
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: const Color(0xFF1C1C1E),
                  expandedHeight: 220,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.chevron_left,
                        color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    'Account Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: const Color(0xFF1C1C1E),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          // Profile photo
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 46,
                                backgroundColor: Colors.grey.shade700,
                                backgroundImage: _photoUrl(
                                            _profile!['photo_url'])
                                        .isNotEmpty
                                    ? NetworkImage(
                                        _photoUrl(_profile!['photo_url']))
                                    : null,
                                child: _photoUrl(_profile!['photo_url'])
                                        .isEmpty
                                    ? const Icon(Icons.person,
                                        size: 46, color: Colors.white54)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _uploadingPhoto
                                      ? null
                                      : _pickAndUploadPhoto,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3B82F6),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: const Color(0xFF1C1C1E),
                                          width: 2),
                                    ),
                                    child: _uploadingPhoto
                                        ? const Padding(
                                            padding: EdgeInsets.all(6),
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.camera_alt,
                                            size: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _profile!['full_name'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Instructor',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Instructor Information
                        _sectionLabel('Instructor Information'),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
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
                              _infoRow('Full Name',
                                  _profile!['full_name'] ?? '', null),
                              _divider(),
                              _infoRow(
                                'Mobile Number',
                                _profile!['mobile'] ?? 'N/A',
                                () => _showEditDialog(
                                  'Mobile Number',
                                  _profile!['mobile'] ?? '',
                                  (val) async {
                                    final success = await ApiService
                                        .updateInstructorProfile(
                                            {'mobile': val});
                                    if (success) {
                                      setState(
                                          () => _profile!['mobile'] = val);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Mobile updated!'),
                                            backgroundColor:
                                                Color(0xFF22C55E),
                                            behavior:
                                                SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                              _divider(),
                              _infoRow(
                                'Email Address',
                                _profile!['email'] ?? 'N/A',
                                () => _showEditDialog(
                                  'Email Address',
                                  _profile!['email'] ?? '',
                                  (val) async {
                                    final success = await ApiService
                                        .updateInstructorProfile(
                                            {'email': val});
                                    if (success) {
                                      setState(
                                          () => _profile!['email'] = val);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Email updated!'),
                                            backgroundColor:
                                                Color(0xFF22C55E),
                                            behavior:
                                                SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                              _divider(),
                              _infoRow(
                                  'Branch', _profile!['branch'] ?? 'N/A', null),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Assigned Classes
                        _sectionLabel('Assigned Classes'),
                        const SizedBox(height: 8),
                        ...(_profile!['classes'] as List).map((cls) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.sports_martial_arts,
                                    color: Color(0xFF1C1C1E),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cls['class_name'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1C1C1E),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${cls['schedule'] ?? ''} • ${cls['level'] ?? ''}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF22C55E)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Active',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF22C55E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 20),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _showLogoutDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1C1C1E),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Log Out',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(width: 4, height: 16, color: const Color(0xFF1C1C1E)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1E),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, VoidCallback? onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1C1E),
              ),
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: const Text(
                'Edit',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B82F6),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade100,
      indent: 16,
      endIndent: 16,
    );
  }
}