import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportia/sidebar_entries.dart';
import 'package:transportia/stores/mobile_navbar.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/widgets/util/panel_with_header.dart';

class TopBarSettings extends StatefulWidget {
  const TopBarSettings({super.key});

  @override
  State<TopBarSettings> createState() => _TopBarSettingsState();
}

class _TopBarSettingsState extends State<TopBarSettings> {
  late List<SidebarEntryType> entries;

  @override
  void initState() {
    super.initState();
    entries = _loadEntries();
  }

  List<SidebarEntryType> _loadEntries() {
    final stored = Preferences().getStringList('top_bar_entries');

    if (stored == null) {
      return List.from(topBarDefaults);
    }

    return stored
        .map(
          (e) => SidebarEntryType.values.where((x) => x.name == e).firstOrNull,
        )
        .whereType<SidebarEntryType>()
        .where(
          (e) => e != SidebarEntryType.divider && sidebarEntries.containsKey(e),
        )
        .take(maxTopBarEntries)
        .toList();
  }

  Future<void> _save() async {
    await saveTopBarEntries(entries);

    if (!mounted) return;

    await context.read<MobileSidebarStore>().updateTopBarEntries(
      List.from(entries),
    );
  }

  Future<void> _toggle(SidebarEntryType entry, bool enabled) async {
    if (enabled && entries.length >= maxTopBarEntries) return;

    setState(() {
      if (enabled) {
        entries.add(entry);
      } else {
        entries.remove(entry);
      }
    });

    await _save();
  }

  Future<void> _reorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;

    setState(() {
      final item = entries.removeAt(oldIndex);
      entries.insert(newIndex, item);
    });

    await _save();
  }

  Future<void> _reset() async {
    setState(() {
      entries = List.from(topBarDefaults);
    });

    await _save();
  }

  Widget _buildEntryList() {
    final availableEntries = sidebarEntries.entries
        .where((e) => e.key != SidebarEntryType.divider)
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            '${entries.length}/$maxTopBarEntries selected. Drag to reorder.',
          ),
        ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: true,
          onReorder: _reorder,
          children: [
            for (final type in entries)
              ListTile(
                key: ValueKey(type),
                leading: Icon(sidebarEntries[type]!.icon),
                title: Text(sidebarEntries[type]!.label),
                trailing: Checkbox(
                  value: true,
                  onChanged: (value) {
                    if (value == false) {
                      _toggle(type, false);
                    }
                  },
                ),
              ),
          ],
        ),
        const Divider(),
        for (final entry in availableEntries.where(
          (entry) => !entries.contains(entry.key),
        ))
          CheckboxListTile(
            key: ValueKey('available_${entry.key}'),
            value: false,
            secondary: Icon(entry.value.icon),
            title: Text(entry.value.label),
            onChanged: (value) {
              if (value == true && entries.length < maxTopBarEntries) {
                _toggle(entry.key, true);
              }
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PanelWithHeader(
            title: 'Top Bar',
            actions: [
              IconButton(
                tooltip: 'Reset top bar',
                onPressed: _reset,
                icon: const Icon(Icons.undo),
              ),
            ],
            child: _buildEntryList(),
          ),
        ],
      ),
    );
  }
}
