const paddedPaths = [
  '/upload',
  '/vehicles',
  '/vehicle',
  '/operator',
  '/photos',
  '/model-buses',
  '/checklists',
  '/checklist',
  '/user',
  '/trams',
  '/tools',
  '/model-bus-listings',
  '/tram-photos',
  '/tram-announcements',
  '/my-model-buses',
  '/model-bus-photos',
  '/model-bus',
  '/vehicle-type',
  '/tram-operator',
  '/tram',
  '/livery',
  "/search",
];

String getShellTitle(String path) {
  final basePath = getBasePath(path);

  return switch (basePath) {
    '/search' => 'Search',
    '/upload' => 'Upload Photo',
    '/login' => 'Log In',
    '/model-buses' => 'Model Buses',
    '/photos' => 'Bus Photos',
    '/checklists' => 'Your Checklists',
    '/tools' => 'Transportia Tools',
    '/vehicles' => 'Bus Search',
    '/trams' => 'Tram Search',
    '/settings' => 'Settings',
    '/tram-photos' => 'Tram Photos',
    '/tram-announcements' => 'Tram Announcements',
    '/forums' => 'Forum',
    '/favourites' => 'Favourites',
    _ => 'Transportia',
  };
}

String getBasePath(String path) {
  return '/${path.split('/').where((part) => part.isNotEmpty).firstOrNull ?? ''}';
}
