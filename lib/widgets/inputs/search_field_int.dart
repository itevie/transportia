import 'package:flutter/material.dart';

class InputIntField extends StatelessWidget {
  final String label;
  final int? value;
  final ValueChanged<int?> onChanged;
  final VoidCallback? onPostLoad;
  final int? min;
  final int? max;

  const InputIntField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.onPostLoad,
    this.min,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value?.toString(),
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: false,
      ),
      decoration: InputDecoration(labelText: label),
      onChanged: (input) {
        final parsed = int.tryParse(input);

        if (parsed == null) {
          if (input.isEmpty) {
            onChanged(null);
          }
          return;
        }

        final clamped = parsed.clamp(min ?? -2147483648, max ?? 2147483647);

        onChanged(clamped);
        onPostLoad?.call();
      },
    );
  }
}
