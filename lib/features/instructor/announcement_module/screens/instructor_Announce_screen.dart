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

  // Compose state
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _locationController   = TextEditingController();
  final _eventTimeController  = TextEditingController();
  final _feeController        = TextEditingController();
  bool _isSending = false;

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
  ];

  // Sent state
  List<SentMessageModel> _sentMessages = [];
  bool _isLoadingSent = false;

  @override
  void initState() {
    super.initState();
    _loadSent();
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

  void _toggleRecipient(MessageRecipientType type) {
    setState(() {
      for (final r in _recipients) {
        r.isSelected = r.type == type;
      }
    });
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

    setState(() => _isSending = true);

    final success = await ApiService.sendAnnouncement({
      'title': _titleController.text.trim(),
      'message': _messageController.text.trim(),
      'channel': 'App',
      'target_type': _selectedRecipient.targetType,
      'location'    : _locationController.text.trim(),
      'event_time'  : _eventTimeController.text.trim(),
      'fee'         : _feeController.text.trim(),
    });

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
        _eventTimeController.clear();
        _feeController.clear();
        _loadSent();
        setState(() => _selectedTab = 1); // switch to Sent tab
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _locationController.dispose();
    _eventTimeController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Tab Selector
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
                // Send To
                _sectionLabel('Send To'),
                const SizedBox(height: 10),
                ...(_recipients.map(
                  (r) => GestureDetector(
                    onTap: () => _toggleRecipient(r.type),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
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
                              child: Text(
                                r.emoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.label,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  r.description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black45,
                                  ),
                                ),
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
                                ? const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),

                const SizedBox(height: 16),

                // Title
                _sectionLabel('Title'),
                const SizedBox(height: 8),
                _textField(
                  controller: _titleController,
                  hint: 'e.g. Belt Exam Scheduled',
                  maxLines: 1,
                ),

                const SizedBox(height: 16),

                // Message
                _sectionLabel('Message'),
                const SizedBox(height: 8),
                _textField(
                  controller: _messageController,
                  hint: 'Type your announcement here...',
                  maxLines: 5,
                ),

                const SizedBox(height: 16),
                _sectionLabel('Location (optional)'),
                const SizedBox(height: 8),
                _textField(
                  controller: _locationController,
                  hint: 'e.g. TKD Main Dojang',
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                _sectionLabel('Event Time (optional)'),
                const SizedBox(height: 8),
                _textField(
                  controller: _eventTimeController,
                  hint: 'e.g. 9:00 AM',
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                _sectionLabel('Fee (optional)'),
                const SizedBox(height: 8),
                _textField(
                  controller: _feeController,
                  hint: 'e.g. ₱1,500 or Free',
                  maxLines: 1,
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),

        // Send Button
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSending ? null : _send,
              icon: _isSending
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(
                _isSending ? 'Sending...' : 'Send Announcement',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C1C1E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSentTab() {
    if (_isLoadingSent) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_sentMessages.isEmpty) {
      return const Center(
        child: Text(
          'No announcements sent yet.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sentMessages.length,
      itemBuilder: (_, i) {
        final msg = _sentMessages[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.campaign_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      msg.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    msg.time,
                    style: const TextStyle(fontSize: 11, color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                msg.content,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'To: ${msg.sentTo}',
                  style: const TextStyle(fontSize: 11, color: Colors.white60),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String label) => Text(
    label,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Color(0xFF111111),
    ),
  );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
  }) {
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
