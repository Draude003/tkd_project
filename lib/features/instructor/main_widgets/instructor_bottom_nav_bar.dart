import 'package:flutter/material.dart';

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class InstructorBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const InstructorBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.calendar_today_rounded, label: 'Classes'),
    _NavItem(icon: Icons.message_rounded, label: 'Announcement'),
    _NavItem(icon: Icons.people_alt_rounded, label: 'Students'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Reports'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final isSelected = i == currentIndex;
              final color = isSelected ? Colors.white : Colors.grey;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_items[i].icon, size: 24, color: color),
                    const SizedBox(height: 4),
                    Text(
                      _items[i].label,
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
