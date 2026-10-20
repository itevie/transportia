import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/util/auth.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/util_widgets/page_container.dart';
import 'package:transportia/util_widgets/sub_text.dart';

import 'package:transportia/widgets/pages/all_search_page.dart';
import 'package:transportia/widgets/pages/bus_listings.dart';
import 'package:transportia/widgets/pages/favourites_page.dart';
import 'package:transportia/widgets/pages/home.dart';
import 'package:transportia/widgets/pages/login.dart';
import 'package:transportia/widgets/pages/photo_search_page.dart';
import 'package:transportia/widgets/pages/service_checklists.dart';
import 'package:transportia/widgets/pages/upload_page.dart';
import 'package:transportia/widgets/pages/user.dart';
import 'package:transportia/widgets/pages/vehicle_search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: currentUserStore,
      child: MaterialApp.router(
        title: 'Transportia',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        routerConfig: transportiaRouter,
      ),
    );
  }
}

class AppRoute {
  final String path;
  final String name;
  final Widget Function() page;
  final bool noContainer;
  final IconData icon;

  const AppRoute({
    required this.path,
    required this.name,
    required this.page,
    required this.icon,
    this.noContainer = false,
  });
}

final appRoutes = <AppRoute>[
  AppRoute(path: '/', name: 'Home', page: () => HomePage(), icon: Icons.home),
  AppRoute(
    path: '/photos',
    name: 'Photo Search',
    page: () => PhotoSearchPage(),
    icon: Icons.photo,
  ),
  AppRoute(
    path: '/vehicles',
    name: 'Vehicles',
    page: () => VehicleSearchPage(),
    icon: Icons.directions_bus,
  ),
  AppRoute(
    path: '/model-buses',
    name: 'Model Buses',
    page: () => BusListingsPage(),
    icon: Icons.directions_bus,
  ),
  AppRoute(
    path: '/checklists',
    name: 'Your Checklists',
    page: () => ServiceChecklists(),
    icon: Icons.route,
  ),
  AppRoute(
    path: '/favourites',
    name: 'Your Favourites',
    page: () => FavouritesPage(),
    icon: Icons.favorite,
    noContainer: true,
  ),
];

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final transportiaRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return TransportiaShell(navigationShell: navigationShell);
      },
      branches: [
        for (final route in appRoutes)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: route.path,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: KeyedSubtree(
                      key: ValueKey(route.path),
                      child: route.page(),
                    ),
                  );
                },
              ),
            ],
          ),
      ],
    ),

    // Pages outside the persistent main-page navigation.
    GoRoute(path: '/search', builder: (context, state) => AllSearchPage()),
    GoRoute(path: '/upload', builder: (context, state) => UploadPage()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(
      path: '/users/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);

        // Replace this with your existing user-fetching logic.
        return UserRoutePlaceholder(userId: id);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page not found')),
    body: Center(child: Text('No page exists at ${state.uri.path}')),
  ),
);

class TransportiaShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TransportiaShell({super.key, required this.navigationShell});

  void _goTo(BuildContext context, String path) {
    Navigator.of(context).maybePop();
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<CurrentUserStore>();
    final currentPath = GoRouterState.of(context).uri.path;

    final currentRoute = appRoutes.cast<AppRoute?>().firstWhere(
      (route) => route?.path == currentPath,
      orElse: () => null,
    );

    final title = switch (currentPath) {
      '/search' => 'Search',
      '/upload' => 'Upload Photo',
      '/login' => 'Log In',
      _ => currentRoute?.name ?? 'Transportia',
    };

    final currentPage = currentRoute;
    final activeBranch = navigationShell.currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (currentPath != '/' && currentPage != null)
              IconButton(
                tooltip: 'Home',
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home),
              ),
            Expanded(child: Text(title, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () => context.go('/search'),
            icon: const Icon(Icons.search),
          ),
          const SizedBox(height: 24, child: VerticalDivider(width: 8)),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            tooltip: 'Upload',
            onPressed: () => context.go('/upload'),
            icon: const Icon(Icons.upload),
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (user.loggedIn) {
                // Use your existing UserViewer constructor here.
                context.go('/users/${user.user!.id}');
              } else {
                context.go('/login');
              }
            },
            label: Text(user.loggedIn ? 'User' : 'Log In'),
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: Text(
                'Transportia',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (var i = 0; i < appRoutes.length; i++)
                    ListTile(
                      leading: Icon(appRoutes[i].icon),
                      title: Text(appRoutes[i].name),
                      selected: activeBranch == i,
                      onTap: () => _goTo(context, appRoutes[i].path),
                    ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: SubText('You'),
            ),
            ListTile(
              leading: const Icon(Icons.route),
              title: const Text('Checklists'),
              onTap: () => _goTo(context, '/checklists'),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favourites'),
              onTap: () => _goTo(context, '/favourites'),
            ),
          ],
        ),
      ),
      body: navigationShell,
    );
  }
}

// Temporary placeholder until the existing user-fetching route is wired up.
class UserRoutePlaceholder extends StatelessWidget {
  final int userId;

  const UserRoutePlaceholder({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Connect this route to your user viewer.')),
    );
  }
}
