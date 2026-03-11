import 'package:flutter/material.dart';

class InstructorInfoSection extends StatelessWidget {
  final String fullName;
  final String mobileNumber;
  final String email;
  final String branch;
  final Function(String field, String value) onEdit;

  const InstructorInfoSection({
    super.key,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.branch,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Instructor Information',
      child: Column(
        children: [
          _InfoRow(
            label: 'Full Name',
            value: fullName,
            editable: true,
            onEdit: () => _showEditDialog(context, 'Full Name', fullName),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          _InfoRow(
            label: 'Mobile Number',
            value: mobileNumber,
            editable: true,
            onEdit: () =>
                _showEditDialog(context, 'Mobile Number', mobileNumber),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          _InfoRow(
            label: 'Email Address',
            value: email,
            editable: true,
            onEdit: () => _showEditDialog(context, 'Email Address', email),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          _InfoRow(label: 'Branch', value: branch, editable: false),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String field, String current) {
    final controller = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onEdit(field, controller.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$field updated!'),
                  backgroundColor: const Color(0xFF43A047),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C1C1E),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ── Info Row ──────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool editable;
  final VoidCallback? onEdit;

  const _InfoRow({
    required this.label,
    required this.value,
    this.editable = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black45),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111111),
              ),
            ),
          ),
          if (editable)
            GestureDetector(
              onTap: onEdit,
              child: const Text(
                'Edit',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1E88E5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Section Card ──────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Container(width: 4, height: 16, color: const Color(0xFF1C1C1E)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: child,
        ),
      ],
    );
  }
}
