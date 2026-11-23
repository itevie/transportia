import 'package:flutter/material.dart';

class ShellDrawer extends StatelessWidget {
  const ShellDrawer({
    super.key,
    required this.currentPath,
    required this.userLoggedIn,
    required this.onNavigate,
  });

  final String currentPath;
  final bool userLoggedIn;
  final ValueChanged<String> onNavigate;

  String get basePath {
    return '/${currentPath.split('/').where((part) => part.isNotEmpty).firstOrNull ?? ''}';
  }

  Widget _item(BuildContext context, IconData icon, String label, String path) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: basePath == path,
      onTap: () => onNavigate(path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: null,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 24, 16, 16),
          child: Text(
            'Transportia',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        _item(context, Icons.home, 'Home', '/'),
        _item(context, Icons.forum, 'Forum', '/forums'),

        const Divider(),

        _item(context, Icons.photo, 'Bus Photos', '/photos'),
        _item(context, Icons.directions_bus, 'Bus Search', '/vehicles'),

        const Divider(),

        _item(context, Icons.tram, 'Tram Photos', '/tram-photos'),
        _item(context, Icons.tram, 'Tram Search', '/trams'),
        _item(
          context,
          Icons.campaign,
          'Tram Announcements',
          '/tram-announcements',
        ),

        const Divider(),

        _item(
          context,
          Icons.directions_bus,
          'Model Bus Photos',
          '/model-bus-photos',
        ),
        _item(context, Icons.directions_bus, 'Model Directory', '/model-buses'),

        if (userLoggedIn)
          _item(context, Icons.directions_bus, 'My Models', '/my-model-buses'),

        _item(
          context,
          Icons.storefront,
          'Model Listings',
          '/model-bus-listings',
        ),

        if (userLoggedIn) ...[
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 12, 16, 4),
            child: Text('You'),
          ),
          _item(context, Icons.route, 'Checklists', '/checklists'),
          _item(context, Icons.favorite, 'Favourites', '/favourites'),
          _item(context, Icons.build, 'Tools', '/tools'),
          _item(context, Icons.settings, 'Settings', '/settings'),
        ],
      ],
    );
  }
}
