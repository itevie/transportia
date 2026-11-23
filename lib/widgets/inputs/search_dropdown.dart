import 'package:flutter/material.dart';

class InputDropdownField<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final String Function(T) displayName;
  final T? selected;
  final ValueChanged<T> onChanged;

  const InputDropdownField({
    super.key,
    required this.label,
    required this.onChanged,
    required this.items,
    required this.displayName,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: selected,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      isExpanded: true,
      items: items.map((option) {
        return DropdownMenuItem<T>(
          value: option,
          child: Text(displayName(option), overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
