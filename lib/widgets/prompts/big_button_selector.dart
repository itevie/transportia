import 'package:flutter/material.dart';

class BigButtonOption {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const BigButtonOption({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}

Future<void> showBigButtonPrompt(
  BuildContext context,
  String label,
  List<BigButtonOption> options,
) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(label),
        content: SizedBox(
          width: 320,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
            children: options.map((option) {
              return FilledButton.tonal(
                onPressed: () {
                  Navigator.pop(context);
                  option.onPressed();
                },
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(option.icon, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      option.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}
