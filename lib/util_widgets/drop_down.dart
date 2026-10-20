import 'package:flutter/material.dart';

class TDropDownMenu extends StatelessWidget {
  final Widget child;
  final Map<String, VoidCallback> options;
  final double mobileBreakpoint;

  const TDropDownMenu({
    super.key,
    required this.child,
    required this.options,
    this.mobileBreakpoint = 600,
  });

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 8),
            children: options.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                onTap: () {
                  Navigator.pop(context);
                  entry.value();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < mobileBreakpoint;

    if (isMobile) {
      return GestureDetector(
        onTap: () => _showBottomSheet(context),
        child: IgnorePointer(child: child),
      );
    }

    return PopupMenuButton<String>(
      onSelected: (value) => options[value]?.call(),
      itemBuilder: (context) => options.keys
          .map((name) => PopupMenuItem<String>(value: name, child: Text(name)))
          .toList(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: IgnorePointer(child: child),
      ),
    );
  }
}
