import 'package:flutter/material.dart';
import 'package:transportia/theme.dart';

class Panel extends StatelessWidget {
  final Widget child;
  const Panel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsetsGeometry.all(panelPadding),
        child: child,
      ),
    );
  }
}
