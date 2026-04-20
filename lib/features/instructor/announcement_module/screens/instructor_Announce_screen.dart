import 'package:flutter/material.dart';
import '../../../../models/messaging_model.dart';
import 'package:tkd/services/api_service.dart';

class InstructorAnnounceScreen extends StatefulWidget {
  const InstructorAnnounceScreen({super.key});

  @override
  State<InstructorAnnounceScreen> createState() =>
      _InstructorAnnounceScreenState();
}

class _InstructorAnnounceScreenState extends State<InstructorAnnounceScreen> {
  int _selectedTab = 0;
  static const _tabs = ['Compose', 'Sent'];

  final _titleController      = TextEditingController();
  final _messageController    = TextEditingController();
  final _locationController   = TextEditingController();
  final _feeController        = TextEditingController();
  bool _isSending = false;

  // Date & Time pickers
  DateTime? _eventDate;
  TimeOfDay? _eventTimeStart;
  TimeOfDay? _eventTimeEnd;

  String get _formattedEventDate => _eventDate == null
      ? ''
      : '${_monthName(_eventDate!.month)} ${_eventDate!.day}, ${_eventDate!.year}';

  String get _formattedEventTime {
    if (_eventTimeStart == null) return '';
    final start = _formatTime(_eventTimeStart!);
    if (_eventTimeEnd == null) return start;
    return '$start to ${_formatTime(_eventTimeEnd!)}';
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final min = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$min $period';
  }

