import 'package:flutter/material.dart';
import 'package:transportia/util_widgets/panel.dart';

class PanelWithHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget child;

  const PanelWithHeader({
    super.key,
    required this.title,
    this.actions,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.directional(
              start: 12,
              top: 12,
              end: 12,
              bottom: 6,
            ),
            child: Row(
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                if (actions != null) ...[const Spacer(), ...actions!],
              ],
            ),
          ),
          Divider(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
