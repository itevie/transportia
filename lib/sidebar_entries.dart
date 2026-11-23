import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/widgets/shell/util.dart';

enum SidebarEntryType {
  search,
  tools,
  notifications,
  upload,
  self,
  checklists,
  settings,
  favourites,
  home,
  forum,
  busPhotos,
  busSearch,
  tramPhotos,
  tramSearch,
  tramAnnouncements,
  modelBusPhotos,
  modelDirectory,
  myModels,
  modelListings,
  divider,
}

class SidebarEntry {
  final String label;
  final IconData icon;
  final String location;
  final bool loggedInOnly;

  const SidebarEntry({
    required this.label,
    required this.icon,
    required this.location,
    this.loggedInOnly = false,
  });

  String basePath(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    return getBasePath(currentPath);
  }

  void _goTo(BuildContext context, String path) {
    Navigator.of(context).pop();
    context.go(path);
  }

  bool loggedIn(BuildContext context) {
    return context.read<CurrentUserStore>().loggedIn;
  }

  Widget renderDrawer(BuildContext context) {
    if (label == "__divider") return Divider();
    if (loggedInOnly && !loggedIn(context)) return SizedBox.shrink();
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: basePath(context) == location,
      onTap: () => _goTo(context, location),
    );
  }

  Widget renderButton(BuildContext context) {
    if (loggedInOnly && !loggedIn(context)) return SizedBox.shrink();
    return IconButton(
      tooltip: label,
      onPressed: () => context.go(location),
      icon: Icon(icon),
    );
  }

  Widget renderNavigationDestination(BuildContext context) {
    if (loggedInOnly && !loggedIn(context)) return SizedBox.shrink();
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: Icon(icon),
      label: label,
    );
  }
}

final Map<SidebarEntryType, SidebarEntry> sidebarEntries = {
  SidebarEntryType.search: SidebarEntry(
    label: 'Search',
    icon: Icons.search,
    location: '/search',
  ),
  SidebarEntryType.tools: SidebarEntry(
    label: 'Tools',
    icon: Icons.build,
    location: '/tools',
    loggedInOnly: true,
  ),
  SidebarEntryType.notifications: SidebarEntry(
    label: 'Notifications',
    icon: Icons.notifications,
    location: '/notifications',
    loggedInOnly: true,
  ),
  SidebarEntryType.upload: SidebarEntry(
    label: 'Upload',
    icon: Icons.upload,
    location: '/upload',
    loggedInOnly: true,
  ),
  SidebarEntryType.self: SidebarEntry(
    label: 'My Profile',
    icon: Icons.person,
    location: '/user',
  ),
  SidebarEntryType.checklists: SidebarEntry(
    label: 'Checklists',
    icon: Icons.route,
    location: '/checklists',
    loggedInOnly: true,
  ),
  SidebarEntryType.settings: SidebarEntry(
    label: 'Settings',
    icon: Icons.settings,
    location: '/settings',
  ),
  SidebarEntryType.favourites: SidebarEntry(
    label: 'Favourites',
    icon: Icons.favorite,
    location: '/favourites',
  ),
  SidebarEntryType.home: SidebarEntry(
    label: 'Home',
    icon: Icons.home,
    location: '/',
  ),
  SidebarEntryType.forum: SidebarEntry(
    label: 'Forum',
    icon: Icons.forum,
    location: '/forums',
  ),

  // Buses
  SidebarEntryType.busPhotos: SidebarEntry(
    label: 'Bus Photos',
    icon: Icons.photo,
    location: '/photos',
  ),
  SidebarEntryType.busSearch: SidebarEntry(
    label: 'Bus Search',
    icon: Icons.directions_bus,
    location: '/vehicles',
  ),

  // Trams
  SidebarEntryType.tramPhotos: SidebarEntry(
    label: 'Tram Photos',
    icon: Icons.tram,
    location: '/tram-photos',
  ),
  SidebarEntryType.tramSearch: SidebarEntry(
    label: 'Tram Search',
    icon: Icons.tram,
    location: '/trams',
  ),
  SidebarEntryType.tramAnnouncements: SidebarEntry(
    label: 'Tram Announcements',
    icon: Icons.campaign,
    location: '/tram-announcements',
  ),

  // Model buses
  SidebarEntryType.modelBusPhotos: SidebarEntry(
    label: 'Model Bus Photos',
    icon: Icons.directions_bus,
    location: '/model-bus-photos',
  ),
  SidebarEntryType.modelDirectory: SidebarEntry(
    label: 'Model Directory',
    icon: Icons.directions_bus,
    location: '/model-buses',
  ),
  SidebarEntryType.myModels: SidebarEntry(
    label: 'My Models',
    icon: Icons.directions_bus,
    location: '/my-model-buses',
  ),
  SidebarEntryType.modelListings: SidebarEntry(
    label: 'Model Listings',
    icon: Icons.directions_bus,
    location: '/model-bus-listings',
  ),

  // Divider
  SidebarEntryType.divider: SidebarEntry(
    label: "__divider",
    icon: Icons.abc,
    location: "",
  ),
};