  String _monthName(int month) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sept','Oct','Nov','Dec'
    ];
    return months[month - 1];
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1C1C1E)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _eventDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _eventTimeStart ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1C1C1E)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _eventTimeStart = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _eventTimeEnd ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1C1C1E)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _eventTimeEnd = picked);
  }

  final List<MessageRecipientModel> _recipients = [
    MessageRecipientModel(
      type: MessageRecipientType.all,
      label: 'Everyone',
      description: 'All students and parents',
      isSelected: true,
    ),
    MessageRecipientModel(
      type: MessageRecipientType.parents,
      label: 'Parents Only',
      description: 'All parent contacts',
    ),
    MessageRecipientModel(
      type: MessageRecipientType.student,
      label: 'Students Only',
      description: 'All active students',
    ),
    MessageRecipientModel(
      type: MessageRecipientType.classGroup,
      label: 'Specific Class',
      description: 'All students in a class',
    ),
    MessageRecipientModel(
      type: MessageRecipientType.specificStudents,
      label: 'Specific Students',
      description: 'Choose individual students',
    ),
    MessageRecipientModel(
      type: MessageRecipientType.specificParents,
      label: 'Specific Parents',
      description: 'Choose individual parents',
    ),
  ];

  List<SelectablePersonModel> _selectableList = [];
  bool _isLoadingList = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  List<SelectablePersonModel> get _filteredList => _selectableList
      .where((p) =>
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  List<int> get _selectedUserIds => _selectableList
      .where((p) => p.isSelected)
      .map((p) => p.id)
      .toList();

  List<SentMessageModel> _sentMessages = [];
  bool _isLoadingSent = false;

  @override
  void initState() {
    super.initState();
    _loadSent();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  Future<void> _loadSent() async {
    setState(() => _isLoadingSent = true);
    final data = await ApiService.getAnnouncements();
    setState(() {
      _sentMessages = data
          .map((a) => SentMessageModel.fromJson(Map<String, dynamic>.from(a)))
          .toList();
      _isLoadingSent = false;
    });
  }

  void _toggleRecipient(MessageRecipientType type) async {
    setState(() {
      for (final r in _recipients) {
        r.isSelected = r.type == type;
      }
      _selectableList = [];
      _searchController.clear();
    });

    final selected = _recipients.firstWhere((r) => r.type == type);
    if (selected.requiresSelection) {
      setState(() => _isLoadingList = true);
      List<dynamic> data = [];

      if (type == MessageRecipientType.specificStudents) {
        data = await ApiService.getStudentsList();
      } else if (type == MessageRecipientType.specificParents) {
        data = await ApiService.getParentsList();
      } else if (type == MessageRecipientType.classGroup) {
        data = await ApiService.getMyClasses();
      }

      setState(() {
        _selectableList = data.map((d) => SelectablePersonModel(
          id: d['id'] is int ? d['id'] : int.parse(d['id'].toString()),
          name: d['class_name'] ?? d['name'] ?? d['title'] ?? '',
          subtitle: d['level'] ?? d['subtitle'] ?? d['time'] ?? '',
        )).toList();
        _isLoadingList = false;
      });
    }
  }

  MessageRecipientModel get _selectedRecipient =>
      _recipients.firstWhere((r) => r.isSelected);

  Future<void> _send() async {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in title and message.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedRecipient.requiresSelection && _selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one recipient.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    final payload = <String, dynamic>{
      'title'       : _titleController.text.trim(),
      'message'     : _messageController.text.trim(),
      'channel'     : 'App',
      'target_type' : _selectedRecipient.targetType,
      'location'    : _locationController.text.trim(),
      'event_date'  : _formattedEventDate,
      'event_time'  : _formattedEventTime,
      'fee'         : _feeController.text.trim(),
    };

    if (_selectedRecipient.type == MessageRecipientType.specificStudents ||
        _selectedRecipient.type == MessageRecipientType.specificParents) {
      payload['user_ids'] = _selectedUserIds;
    }

    if (_selectedRecipient.type == MessageRecipientType.classGroup) {
      final selectedClass = _selectableList.firstWhere(
        (p) => p.isSelected,
        orElse: () => SelectablePersonModel(id: 0, name: '', subtitle: ''),
      );
      payload['class_id'] = selectedClass.id.toString();
    }

    final success = await ApiService.sendAnnouncement(payload);

    if (mounted) {
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Announcement sent!' : 'Failed to send.'),
          backgroundColor: success ? const Color(0xFF43A047) : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      if (success) {
        _titleController.clear();
        _messageController.clear();
        _locationController.clear();
        _feeController.clear();
        _searchController.clear();
        setState(() {
          _selectableList = [];
          _eventDate = null;
          _eventTimeStart = null;
          _eventTimeEnd = null;
          _selectedTab = 1;
        });
        _loadSent();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _locationController.dispose();
    _feeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: _tabs.asMap().entries.map((entry) {
                final isSelected = _selectedTab == entry.key;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedTab = entry.key);
                      if (entry.key == 1) _loadSent();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1C1C1E)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [_buildComposeTab(), _buildSentTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComposeTab() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('Send To'),
                const SizedBox(height: 10),
                ...(_recipients.map((r) => GestureDetector(
                  onTap: () => _toggleRecipient(r.type),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: r.isSelected
                            ? const Color(0xFF1C1C1E)
                            : const Color(0xFFE0E0E0),
                        width: r.isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E8E8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(r.emoji,
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.label,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              Text(r.description,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45)),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: r.isSelected
                                ? const Color(0xFF1C1C1E)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: r.isSelected
                                  ? const Color(0xFF1C1C1E)
                                  : const Color(0xFFCCCCCC),
                            ),
                          ),
                          child: r.isSelected
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 14)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ))),

                if (_selectedRecipient.requiresSelection) ...[
                  const SizedBox(height: 16),
                  _sectionLabel(
                    _selectedRecipient.type == MessageRecipientType.classGroup
                        ? 'Select Class'
                        : 'Select Recipients',
                  ),
                  const SizedBox(height: 8),
                  if (_isLoadingList)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    if (_selectedRecipient.type !=
                        MessageRecipientType.classGroup) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                            prefixIcon: Icon(Icons.search, color: Colors.black38, size: 20),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    ..._filteredList.map((p) => GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selectedRecipient.type == MessageRecipientType.classGroup) {
                            for (final item in _selectableList) item.isSelected = false;
                          }
                          p.isSelected = !p.isSelected;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: p.isSelected ? const Color(0xFF1C1C1E) : const Color(0xFFE0E0E0),
                            width: p.isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFF1C1C1E),
                              child: Text(
                                p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                  Text(p.subtitle, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: p.isSelected ? const Color(0xFF1C1C1E) : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: p.isSelected ? const Color(0xFF1C1C1E) : const Color(0xFFCCCCCC),
                                ),
                              ),
                              child: p.isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null,
                            ),
                          ],
                        ),
                      ),
                    )),
                    if (_filteredList.isEmpty && !_isLoadingList)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: Text('No results found.', style: TextStyle(color: Colors.grey[400]))),
                      ),
                  ],
                ],

                const SizedBox(height: 16),
                _sectionLabel('Title'),
                const SizedBox(height: 8),
                _textField(controller: _titleController, hint: 'e.g. Belt Exam Scheduled', maxLines: 1),
                const SizedBox(height: 16),
                _sectionLabel('Message'),
                const SizedBox(height: 8),
                _textField(controller: _messageController, hint: 'Type your announcement here...', maxLines: 5),
                const SizedBox(height: 16),
                _sectionLabel('Location (optional)'),
                const SizedBox(height: 8),
                _textField(controller: _locationController, hint: 'e.g. TKD Main Dojang', maxLines: 1),
                const SizedBox(height: 16),

                // Event Date Picker
                _sectionLabel('Event Date (optional)'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18, color: Colors.black45),
                        const SizedBox(width: 10),
                        Text(
                          _formattedEventDate.isEmpty ? 'Select date' : _formattedEventDate,
                          style: TextStyle(
                            fontSize: 14,
                            color: _formattedEventDate.isEmpty ? Colors.black38 : const Color(0xFF1C1C1E),
                          ),
                        ),
                        const Spacer(),
                        if (_eventDate != null)
                          GestureDetector(
                            onTap: () => setState(() => _eventDate = null),
                            child: const Icon(Icons.close_rounded, size: 16, color: Colors.black38),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Event Time Picker
                _sectionLabel('Event Time (optional)'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickStartTime,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 16, color: Colors.black45),
                              const SizedBox(width: 8),
                              Text(
                                _eventTimeStart == null ? 'Start' : _formatTime(_eventTimeStart!),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _eventTimeStart == null ? Colors.black38 : const Color(0xFF1C1C1E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('to', style: TextStyle(color: Colors.black45)),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickEndTime,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 16, color: Colors.black45),
                              const SizedBox(width: 8),
                              Text(
                                _eventTimeEnd == null ? 'End' : _formatTime(_eventTimeEnd!),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _eventTimeEnd == null ? Colors.black38 : const Color(0xFF1C1C1E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _sectionLabel('Fee (optional)'),
                const SizedBox(height: 8),
                _textField(controller: _feeController, hint: 'e.g. ₱1,500 or Free', maxLines: 1),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSending ? null : _send,
              icon: _isSending
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(
                _isSending ? 'Sending...' : 'Send Announcement',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C1C1E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSentTab() {
    if (_isLoadingSent) return const Center(child: CircularProgressIndicator());
    if (_sentMessages.isEmpty) {
      return const Center(child: Text('No announcements sent yet.', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sentMessages.length,
      itemBuilder: (_, i) {
        final msg = _sentMessages[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
                    child: const Center(child: Icon(Icons.campaign_rounded, color: Colors.white, size: 20)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(msg.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))),
                  Text(msg.time, style: const TextStyle(fontSize: 11, color: Colors.white54)),
                ],
              ),
              const SizedBox(height: 10),
              Text(msg.content, style: const TextStyle(fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20)),
                child: Text('To: ${msg.sentTo}', style: const TextStyle(fontSize: 11, color: Colors.white60)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String label) => Text(
    label,
    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111111)),
  );

  Widget _textField({required TextEditingController controller, required String hint, required int maxLines}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
          contentPadding: const EdgeInsets.all(14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}