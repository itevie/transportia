import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/meta.dart';
import 'package:transportia/api/tram_announcement_audios.dart';
import 'package:transportia/routing_def.dart';
import 'package:transportia/sidebar_entries.dart';

import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/stores/mobile_navbar.dart';
import 'package:transportia/util/auth.dart';
import 'package:transportia/util/mobile.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/widgets/profile_picture.dart';
import 'package:transportia/widgets/shell/mobile.dart';
import 'package:transportia/widgets/shell/util.dart';
import 'package:transportia/widgets/util/error_widget.dart';
import 'package:transportia/widgets/util/page_container.dart';
import 'package:transportia/widgets/util/sub_text.dart';
import 'package:transportia/widgets/util/toasts.dart';

String? lastUri;
String? currentUri;

late void Function(dynamic err) showError;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  await ApiTramAnnouncementAudio.init();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await checkLogin();
  try {
    await ApiMeta.instance.init();
  } catch (e) {
    print(e);
  }

  currentUri = transportiaRouter.routerDelegate.currentConfiguration.uri
      .toString();

  transportiaRouter.routerDelegate.addListener(() {
    final newUri = transportiaRouter.routerDelegate.currentConfiguration.uri
        .toString();
    print(newUri);

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentUserStore>.value(value: currentUserStore),
        ChangeNotifierProvider(create: (_) => MobileSidebarStore()),
      ],
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
    if (isMobile(context)) return MobileTransportiaShell(child: child);
    showError = (error) {
      final title = error is ApiHttpException
          ? '${(error).statusCode} - ${(error).statusMessage}'
          : 'Error';

      final message = error is ApiHttpException
          ? (error).message
          : error.toString();

      showErrorToast(context, title, message);
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
      '/model-buses' => "Model Buses",
      '/photos' => "Bus Photos",
      '/checklists' => 'Your Checklists',
      '/tools' => "Transportia Tools",
      '/vehicles' => "Bus Search",
      '/trams' => "Tram Search",
      "/settings" => "Settings",
      _ => "Transportia",
    };

    final wantsPadding = paddedPaths.contains(basePath);

    Widget makeSideBar(IconData icon, String label, String goTo) {
      return ListTile(
        leading: Icon(icon),
        title: Text(label),
        selected: basePath == goTo,
        onTap: () => _goTo(context, goTo),
      );
    }

    final sidebarEntries = getSidebarEntries();
    final topbarEntries = context.watch<MobileSidebarStore>().topBarEntries;

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
            ...topbarEntries.map((x) => x.renderButton(context)),

            // IconButton(
            //   tooltip: 'Search',
            //   onPressed: () => context.go('/search'),
            //   icon: const Icon(Icons.search),
            // ),
            // const SizedBox(height: 24, child: VerticalDivider(width: 8)),
            // if (user.loggedIn) ...[
            //   IconButton(
            //     tooltip: 'Tools',
            //     onPressed: () => context.go('/tools'),
            //     icon: const Icon(Icons.build),
            //   ),
            //   IconButton(
            //     tooltip: 'Notifications',
            //     onPressed: () {},
            //     icon: const Icon(Icons.notifications),
            //   ),
            //   IconButton(
            //     tooltip: 'Upload',
            //     onPressed: () => context.go('/upload'),
            //     icon: const Icon(Icons.upload),
            //   ),
            // ],
            ElevatedButton.icon(
              onPressed: () {
                if (user.loggedIn) {
                  context.go('/user/${user.user!.id}');
                } else {
                  context.go('/login');
                }
              },
              label: Text(user.loggedIn ? user.user?.username ?? "" : 'Log In'),
              icon: user.loggedIn
                  ? ProfilePicture(usage: ProfilePictureUsage.tiny)
                  : const Icon(Icons.login),
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
                    ...sidebarEntries.map((x) => x.renderDrawer(context)),
                    // makeSideBar(Icons.home, 'Home', '/'),
                    // makeSideBar(Icons.forum, 'Forum', '/forums'),
                    // Divider(),
                    // makeSideBar(Icons.photo, 'Bus Photos', '/photos'),
                    // makeSideBar(
                    //   Icons.directions_bus,
                    //   'Bus Search',
                    //   '/vehicles',
                    // ),
                    // Divider(),
                    // makeSideBar(Icons.tram, 'Tram Photos', '/tram-photos'),
                    // makeSideBar(Icons.tram, 'Tram Search', '/trams'),
                    // makeSideBar(
                    //   Icons.campaign,
                    //   'Tram Announcements',
                    //   '/tram-announcements',
                    // ),
                    // Divider(),
                    // makeSideBar(
                    //   Icons.directions_bus,
                    //   'Model Bus Photos',
                    //   '/model-bus-photos',
                    // ),
                    // makeSideBar(
                    //   Icons.directions_bus,
                    //   'Model Directory',
                    //   '/model-buses',
                    // ),
                    // if (user.loggedIn)
                    //   makeSideBar(
                    //     Icons.directions_bus,
                    //     'My Models',
                    //     '/my-model-buses',
                    //   ),
                    // makeSideBar(
                    //   Icons.directions_bus,
                    //   'Model Listings',
                    //   '/model-bus-listings',
                    // ),
                  ],
                ),
              ),
              if (user.loggedIn) ...[
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 16),
                  child: SubText("You"),
                ),
                makeSideBar(Icons.route, 'Checklists', '/checklists'),
                makeSideBar(Icons.favorite, 'Favourites', '/favourites'),
                makeSideBar(Icons.settings, 'Settings', '/settings'),
              ],
            ],
          ),
        ),
        body: wantsPadding ? PageContainer(child: child) : child,
      ),
    );
  }
}
