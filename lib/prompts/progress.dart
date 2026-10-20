import 'package:flutter/material.dart';

Future<T> showLoadingPrompt<T>(
  BuildContext context,
  Future<T> Function(void Function(double progress) onProgress) future, {
  Widget? title,
  Widget? message,
}) async {
  var progress = 0.0;
  StateSetter? updateDialog;

  final dialogFuture = showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => PopScope(
      canPop: false,
      child: StatefulBuilder(
        builder: (context, setState) {
          updateDialog = setState;

          return AlertDialog(
            title: title,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                message ?? const Text("Loading…"),
                const SizedBox(height: 16),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 8),
                Text("${(progress * 100).toStringAsFixed(0)}%"),
              ],
            ),
          );
        },
      ),
    ),
  );

  final navigator = Navigator.of(context, rootNavigator: true);

  try {
    final result = await future((value) {
      progress = value;
      updateDialog?.call(() {});
    });

    navigator.pop();
    await dialogFuture;
    return result;
  } catch (_) {
    navigator.pop();
    await dialogFuture;
    rethrow;
  }
}
