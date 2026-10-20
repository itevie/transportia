import 'package:flutter/material.dart';

class SearchSelectionField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final Future<T?> Function({required BuildContext context}) onSearch;
  final String Function(T value) displayValue;
  final ValueChanged<T?> onChanged;

  const SearchSelectionField({
    super.key,
    required this.label,
    required this.value,
    required this.onSearch,
    required this.displayValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return ElevatedButton.icon(
        onPressed: () async {
          final result = await onSearch(context: context);

          if (result == null) return;

          onChanged(result);
        },
        label: Text(label),
        icon: const Icon(Icons.add),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                displayValue(value as T),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            onChanged(null);
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
