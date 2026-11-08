import 'package:flutter/material.dart';

class CenterPageContainer extends StatelessWidget {
  final Widget child;
  const CenterPageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    const double padding = 32;
    return Center(
      child: SizedBox(
        width: 300 + padding,
        child: Card(
          child: Padding(
            padding: EdgeInsetsGeometry.all(padding),
            child: child,
          ),
        ),
      ),
    );
  }
}
