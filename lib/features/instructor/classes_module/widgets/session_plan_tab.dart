import 'package:flutter/material.dart';

class SessionActivity {
  String name;
  int minutes;

  SessionActivity({required this.name, required this.minutes});
}

class SessionPlanTab extends StatefulWidget {
  final String className;
  const SessionPlanTab({super.key, required this.className});

  @override
  State<SessionPlanTab> createState() => _SessionPlanTabState();
}

class _SessionPlanTabState extends State<SessionPlanTab> {
  final List<SessionActivity> _activities = [
    SessionActivity(name: 'Warmup', minutes: 10),
    SessionActivity(name: 'Stretch', minutes: 5),
    SessionActivity(name: 'Basic Kicks', minutes: 15),
    SessionActivity(name: 'Forms', minutes: 15),
    SessionActivity(name: 'Game Drills', minutes: 10),
  ];

  final List<String> _presets = [
    'Warm up', 'Stretching', 'Kicks', 'Forms',
    'Sparring', 'Drill', 'Game', 'Cooldown',
  ];

  final TextEditingController _nameController = TextEditingController();
  int _newDuration = 15;
  bool _showAddForm = false;

  int get _totalMinutes => _activities.fold(0, (sum, a) => sum + a.minutes);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addActivity() {
    if (_nameController.text.trim().isEmpty) return;
    setState(() {
      _activities.add(SessionActivity(
        name: _nameController.text.trim(),
        minutes: _newDuration,
      ));
      _nameController.clear();
      _newDuration = 15;
      _showAddForm = false;
    });
  }

  void _deleteActivity(int index) {
    setState(() => _activities.removeAt(index));
  }

  void _adjustMinutes(int index, int delta) {
    setState(() {
      final newVal = _activities[index].minutes + delta;
      if (newVal >= 5) _activities[index].minutes = newVal;
    });
  }

  void _showEditDialog(int index) {
    final controller = TextEditingController(text: _activities[index].name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Activity', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Activity name',
            filled: true,
            fillColor: const Color(0xFFF2F2F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _activities[index].name = controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C1C1E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _minusPlus({required int index}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _adjustMinutes(index, -5),
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              child: const Icon(Icons.remove, size: 14),
            ),
          ),
          Text(
            '${_activities[index].minutes} min',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: () => _adjustMinutes(index, 5),
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              child: const Icon(Icons.add, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Session Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.timer_outlined, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Total Session',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  '$_totalMinutes min · ${_activities.length} activities',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section Label
          Text(
            'SESSION ACTIVITIES',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),

          // Activities List
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
              children: List.generate(_activities.length, (index) {
                final activity = _activities[index];
                final isLast = index == _activities.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          // Drag handle
                          Icon(Icons.drag_indicator, color: Colors.grey[300], size: 20),
                          const SizedBox(width: 10),
                          // Name
                          Expanded(
                            child: Text(
                              activity.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1C1E),
                              ),
                            ),
                          ),
                          // Minus/Plus
                          _minusPlus(index: index),
                          const SizedBox(width: 8),
                          // Edit
                          GestureDetector(
                            onTap: () => _showEditDialog(index),
                            child: Icon(Icons.edit_outlined, size: 18, color: Colors.grey[400]),
                          ),
                          const SizedBox(width: 8),
                          // Delete
                          GestureDetector(
                            onTap: () => _deleteActivity(index),
                            child: Icon(Icons.delete_outline, size: 18, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(height: 1, color: Colors.grey.shade100, indent: 46),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Add Activity Section
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Activity',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Preset Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _presets.map((preset) {
                    return GestureDetector(
                      onTap: () => setState(() => _nameController.text = preset),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          preset,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1C1C1E),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Activity Name Input
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Activity Name (e.g Back Kick Drill)',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFFF2F2F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),

                // Duration Adjuster
                Row(
                  children: [
                    const Text('Duration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() {
                              if (_newDuration > 5) _newDuration -= 5;
                            }),
                            child: Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              child: const Icon(Icons.remove, size: 16),
                            ),
                          ),
                          Text(
                            '$_newDuration min',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _newDuration += 5),
                            child: Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              child: const Icon(Icons.add, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Add / Cancel Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _addActivity,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C1C1E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() {
                          _nameController.clear();
                          _newDuration = 15;
                        }),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1C1C1E),
                          side: const BorderSide(color: Color(0xFF1C1C1E)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bottom Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Template saved!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
                  icon: const Icon(Icons.save_outlined, size: 18),
                  label: const Text('Save Template', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reused for next week!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Reuse Next Week', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1C1C1E),
                    side: const BorderSide(color: Color(0xFF1C1C1E)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}