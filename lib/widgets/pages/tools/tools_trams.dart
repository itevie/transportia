import 'package:flutter/material.dart';

class ToolsTramPage extends StatelessWidget {
  const ToolsTramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: SearchBar()),
            const SizedBox(width: 8),
            IconButton.filled(onPressed: () {}, icon: const Icon(Icons.add)),
          ],
        ),
      ],
    );
  }
}
