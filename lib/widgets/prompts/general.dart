import 'package:flutter/material.dart';

Future<void> showGeneralModal(
  BuildContext context, {
  required String title,
  required Widget child,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: child,
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
