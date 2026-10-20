import 'package:flutter/material.dart';

class SubText extends StatelessWidget {
  final String text;

  const SubText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
    );
  }
}
