import 'package:flutter/material.dart';
import '../../../../models/student_evaluation_model.dart';

class SkillsChecklistCard extends StatefulWidget {
  final List<EvaluationSkill> skills;
  const SkillsChecklistCard({super.key, required this.skills});

  @override
  State<SkillsChecklistCard> createState() => _SkillsChecklistCardState();
}

class _SkillsChecklistCardState extends State<SkillsChecklistCard> {
  Color _statusColor(String status) {
    switch (status) {
      case 'Mastered': return const Color(0xFF22C55E);
      case 'In Progress': return const Color(0xFFF59E0B);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('SKILLS CHECKLIST'),
        const SizedBox(height: 10),
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
            children: List.generate(widget.skills.length, (index) {
              final skill = widget.skills[index];
              final isLast = index == widget.skills.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => skill.isChecked = !skill.isChecked),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: skill.isChecked ? const Color(0xFF1C1C1E) : Colors.transparent,
                              border: Border.all(
                                color: skill.isChecked ? const Color(0xFF1C1C1E) : Colors.grey.shade400,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: skill.isChecked
                                ? const Icon(Icons.check, color: Colors.white, size: 14)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            skill.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1C1C1E),
                            ),
                          ),
                        ),
                        Text(
                          skill.status.toUpperCase(),
                          style: TextStyle(
                            color: _statusColor(skill.status),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(height: 1, color: Colors.grey.shade100, indent: 50),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

Widget _sectionLabel(String label) => Text(
  label,
  style: TextStyle(
    color: Colors.grey[500],
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  ),
);