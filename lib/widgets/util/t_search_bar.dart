import 'dart:async';
import 'package:flutter/material.dart';

class TSearchBar extends StatefulWidget {
  final String hintText;
  final String? presetValue;
  final ValueChanged<String> onChanged;

  const TSearchBar({
    super.key,
    required this.hintText,
    this.presetValue,
    required this.onChanged,
  });

  @override
  State<TSearchBar> createState() => _TSearchBarState();
}

class _TSearchBarState extends State<TSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.presetValue ?? "");
  }

  @override
  void didUpdateWidget(covariant TSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.presetValue != widget.presetValue &&
        widget.presetValue != _controller.text) {
      _controller.text = widget.presetValue ?? "";
    }
  }

  void _onChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      widget.onChanged(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
