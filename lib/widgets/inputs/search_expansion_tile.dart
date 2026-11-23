import 'package:flutter/material.dart';

class InputExpansionField<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final String Function(T) displayName;
  final T? selected;
  final ValueChanged<T> onChanged;

  const InputExpansionField({
    super.key,
    required this.label,
    required this.onChanged,
    required this.items,
    required this.displayName,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(label),
      initiallyExpanded: false,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      children: items
          .map(
            (option) => CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(displayName(option)),
              value: selected == option,
              onChanged: (_) {
                onChanged(option);
              },
            ),
          )
          .toList(),
    );
  }
}
