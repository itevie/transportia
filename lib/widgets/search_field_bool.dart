import 'package:flutter/material.dart';

class SearchCheckboxSelector extends StatelessWidget {
  final String label;
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onPostLoad;
  final bool tristate;

  const SearchCheckboxSelector({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.onPostLoad,
    this.tristate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          tristate: tristate,
          value: value,
          onChanged: (value) {
            onChanged(value);
            onPostLoad?.call();
          },
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
