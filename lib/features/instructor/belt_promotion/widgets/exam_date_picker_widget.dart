// widgets/exam_date_picker_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamDatePickerWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const ExamDatePickerWidget({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = selectedDate != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: hasDate
              ? const Color(0xFF1A1A2E).withOpacity(0.05)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasDate ? const Color(0xFF1A1A2E) : Colors.grey.shade300,
            width: hasDate ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              color: hasDate ? const Color(0xFF1A1A2E) : Colors.grey.shade400,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hasDate
                    ? DateFormat('MMMM dd, yyyy').format(selectedDate!)
                    : 'Set Exam Date',
                style: TextStyle(
                  color: hasDate
                      ? const Color(0xFF1A1A2E)
                      : Colors.grey.shade400,
                  fontWeight: hasDate ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
