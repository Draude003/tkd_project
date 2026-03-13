// widgets/belt_selector_widget.dart

import 'package:flutter/material.dart';
import '/../models/belt_promotion_model.dart';

class BeltSelectorWidget extends StatelessWidget {
  final BeltLevel selected;
  final ValueChanged<BeltLevel> onChanged;

  const BeltSelectorWidget({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Promoting To',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BeltLevel.values.map((belt) {
            final isSelected = belt == selected;
            return GestureDetector(
              onTap: () => onChanged(belt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? belt.color : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? belt.color : Colors.grey.shade200,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: belt.color.withOpacity(0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Belt color dot
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Colors.white.withOpacity(0.8)
                            : belt.color,
                        border: Border.all(
                          color: isSelected
                              ? Colors.white.withOpacity(0.5)
                              : belt.color.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      belt.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? (belt == BeltLevel.white
                                  ? Colors.black87
                                  : Colors.white)
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
