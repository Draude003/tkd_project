import 'package:flutter/material.dart';
import '../../../../services/api_service.dart';
import '../childprofile_module/widgets/competition_tab.dart';

class ParentCompetitionScreen extends StatefulWidget {
  const ParentCompetitionScreen({super.key});

  @override
  State<ParentCompetitionScreen> createState() =>
      _ParentCompetitionScreenState();
}

class _ParentCompetitionScreenState extends State<ParentCompetitionScreen> {
  List<dynamic> _children = [];
  Map<String, dynamic>? _selectedChild;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final profile = await ApiService.getParentProfile();
    print('PARENT PROFILE: $profile');
    if (profile != null && profile['children'] != null) {
      final children = profile['children'] as List;
      print('FIRST CHILD: ${children.first}');
      setState(() {
        _children = children;
        _selectedChild = children.isNotEmpty
            ? Map<String, dynamic>.from(children.first)
            : null;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

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
          'Competitions',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _children.isEmpty
              ? const Center(child: Text('No children found.'))
              : Column(
                  children: [
                    // Child Selector
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _selectedChild?['id'] as int?,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: _children.map<DropdownMenuItem<int>>((c) {
                            return DropdownMenuItem<int>(
                              value: c['id'] as int,
                              child: Row(
                                children: [
                                  const Text('🥋',
                                      style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 10),
                                  Text(
                                    c['name'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (id) {
                            final child = _children
                                .firstWhere((c) => c['id'] == id);
                            setState(() => _selectedChild =
                                Map<String, dynamic>.from(child));
                          },
                        ),
                      ),
                    ),
                    // Competition Tab
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: _selectedChild != null
                            ? ParentCompetitionTab(
                                key: ValueKey(_selectedChild!['id']),
                                childId: _selectedChild!['id'] as int,
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ],
                ),
    );
  }
}