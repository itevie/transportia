import 'package:flutter/material.dart';
import 'package:transportia/sidebar_entries.dart';
import 'package:transportia/util/prefs.dart';

class MobileSidebarStore extends ChangeNotifier {
  List<SidebarEntry> _entries = getMobileSidebarEntries();

  List<SidebarEntry> get entries => _entries;

  Future<void> updateEntries(List<SidebarEntryType> types) async {
    final prefs = Preferences();

    await prefs.setStringList(
      'mobile_sidebar_entries',
      types.map((e) => e.name).toList(),
    );

    _entries = types
        .where((e) => e != SidebarEntryType.divider)
        .where((e) => sidebarEntries.containsKey(e))
        .map((e) => sidebarEntries[e]!)
        .toList();

    notifyListeners();
  }

  List<SidebarEntry> _topBarEntries = getTopBarEntries();

  List<SidebarEntry> get topBarEntries => _topBarEntries;

  Future<void> updateTopBarEntries(List<SidebarEntryType> types) async {
    _topBarEntries = types
        .where((e) => e != SidebarEntryType.divider)
        .where((e) => sidebarEntries.containsKey(e))
        .map((e) => sidebarEntries[e]!)
        .toList();

    notifyListeners();
  }
}
