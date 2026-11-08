import 'package:flutter/material.dart';

class DetailChip extends StatelessWidget {
  final Widget contents;
  final IconData icon;
  final VoidCallback? onClick;

  const DetailChip({
    super.key,
    required this.contents,
    required this.icon,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onClick ?? () {},
        icon: Icon(icon),
        label: contents,
        style:
            OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
              side: BorderSide.none,
              alignment: Alignment.centerLeft,
            ).copyWith(
              side: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.focused) ||
                    states.contains(WidgetState.pressed)) {
                  return BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  );
                }
                return BorderSide.none;
              }),
            ),
      ),
    );
  }
}
