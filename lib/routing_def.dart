import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/route_checklist.dart';
import 'package:transportia/main.dart';
import 'package:transportia/routing.dart';
import 'package:transportia/widgets/pages/edit/model_bus.dart';
import 'package:transportia/widgets/pages/edit/tram_operator.dart';
import 'package:transportia/widgets/pages/edit/tram_type.dart';
import 'package:transportia/widgets/pages/search/all_search_page.dart';
import 'package:transportia/widgets/pages/search/bus_listings.dart';
import 'package:transportia/widgets/pages/object/bus_photo.dart';
import 'package:transportia/widgets/pages/edit/tram.dart';
import 'package:transportia/widgets/pages/edit/vehicle.dart';
import 'package:transportia/widgets/pages/favourites_page.dart';
import 'package:transportia/widgets/pages/home.dart';
import 'package:transportia/widgets/pages/login.dart';
import 'package:transportia/widgets/pages/object/operator_page.dart';
import 'package:transportia/widgets/pages/search/model_buses.dart';
import 'package:transportia/widgets/pages/search/photo_search_page.dart';
import 'package:transportia/widgets/pages/service_checklist.dart';
import 'package:transportia/widgets/pages/service_checklists.dart';
import 'package:transportia/widgets/pages/tools/tools.dart';
import 'package:transportia/widgets/pages/tools/tools_resources.dart';
import 'package:transportia/widgets/pages/tools/tools_tram_operators.dart';
import 'package:transportia/widgets/pages/tools/tools_tram_type.dart';
import 'package:transportia/widgets/pages/tools/tools_trams.dart';
import 'package:transportia/widgets/pages/search/trams.dart';
import 'package:transportia/widgets/pages/upload_page.dart';
import 'package:transportia/widgets/pages/object/user.dart';
import 'package:transportia/widgets/pages/object/vehicle_page.dart';
import 'package:transportia/widgets/pages/search/vehicle_search.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final transportiaRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return TransportiaShell(child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => HomePage()),
        GoRoute(path: '/search', builder: (context, state) => AllSearchPage()),
        GoRoute(path: '/upload', builder: (context, state) => UploadPage()),
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),
        GoRoute(path: '/tools', builder: (context, state) => ToolsPage()),
        GoRoute(
          path: '/tools/resources',
          builder: (context, state) => ToolResourcesPage(),
        ),
        GoRoute(
          path: '/tools/resources/trams',
          builder: (context, state) => ToolsTramPage(),
        ),
        GoRoute(
          path: '/tools/resources/tram-types',
          builder: (context, state) => ToolTramTypesPage(),
        ),
        GoRoute(
          path: '/tools/resources/tram-operators',
          builder: (context, state) => ToolTramOperatorsPage(),
        ),
        GoRoute(path: "/trams", builder: (context, state) => TramsSearchPage()),
        GoRoute(
          path: "/trams/create",
          builder: (context, state) => TramEditPage(),
        ),

        GoRoute(
          path: '/trams/:id/edit',
          builder: (context, state) => FutureRoute(
            details: () => getTram(state.pathParameters['id']!),
            build: (data) => TramEditPage(tram: data!),
          ),
        ),
        GoRoute(
          path: "/tram-types/create",
          builder: (context, state) => TramTypeEditPage(),
        ),
        GoRoute(
          path: "/tram-operators/create",
          builder: (context, state) => TramOperatorEditPage(),
        ),
        GoRoute(
          path: '/photos',
          builder: (context, state) => FutureRoute(
            details: () async {
              final query = state.uri.queryParameters['query'];
              final livery = await getOptionalLivery(
                state.uri.queryParameters['livery'],
              );
              final vt = await getOptionalVehicleType(
                state.uri.queryParameters['vt'],
              );
              final operator = await getOptionalOperator(
                state.uri.queryParameters['operator'],
              );
              final author = await getOptionalUser(
                state.uri.queryParameters['author'],
              );

              return (
                query: query,
                livery: livery,
                vt: vt,
                operator: operator,
                author: author,
              );
            },
            build: (data) => PhotoSearchPage(
              query: data.query,
              livery: data.livery,
              vehicleType: data.vt,
              author: data.author,
            ),
          ),
        ),
        GoRoute(
          path: '/user/:id',
          builder: (context, state) => FutureRoute(
            details: () => getUser(state.pathParameters['id']!),
            build: (data) => UserViewer(user: data!),
          ),
        ),
        GoRoute(
          path: '/vehicle/:id',
          builder: (context, state) => FutureRoute(
            details: () => getVehicle(state.pathParameters['id']!),
            build: (data) => VehiclePage(vehicle: data!),
          ),
        ),
        GoRoute(
          path: '/vehicle/:id/edit',
          builder: (context, state) => FutureRoute(
            details: () => getVehicle(state.pathParameters['id']!),
            build: (data) => VehicleEditPage(vehicle: data!),
          ),
        ),
        GoRoute(
          path: '/photo/:id',
          builder: (context, state) => FutureRoute(
            details: () => getBusPhoto(state.pathParameters['id']!),
            build: (data) => BusPhotoViewer(photo: data!),
          ),
        ),
        GoRoute(
          path: '/vehicles',
          builder: (context, state) => FutureRoute(
            details: () async {
              final q = state.uri.queryParameters;

              return (
                query: q['query'],
                livery: await getOptionalLivery(q['livery']),
                vt: await getOptionalVehicleType(q['vt']),
                operator: await getOptionalOperator(q['operator']),
                electric: getOptionalBool(q["electric"]),
                coach: getOptionalBool(q["coach"]),
                doubleDecker: getOptionalBool(q["double_decker"]),
                hasImage: getOptionalBool(q["has_image"]),
                withdrawn: getOptionalBool(q["withdrawn"]),
                offset: getOptionalInt(q["offset"]),
              );
            },
            build: (data) => VehicleSearchPage(
              query: data.query,
              livery: data.livery,
              vehicleType: data.vt,
              operator: data.operator,
              withdrawn: data.withdrawn,
              coach: data.coach,
              electric: data.electric,
              doubleDecker: data.doubleDecker,
              hasImage: data.hasImage,
              offset: data.offset,
            ),
          ),
        ),
        GoRoute(
          path: '/operator/:id',
          builder: (context, state) => FutureRoute(
            details: () async {
              debugPrint("Test");
              //TODO: Fix this optional
              final operator = await getOptionalOperator(
                state.pathParameters['id'],
              );

              return (operator: operator);
            },
            build: (data) => OperatorPage(operator: data.operator!),
          ),
        ),
        GoRoute(
          path: '/model-bus-listings',
          builder: (context, state) => BusListingsPage(),
        ),
        GoRoute(
          path: '/model-buses',
          builder: (context, state) => ModelBusSearchPage(),
        ),
        GoRoute(
          path: '/model-buses/create',
          builder: (context, state) => ModelBusEditPage(),
        ),
        GoRoute(
          path: '/model-bus/:id/edit',
          builder: (context, state) => FutureRoute(
            details: () => getModelBus(state.pathParameters['id']!),
            build: (data) => ModelBusEditPage(modelBus: data!),
          ),
        ),
        GoRoute(
          path: '/checklists',
          builder: (context, state) => ServiceChecklists(),
        ),
        GoRoute(
          path: '/checklist/:id',
          builder: (context, state) => FutureRoute(
            details: () =>
                ApiRouteChecklist.fetch(int.parse(state.pathParameters["id"]!)),
            build: (data) => ServiceChecklist(checklist: data),
          ),
        ),
        GoRoute(
          path: '/favourites',
          builder: (context, state) => FavouritesPage(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page not found')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('No page exists at ${state.uri.path}'),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              context.go("/");
            },
            label: Text("Home"),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
    ),
  ),
);
