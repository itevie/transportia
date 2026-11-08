import 'package:dawn_ui_flutter/dawn_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/widgets/util/sub_text.dart';

class ToolResourcesPage extends StatelessWidget {
  const ToolResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubText("Trams"),
          PageChangeCard(
            onTap: () {},
            icon: Icons.tram,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tram Liveries"),
                SubText("Manage tram liveries and their display image"),
              ],
            ),
          ),
          PageChangeCard(
            onTap: () {
              context.go("/tools/resources/tram-types");
            },
            icon: Icons.tram,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tram Types"),
                SubText("The actual model / type of the tram"),
              ],
            ),
          ),
          PageChangeCard(
            onTap: () {
              context.go("/tools/resources/tram-operators");
            },
            icon: Icons.tram,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tram Operators"),
                SubText(
                  "Operators of trams linked to the tram itself, such as Metrolink",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
