// widgets/division_selector_widget.dart

import 'package:flutter/material.dart';
import '/../models/belt_promotion_model.dart';

class DivisionSelectorWidget extends StatelessWidget {
  final Division selected;
  final ValueChanged<Division> onChanged;

  const DivisionSelectorWidget({
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
          'Division',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: Division.values.map((division) {
            final isSelected = division == selected;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(division),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                    right: division != Division.values.last ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color.fromARGB(255, 0, 0, 0)
                          : Colors.grey.shade200,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ).withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        division.icon,
                        size: 22,
                        color: isSelected ? Colors.white : Colors.grey.shade500,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        division.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
