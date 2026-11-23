import 'package:flutter/material.dart';
import 'package:transportia/api/user.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/widgets/inputs/card_input.dart';

class DeveloperSettingsPage extends StatefulWidget {
  const DeveloperSettingsPage({super.key});

  @override
  State<DeveloperSettingsPage> createState() => _DeveloperSettingsPageState();
}

class _DeveloperSettingsPageState extends State<DeveloperSettingsPage> {
  bool developerMode = false;

  @override
  void initState() {
    super.initState();

    final prefs = Preferences();
    developerMode = prefs.getBool("developer_mode");
  }

  void save() async {
    final prefs = Preferences();

    prefs.setBool("developer_mode", developerMode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardInput(
          label: Text("Debug Mode"),
          description: "Show features such as 'Copy ID' on context menus.",
          icon: Icons.developer_board,
          input: Checkbox(
            value: developerMode,
            onChanged: (v) {
              setState(() {
                developerMode = v ?? false;
              });

              save();
            },
          ),
        ),
      ],
    );
  }
}
