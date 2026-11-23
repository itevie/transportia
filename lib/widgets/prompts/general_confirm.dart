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

Future<bool?> showConfirmModal(
  BuildContext context, {
  required String title,
  required Widget child,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: child,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}
