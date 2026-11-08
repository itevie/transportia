import 'package:dawn_ui_flutter/dawn_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/widgets/util/sub_text.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PageChangeCard(
            onTap: () {
              context.go("/tools/resources");
            },
            icon: Icons.edit,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Resource Management"),
                SubText(
                  "Create, delete and update resources such as vehicles, liveries, etc.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
