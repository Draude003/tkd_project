import 'package:flutter/material.dart';
import '../../../models/messaging_model.dart';
import '../widgets/recipient_selector.dart';
import '../widgets/message_preview.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  int _selectedTab = 0; // 0=Compose, 1=Sent, 2=Broadcast
  static const _tabs = ['Compose', 'Sent', 'Broadcast'];

  // ── Compose state ──────────────────────────────────────────────
  final _messageController = TextEditingController();
  final List<MessageRecipientModel> _recipients = [
    MessageRecipientModel(
      type: MessageRecipientType.parents,
      label: 'Parents',
      description: 'All parent contacts',
      isSelected: true,
    ),
    MessageRecipientModel(
      type: MessageRecipientType.student,
      label: 'Student',
      description: 'All active students',
    ),
    MessageRecipientModel(
      type: MessageRecipientType.classGroup,
      label: 'Class Group',
      description: 'Specific class only',
    ),
  ];

  List<String> get _selectedRecipientLabels =>
      _recipients.where((r) => r.isSelected).map((r) => r.label).toList();

  void _toggleRecipient(MessageRecipientType type) {
    setState(() {
      final r = _recipients.firstWhere((r) => r.type == type);
      r.isSelected = !r.isSelected;
    });
  }

  void _clearMessage() {
    setState(() => _messageController.clear());
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Tab Selector ─────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: _tabs.asMap().entries.map((entry) {
                final isSelected = _selectedTab == entry.key;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = entry.key),
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

          // ── Tab Content ──────────────────────────────────────────
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _ComposeTab(
                  recipients: _recipients,
                  onToggleRecipient: _toggleRecipient,
                  messageController: _messageController,
                  selectedRecipients: _selectedRecipientLabels,
                  onClear: _clearMessage,
                  onSend: () {
                    if (_messageController.text.isNotEmpty &&
                        _selectedRecipientLabels.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Message sent!'),
                          backgroundColor: Color(0xFF43A047),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      _clearMessage();
                    }
                  },
                ),
                _SentTab(messages: sampleSentMessages),
                _BroadcastTab(broadcastTypes: sampleBroadcastTypes),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Compose Tab ───────────────────────────────────────────────────────────────
class _ComposeTab extends StatefulWidget {
  final List<MessageRecipientModel> recipients;
  final Function(MessageRecipientType) onToggleRecipient;
  final TextEditingController messageController;
  final List<String> selectedRecipients;
  final VoidCallback onClear;
  final VoidCallback onSend;

  const _ComposeTab({
    required this.recipients,
    required this.onToggleRecipient,
    required this.messageController,
    required this.selectedRecipients,
    required this.onClear,
    required this.onSend,
  });

  @override
  State<_ComposeTab> createState() => _ComposeTabState();
}

class _ComposeTabState extends State<_ComposeTab> {
  @override
  void initState() {
    super.initState();
    widget.messageController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final charCount = widget.messageController.text.length;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Send To
                const _SectionLabel(label: 'Send To'),
                const SizedBox(height: 10),
                RecipientSelector(
                  recipients: widget.recipients,
                  onToggle: widget.onToggleRecipient,
                ),

                const SizedBox(height: 16),

                // Message
                const _SectionLabel(label: 'Message'),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: widget.messageController,
                        maxLines: 5,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Type your message here...',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 13,
                          ),
                          contentPadding: EdgeInsets.all(14),
                          border: InputBorder.none,
                        ),
                      ),
                      // Character count + clear
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFF0F0F0)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$charCount characters',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            ),
                            if (charCount > 0)
                              GestureDetector(
                                onTap: widget.onClear,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF555555),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Preview
                MessagePreview(
                  message: widget.messageController.text,
                  recipients: widget.selectedRecipients,
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
              onPressed: widget.onSend,
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text(
                'Send Message',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
}

// ── Sent Tab ──────────────────────────────────────────────────────────────────
class _SentTab extends StatelessWidget {
  final List<SentMessageModel> messages;
  const _SentTab({required this.messages});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [
              const Text(
                'Sent Message',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 12),
              if (messages.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      'No sent messages yet.',
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                )
              else
                ...messages.map((msg) => _SentMessageCard(msg: msg)),
            ],
          ),
        ),

        // Compose New Message button
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: switch to compose tab or open compose
              },
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text(
                'Compose New Message',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
}

class _SentMessageCard extends StatelessWidget {
  final SentMessageModel msg;
  const _SentMessageCard({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipient + time
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
                  msg.sentTo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    msg.time,
                    style: const TextStyle(fontSize: 11, color: Colors.white54),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Message content
          Text(
            msg.content,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 10),

          // Sent + Read counts
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: Color(0xFFFF9800)),
              const SizedBox(width: 4),
              Text(
                '${msg.sentCount} sent',
                style: const TextStyle(fontSize: 11, color: Colors.white54),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.check_rounded,
                size: 14,
                color: Color(0xFF43A047),
              ),
              const SizedBox(width: 4),
              Text(
                '${msg.readCount} read',
                style: const TextStyle(fontSize: 11, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Broadcast Tab ─────────────────────────────────────────────────────────────
class _BroadcastTab extends StatelessWidget {
  final List<BroadcastTypeModel> broadcastTypes;
  const _BroadcastTab({required this.broadcastTypes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [
              const Text(
                'Broadcast Types',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 12),
              ...broadcastTypes.map((b) => _BroadcastTypeCard(type: b)),
            ],
          ),
        ),

        // New Broadcast button
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: open new broadcast
              },
              icon: const Icon(Icons.campaign_rounded, size: 18),
              label: const Text(
                'New Broadcast',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
}

class _BroadcastTypeCard extends StatelessWidget {
  final BroadcastTypeModel type;
  const _BroadcastTypeCard({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(type.emoji, style: const TextStyle(fontSize: 20)),
          ),
        ),
        title: Text(
          type.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111111),
          ),
        ),
        subtitle: Text(
          type.description,
          style: const TextStyle(fontSize: 12, color: Colors.black45),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.black45,
        ),
        onTap: () {
          // TODO: open broadcast type
        },
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF111111),
      ),
    );
  }
}
