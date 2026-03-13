// widgets/promotion_action_buttons_widget.dart

import 'package:flutter/material.dart';

class PromotionActionButtonsWidget extends StatelessWidget {
  final VoidCallback onGenerateList;
  final VoidCallback onPrintEvaluation;
  final VoidCallback onApprovePromotion;
  final bool hasSelectedCandidates;

  const PromotionActionButtonsWidget({
    super.key,
    required this.onGenerateList,
    required this.onPrintEvaluation,
    required this.onApprovePromotion,
    required this.hasSelectedCandidates,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Generate + Print row
        Row(
          children: [
            Expanded(
              child: _OutlineButton(
                label: 'Generate List',
                icon: Icons.format_list_bulleted_rounded,
                onTap: onGenerateList,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _OutlineButton(
                label: 'Print Sheet',
                icon: Icons.print_rounded,
                onTap: onPrintEvaluation,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Approve button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: hasSelectedCandidates ? onApprovePromotion : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A2E),
              disabledBackgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.grey.shade400,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.verified_rounded, size: 20),
            label: Text(
              hasSelectedCandidates
                  ? 'Approve Promotion'
                  : 'Select Candidates to Approve',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1A1A2E),
        side: const BorderSide(color: Color(0xFF1A1A2E), width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 17),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }
}
