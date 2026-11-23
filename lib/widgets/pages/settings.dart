import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/widgets/pages/settings_pages/developer.dart';
import 'package:transportia/widgets/pages/settings_pages/mobile_navbar.dart';
import 'package:transportia/widgets/pages/settings_pages/sidebar.dart';
import 'package:transportia/widgets/pages/settings_pages/topbar_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

enum SettingsPageType {
  account,
  privacy,
  sidebar,
  mobileNavbar,
  topbar,
  appearance,
  copyright,
  developer,
  logout,
  notifications,
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsPageType page = SettingsPageType.account;

  Widget makeSideBar(IconData icon, SettingsPageType id, String label) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: page == id,
      onTap: () {
        setState(() {
          page = id;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: ListView(
            children: [
              makeSideBar(Icons.person, SettingsPageType.account, "Account"),
              makeSideBar(
                Icons.privacy_tip,
                SettingsPageType.privacy,
                "Privacy",
              ),
              Divider(),
              makeSideBar(
                Icons.palette,
                SettingsPageType.appearance,
                "Appearance",
              ),
              Divider(),

              makeSideBar(
                Icons.view_sidebar,
                SettingsPageType.sidebar,
                "Sidebar",
              ),
              makeSideBar(Icons.web_asset, SettingsPageType.topbar, "Top Bar"),
              makeSideBar(
                Icons.phone_android,
                SettingsPageType.mobileNavbar,
                "Mobile Navbar",
              ),
              Divider(),
              makeSideBar(
                Icons.notifications,
                SettingsPageType.notifications,
                "Notifications",
              ),
              makeSideBar(
                Icons.copyright,
                SettingsPageType.copyright,
                "Your Copyright",
              ),
              Divider(),
              makeSideBar(
                Icons.developer_board,
                SettingsPageType.developer,
                "Developer",
              ),
              Divider(),
              makeSideBar(Icons.logout, SettingsPageType.logout, "Logout"),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: switch (page) {
              SettingsPageType.developer => DeveloperSettingsPage(),
              SettingsPageType.sidebar => SidebarSettingsPage(),
              SettingsPageType.mobileNavbar => MobileSidebarSettings(),
              SettingsPageType.topbar => TopBarSettings(),
              SettingsPageType.logout => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Are you sure you want to logout?"),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final currentUser = context.read<CurrentUserStore>();

                        await currentUser.logout();
                        context.go("/");
                      },
                      label: Text("Logout"),
                      icon: const Icon(Icons.logout),
                    ),
                  ],
                ),
              ),
              _ => Center(child: Text("No settings page for $page")),
            },
          ),
        ),
      ],
    );
  }
}
