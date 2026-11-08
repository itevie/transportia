import 'package:flutter/material.dart';

class EditObjectPage extends StatefulWidget {
  final String title;
  final Widget child;
  final Future<void> Function() onSave;
  final List<Widget> options;

  const EditObjectPage({
    super.key,
    required this.onSave,
    required this.title,
    required this.options,
    required this.child,
  });

  @override
  State<EditObjectPage> createState() => _EditObjectPageState();
}

class _EditObjectPageState extends State<EditObjectPage> {
  bool _isSaving = false;

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      await widget.onSave();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (var filter in widget.options) ...[
                      filter,
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 320, child: widget.child),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : _save,
          icon: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(_isSaving ? 'Saving...' : 'Save'),
        ),
      ],
    );
  }
}
