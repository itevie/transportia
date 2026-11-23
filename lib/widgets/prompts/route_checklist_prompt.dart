import 'package:flutter/material.dart';

Future<String?> showRouteChecklistPrompt(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add to Checklist"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => Navigator.pop(context, "Operator"),
              child: const Text("Operator"),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.pop(context, "Service"),
              child: const Text("Service"),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.pop(context, "Preset"),
              child: const Text("Preset"),
            ),
          ],
        ),
      );
    },
  );
}
