import 'package:flutter/material.dart';
import '../../../../models/account_model.dart';

class PreferencesSection extends StatefulWidget {
  const PreferencesSection({super.key});

  @override
  State<PreferencesSection> createState() => _PreferencesSectionState();
}

class _PreferencesSectionState extends State<PreferencesSection> {
  late List<bool> _values;

  @override
  void initState() {
    super.initState();
    // Default values per item
    _values = List.generate(preferenceItems.length, (i) => i == 0 ? true : false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 0, 8),
          child: Text(
            'PREFERENCES',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: List.generate(preferenceItems.length, (index) {
              final item = preferenceItems[index];
              final isLast = index == preferenceItems.length - 1;
              return Column(
                children: [
                  _PreferenceTile(
                    item: item,
                    value: _values[index],
                    onChanged: (val) => setState(() => _values[index] = val),
                  ),
                  if (!isLast)
                    Divider(height: 1, indent: 60, color: Colors.grey.shade200),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  final PreferenceItem item;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceTile({
    required this.item,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Image.asset(item.icon, width: 30, height: 30),
        ),
      ),
      title: Text(
        item.title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        item.subtitle,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.black,
      ),
    );
  }
}