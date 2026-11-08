import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/api/user.dart';

class FutureRoute<T> extends StatefulWidget {
  final Future<T> Function() details;
  final Widget Function(T) build;

  const FutureRoute({super.key, required this.details, required this.build});

  @override
  State<FutureRoute<T>> createState() => _FutureRouteState<T>();
}

class _FutureRouteState<T> extends State<FutureRoute<T>> {
  late Future<T> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.details();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Failed to load: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('No data found')));
        }

        return widget.build(snapshot.data as T);
      },
    );
  }
}

void replaceQuery(BuildContext context, Map<String, dynamic> query) {
  query.removeWhere((key, value) => value == null || value == '');

  final uri = GoRouterState.of(context).uri;

  final parameters = query.map((key, value) => MapEntry(key, value.toString()));

  final newUri = uri.replace(queryParameters: parameters);

  context.replace(newUri.toString());
}

bool? getOptionalBool(String? value) {
  if (value == null) return null;
  switch (value) {
    case "true":
      return true;
    case "false":
      return false;
    default:
      return null;
  }
}

int? getOptionalInt(String? value) {
  if (value == null) return null;
  return int.tryParse(value);
}

Future<ApiBtVehicle?> getVehicle(String id) async {
  return ApiBtVehicle.get(int.parse(id));
}

Future<ApiTram?> getTram(String id) async {
  return ApiTram.get(int.parse(id));
}

Future<ApiUser?> getUser(String id) async {
  return ApiUser.get(int.parse(id));
}

Future<ApiModelBus?> getModelBus(String id) async {
  return ApiModelBus.get(int.parse(id));
}

Future<ApiUser?> getOptionalUser(String? id) async {
  if (id == null || int.tryParse(id) == null) return null;

  return ApiUser.get(int.parse(id));
}

Future<ApiFilledOutPhotoBus?> getBusPhoto(String id) async {
  return ApiFilledOutPhotoBus.fetch(int.parse(id));
}

Future<ApiBtLivery?> getOptionalLivery(String? id) async {
  if (id == null || int.tryParse(id) == null) return null;
  return ApiBtLivery.get(int.parse(id));
}

Future<ApiBtVehicleType?> getOptionalVehicleType(String? id) async {
  if (id == null || int.tryParse(id) == null) return null;
  return ApiBtVehicleType.get(int.parse(id));
}

Future<ApiTxOperator?> getOptionalOperator(String? id) async {
  if (id == null) return null;
  return ApiTxOperator.get(id);
}
