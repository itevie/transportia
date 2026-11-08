import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  final Widget text;
  final Widget icon;

  const IconWithText({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(children: [icon, const SizedBox(width: 8), text]);
  }
}