List<SidebarEntryType> sidebarDefaultEntries = [
  SidebarEntryType.home,
  SidebarEntryType.forum,
  SidebarEntryType.divider,
  SidebarEntryType.busPhotos,
  SidebarEntryType.busSearch,
  SidebarEntryType.divider,
  SidebarEntryType.tramPhotos,
  SidebarEntryType.tramSearch,
  SidebarEntryType.tramAnnouncements,
  SidebarEntryType.divider,
  SidebarEntryType.modelBusPhotos,
  SidebarEntryType.modelDirectory,
  SidebarEntryType.myModels,
  SidebarEntryType.modelListings,
];

List<SidebarEntry> getSidebarEntries() {
  final prefs = Preferences();

  final disabled = (prefs.getStringList("sidebar_disabled_entries") ?? [])
      .map((e) => SidebarEntryType.values.byName(e))
      .toSet();

  final enabled = sidebarDefaultEntries
      .where((x) => !disabled.contains(x))
      .toList();

  final cleaned = <SidebarEntryType>[];

  for (final entry in enabled) {
    if (entry == SidebarEntryType.divider &&
        (cleaned.isEmpty || cleaned.last == SidebarEntryType.divider)) {
      continue;
    }

    cleaned.add(entry);
  }

  if (cleaned.isNotEmpty && cleaned.last == SidebarEntryType.divider) {
    cleaned.removeLast();
  }

  return cleaned.map((e) => sidebarEntries[e]!).toList();
}

List<SidebarEntryType> mobileDefaultEntries = [
  SidebarEntryType.home,
  SidebarEntryType.busSearch,
  SidebarEntryType.search,
  SidebarEntryType.favourites,
  SidebarEntryType.settings,
];

List<SidebarEntry> getMobileSidebarEntries() {
  final prefs = Preferences();

  final stored = prefs.getStringList('mobile_sidebar_entries');

  final types = stored == null
      ? mobileDefaultEntries
      : stored
            .map(
              (e) =>
                  SidebarEntryType.values.where((x) => x.name == e).firstOrNull,
            )
            .whereType<SidebarEntryType>()
            .toList();

  return types
      .where((e) => e != SidebarEntryType.divider)
      .take(6)
      .map((e) => sidebarEntries[e]!)
      .toList();
}

Future<void> saveMobileSidebarEntries(List<SidebarEntryType> entries) async {
  await Preferences().setStringList(
    'mobile_sidebar_entries',
    entries.map((e) => e.name).toList(),
  );
}

const List<SidebarEntryType> topBarDefaults = [
  SidebarEntryType.search,
  SidebarEntryType.tools,
  SidebarEntryType.notifications,
  SidebarEntryType.upload,
];

int maxTopBarEntries = 6;

List<SidebarEntry> getTopBarEntries() {
  final stored = Preferences().getStringList('top_bar_entries');

  final types = stored == null
      ? topBarDefaults
      : stored
            .map(
              (e) =>
                  SidebarEntryType.values.where((x) => x.name == e).firstOrNull,
            )
            .whereType<SidebarEntryType>()
            .where((e) => e != SidebarEntryType.divider)
            .take(maxTopBarEntries)
            .toList();

  return types
      .where((e) => sidebarEntries.containsKey(e))
      .map((e) => sidebarEntries[e]!)
      .toList();
}

Future<void> saveTopBarEntries(List<SidebarEntryType> entries) async {
  await Preferences().setStringList(
    'top_bar_entries',
    entries.map((e) => e.name).toList(),
  );
}
