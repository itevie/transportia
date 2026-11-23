import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transportia/sidebar_entries.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/stores/mobile_navbar.dart';
import 'package:transportia/widgets/profile_picture.dart';
import 'package:transportia/widgets/shell/drawer.dart';
import 'package:transportia/widgets/shell/util.dart';
import 'package:transportia/widgets/util/page_container.dart';

class MobileTransportiaShell extends StatelessWidget {
  const MobileTransportiaShell({super.key, required this.child});

  final Widget child;

  static const _bottomDestinations = [
    _MobileDestination(
      label: 'Home',
      path: '/',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    _MobileDestination(
      label: 'Photos',
      path: '/photos',
      icon: Icons.photo_outlined,
      selectedIcon: Icons.photo,
    ),
    _MobileDestination(
      label: 'Search',
      path: '/search',
      icon: Icons.search,
      selectedIcon: Icons.search,
    ),
    _MobileDestination(
      label: 'Favourites',
      path: '/favourites',
      icon: Icons.favorite,
      selectedIcon: Icons.tram,
    ),
  ];

  int _getSelectedIndex(String path, List<SidebarEntry> destinations) {
    final basePath = getBasePath(path);

    final index = destinations.indexWhere(
      (destination) => destination.location == basePath,
    );

    return index < 0 ? 0 : index;
  }

  void _goTo(BuildContext context, String path) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<CurrentUserStore>();
    final currentPath = GoRouterState.of(context).uri.path;
    final basePath = getBasePath(currentPath);

    final title = getShellTitle(currentPath);

    final wantsPadding = paddedPaths.contains(basePath);

    final mobileNavbar = context.watch<MobileSidebarStore>().entries;
    final topbarEntries = context.watch<MobileSidebarStore>().topBarEntries;
    final selectedIndex = _getSelectedIndex(currentPath, mobileNavbar);

    return Scaffold(
      appBar: AppBar(
        title: Text(title, overflow: TextOverflow.ellipsis),
        actions: [
          ...topbarEntries.map((x) => x.renderButton(context)),
          // IconButton(
          //   tooltip: 'Notifications',
          //   onPressed: user.loggedIn ? () {} : null,
          //   icon: const Icon(Icons.notifications_outlined),
          // ),
          // if (user.loggedIn)
          //   IconButton(
          //     tooltip: 'Upload photo',
          //     onPressed: () => context.go('/upload'),
          //     icon: const Icon(Icons.upload_outlined),
          //   ),
          IconButton(
            tooltip: user.loggedIn ? 'Your profile' : 'Log in',
            onPressed: () {
              if (user.loggedIn) {
                context.go('/user/${user.user!.id}');
              } else {
                context.go('/login');
              }
            },
            icon: user.loggedIn
                ? ProfilePicture(usage: ProfilePictureUsage.tiny)
                : const Icon(Icons.account_circle_outlined),
          ),
          // const SizedBox(width: 4),
        ],
      ),

      drawer: ShellDrawer(
        currentPath: currentPath,
        userLoggedIn: user.loggedIn,
        onNavigate: (path) => _goTo(context, path),
      ),

      body: wantsPadding ? PageContainer(child: child) : child,

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          context.go(mobileNavbar[index].location);
        },
        destinations: [
          for (final destination in mobileNavbar)
            destination.renderNavigationDestination(context),
        ],
      ),
    );
  }
}

class _MobileDestination {
  final String label;
  final String path;
  final IconData icon;
  final IconData selectedIcon;

  const _MobileDestination({
    required this.label,
    required this.path,
    required this.icon,
    required this.selectedIcon,
  });
}
