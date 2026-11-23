import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:transportia/sidebar_entries.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/widgets/util/panel_with_header.dart';

class SidebarSettingsPage extends StatefulWidget {
  const SidebarSettingsPage({super.key});

  @override
  State<SidebarSettingsPage> createState() => _SidebarSettingsPageState();
}

class _SidebarSettingsPageState extends State<SidebarSettingsPage> {
  List<SidebarEntryType> disabled = [];

  @override
  void initState() {
    super.initState();

    final prefs = Preferences();
    disabled = (prefs.getStringList("sidebar_disabled_entries") ?? [])
        .map((e) => SidebarEntryType.values.byName(e))
        .toList();
  }

  void save() async {
    final prefs = Preferences();
    await prefs.setStringList(
      "sidebar_disabled_entries",
      disabled.map((x) => x.name).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = sidebarDefaultEntries
        .where((x) => x != SidebarEntryType.divider)
        .map((x) => (x, sidebarEntries[x]))
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanelWithHeader(
            title: "Sidebar Entries",
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...entries.map(
                  (x) => ListTile(
                    title: Text(x.$2!.label),
                    leading: Icon(x.$2!.icon),
                    trailing: Checkbox(
                      value: !disabled.contains(x.$1),
                      onChanged: (v) {
                        setState(() {
                          if (v == false && !disabled.contains(x.$1)) {
                            disabled.add(x.$1);
                          } else {
                            disabled.remove(x.$1);
                          }
                        });

                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          save();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
