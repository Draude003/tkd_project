import 'package:flutter/material.dart';
import '../../../../models/messaging_model.dart';

class RecipientSelector extends StatelessWidget {
  final List<MessageRecipientModel> recipients;
  final Function(MessageRecipientType) onToggle;

  const RecipientSelector({
    super.key,
    required this.recipients,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recipients
          .map((r) => _RecipientTile(recipient: r, onToggle: onToggle))
          .toList(),
    );
  }
}

class _RecipientTile extends StatelessWidget {
  final MessageRecipientModel recipient;
  final Function(MessageRecipientType) onToggle;

  const _RecipientTile({required this.recipient, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(recipient.type),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: recipient.isSelected
                ? const Color(0xFF1C1C1E)
                : const Color(0xFFE0E0E0),
            width: recipient.isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  recipient.iconAsset,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Label + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipient.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111111),
                    ),
                  ),
                  Text(
                    recipient.description,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ),

            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: recipient.isSelected
                    ? const Color(0xFF1C1C1E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: recipient.isSelected
                      ? const Color(0xFF1C1C1E)
                      : const Color(0xFFCCCCCC),
                ),
              ),
              child: recipient.isSelected
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
    );
  }
}
