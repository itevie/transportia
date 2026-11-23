import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast(
  BuildContext context, {
  required Widget title,
  required Widget description,
  ToastificationType type = ToastificationType.info,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final isDark = theme.brightness == Brightness.dark;

  final primaryColor = switch (type) {
    ToastificationType.success => colorScheme.primary,
    ToastificationType.error => colorScheme.error,
    ToastificationType.warning => colorScheme.tertiary,
    ToastificationType.info => colorScheme.secondary,
    _ => colorScheme.primary,
  };

  toastification.show(
    context: context,
    title: title,
    description: description,
    type: type,
    style: ToastificationStyle.flat,
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 3),

    backgroundColor: colorScheme.surface,
    foregroundColor: colorScheme.onSurface,
    primaryColor: primaryColor,

    animationDuration: const Duration(milliseconds: 300),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

void showSuccessToast(BuildContext context, String message) {
  showToast(
    context,
    title: const Text('Success!'),
    description: Text(message),
    type: ToastificationType.success,
  );
}

void showErrorToast(BuildContext context, String? title, String message) {
  showToast(
    context,
    title: Text(title ?? 'Error'),
    description: Text(message),
    type: ToastificationType.error,
  );
}
