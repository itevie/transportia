import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/meta.dart';
import 'package:transportia/routing_def.dart';

import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/util/auth.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/widgets/util/page_container.dart';
import 'package:transportia/widgets/util/sub_text.dart';

String? lastUri;
String? currentUri;

late void Function(String err) showError;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await checkLogin();
  await ApiMeta.instance.init();

  currentUri = transportiaRouter.routerDelegate.currentConfiguration.uri
      .toString();

  transportiaRouter.routerDelegate.addListener(() {
    final newUri = transportiaRouter.routerDelegate.currentConfiguration.uri
        .toString();

    if (newUri != currentUri) {
      lastUri = currentUri;
      currentUri = newUri;
    }
  });

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

class TransportiaShell extends StatelessWidget {
  final Widget child;

  const TransportiaShell({super.key, required this.child});

  void _goTo(BuildContext context, String path) {
    Navigator.of(context).pop();
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    showError = (error) {
      showErrorPrompt(context, error);
    };

    final user = context.watch<CurrentUserStore>();
    final currentPath = GoRouterState.of(context).uri.path;
    final basePath =
        '/${currentPath.split('/').where((part) => part.isNotEmpty).firstOrNull ?? ''}';

    // final currentRoute = appRoutes.cast<AppRoute?>().firstWhere(
    //   (route) => route?.path == currentPath,
    //   orElse: () => null,
    // );

    final title = switch (currentPath) {
      '/search' => 'Search',
      '/upload' => 'Upload Photo',
      '/login' => 'Log In',
      _ => "Transportia",
      // _ => currentRoute?.name ?? 'Transportia',
    };

    final wantsPadding = [
      "/upload",
      "/vehicles",
      "/vehicle",
      "/operator",
      "/photos",
      "/model-buses",
      "/checklists",
      "/checklist",
      "/user",
      "/trams",
      "/tools",
    ].contains(basePath);

    // final currentPage = currentRoute;
    // final activeBranch = navigationShell.currentIndex;
    return Listener(
      onPointerDown: (event) {
        if (defaultTargetPlatform != TargetPlatform.linux) return;
        if (event.buttons == kBackMouseButton) {
          if (context.canPop()) {
            context.pop();
          }
        } else if (event.buttons == kForwardMouseButton) {
          // Optional: handle forward navigation separately.
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              // if (currentPath != '/' && currentPage != null)
              //   IconButton(
              //     tooltip: 'Home',
              //     onPressed: () => context.go('/'),
              //     icon: const Icon(Icons.home),
              //   ),
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
            if (user.loggedIn) ...[
              IconButton(
                tooltip: 'Tools',
                onPressed: () => context.go('/tools'),
                icon: const Icon(Icons.build),
              ),
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
            ],
            ElevatedButton.icon(
              onPressed: () {
                if (user.loggedIn) {
                  context.go('/user/${user.user!.id}');
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
              Expanded(
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
                      child: Text(
                        'Transportia',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Home'),
                      onTap: () => _goTo(context, '/'),
                    ),
                    Divider(),
                    ListTile(
                      leading: const Icon(Icons.photo),
                      title: const Text('Bus Photos'),
                      onTap: () => _goTo(context, '/photos'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.directions_bus),
                      title: const Text('Bus Search'),
                      onTap: () => _goTo(context, '/vehicles'),
                    ),
                    Divider(),
                    ListTile(
                      leading: const Icon(Icons.photo),
                      title: const Text('Tram Photos'),
                      onTap: () => _goTo(context, '/trams'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.tram),
                      title: const Text('Tram Search'),
                      onTap: () => _goTo(context, '/trams'),
                    ),
                    Divider(),
                    ListTile(
                      leading: const Icon(Icons.directions_bus),
                      title: const Text('Model Listings'),
                      onTap: () => _goTo(context, '/model-bus-listings'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.directions_bus),
                      title: const Text('Model Directory'),
                      onTap: () => _goTo(context, '/model-buses'),
                    ),
                    if (user.loggedIn)
                      ListTile(
                        leading: const Icon(Icons.directions_bus),
                        title: const Text('My Models'),
                        onTap: () => _goTo(context, '/model-buses'),
                      ),
                  ],
                ),
              ),
              if (user.loggedIn) ...[
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 16),
                  child: SubText("You"),
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
            ],
          ),
        ),
        body: wantsPadding ? PageContainer(child: child) : child,
      ),
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
