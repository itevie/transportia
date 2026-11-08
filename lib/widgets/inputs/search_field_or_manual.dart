import 'package:flutter/material.dart';

class InputSelectionOrManualField<T> extends StatefulWidget {
  final String label;
  final T? value;
  final TextEditingController manualValue;
  final Future<T?> Function({required BuildContext context}) onSearch;
  final String Function(T value) displayValue;
  final ValueChanged<T?> onChanged;
  final ValueChanged<String> onManualChanged;

  const InputSelectionOrManualField({
    super.key,
    required this.label,
    required this.value,
    required this.onSearch,
    required this.displayValue,
    required this.onChanged,
    required this.onManualChanged,
    required this.manualValue,
  });

  @override
  State<InputSelectionOrManualField<T>> createState() =>
      _InputSelectionOrManualFieldState<T>();
}

class _InputSelectionOrManualFieldState<T>
    extends State<InputSelectionOrManualField<T>> {
  bool? isManual;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: true,
              label: Text('Manual'),
              icon: Icon(Icons.edit),
            ),
            ButtonSegment(
              value: false,
              label: Text('Search'),
              icon: Icon(Icons.search),
            ),
          ],
          selected: {isManual ?? false},
          onSelectionChanged: (selection) {
            setState(() {
              isManual = selection.first;
            });
          },
        ),

        const SizedBox(height: 12),

        if (isManual == true)
          TextField(
            controller: widget.manualValue,
            decoration: InputDecoration(
              hintText: 'Enter ${widget.label.toLowerCase()}',
              border: const OutlineInputBorder(),
            ),
            onChanged: widget.onManualChanged,
          )
        else
          _buildSearch(),
      ],
    );
  }

  Widget _buildSearch() {
    if (widget.value == null) {
      return ElevatedButton.icon(
        onPressed: () async {
          final result = await widget.onSearch(context: context);

          if (result == null) return;

          widget.onChanged(result);
        },
        label: Text('Search ${widget.label}'),
        icon: const Icon(Icons.search),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            widget.displayValue(widget.value as T),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          onPressed: () {
            widget.onChanged(null);
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
