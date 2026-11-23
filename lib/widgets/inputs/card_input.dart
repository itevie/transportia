import 'package:flutter/material.dart';
import 'package:transportia/widgets/util/sub_text.dart';

class CardInput extends StatelessWidget {
  final IconData? icon;
  final Widget label;
  final String? description;
  final Widget input;
  const CardInput({
    super.key,
    this.icon,
    required this.label,
    required this.input,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsetsGeometry.all(4),
        child: Row(
          children: [
            if (icon != null) ...[Icon(icon), const SizedBox(width: 8)],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label,
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    SubText(description!),
                  ],
                ],
              ),
            ),
            input,
          ],
        ),
      ),
    );
  }
}
