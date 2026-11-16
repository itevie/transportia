import 'package:transportia/api/api.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/constants.dart';

class ApiBusPhotoDetails {
  final int photoId;

  final int id;
  final int? matchedVehicleId;
  final ApiBtVehicle? matchedVehicle;
  final bool overrideMatch;
  final String? reg;
  final String? fleet;
  final int? liveryId;
  final ApiBtLivery? livery;
  final int? vehicleTypeId;
  final ApiBtVehicleType? vehicleType;
  final String? routeId;
  final ApiTxLine? route;

  String? get dReg => overrideMatch
      ? (reg ?? matchedVehicle?.reg)
      : (matchedVehicle?.reg ?? reg);

  String? get dFleet => overrideMatch
      ? (fleet ?? matchedVehicle?.fleet)
      : (matchedVehicle?.fleet ?? fleet);

  ApiBtLivery? get dLivery => overrideMatch
      ? (livery ?? matchedVehicle?.livery)
      : (matchedVehicle?.livery ?? livery);

  ApiBtVehicleType? get dVehicleType => overrideMatch
      ? (vehicleType ?? matchedVehicle?.vehicleType)
      : (matchedVehicle?.vehicleType ?? vehicleType);

  ApiBusPhotoDetails({
    required this.id,
    required this.matchedVehicleId,
    required this.matchedVehicle,
    required this.overrideMatch,
    required this.reg,
    required this.fleet,
    required this.liveryId,
    required this.livery,
    required this.vehicleTypeId,
    required this.vehicleType,
    required this.routeId,
    required this.route,
    required this.photoId,
  });

  factory ApiBusPhotoDetails.fromJson(Map<String, dynamic> json, int photoId) {
    return ApiBusPhotoDetails(
      photoId: photoId,
      id: json["id"],
      matchedVehicleId: json["matched_vehicle_id"],
      matchedVehicle: json["matched_vehicle"] == null
          ? null
          : ApiBtVehicle.fromJson(json["matched_vehicle"]),
      overrideMatch: json["override_match"],
      reg: json["reg"],
      fleet: json["fleet"],
      liveryId: json["livery_id"],
      livery: json["livery"] == null
          ? null
          : ApiBtLivery.fromJson(json["livery"]),
      vehicleTypeId: json["vehicle_type_id"],
      vehicleType: json["vehicle_type"] == null
          ? null
          : ApiBtVehicleType.fromJson(json["vehicle_type"]),
      routeId: json["route_id"],
      route: json["route"] == null ? null : ApiTxLine.fromJson(json["route"]),
    );
  }

  static Future<List<ApiPhoto>> fetchAll({
    int? id,
    int? authorId,
    String? title,
    String? description,
    String? search,
    String? bdReg,
    String? bdFleet,
    int? bdLiveryId,
    String? bdOperatorId,
    int? bdVehicleTypeId,
    int? bdVehicleId,
    String? bdRoute,
    bool? bdHasMatchedVehicle,
    int? pageLength = pageSize,
    int? offset,
  }) async {
    String query = "";

    var parts = [
      ("id", id?.toString()),
      ("author_id", authorId?.toString()),
      ("photo_type", PhotoType.bus.value.toString()),
      ("title", title),
      ("description", description),
      ("search", search),
      ("bd_reg", bdReg),
      ("bd_fleet", bdFleet),
      ("bd_livery_id", bdLiveryId?.toString()),
      ("bd_vehicle_type_id", bdVehicleTypeId?.toString()),
      ("bd_vehicle_id", bdVehicleId?.toString()),
      ("bd_operator_id", bdOperatorId),
      ("bd_has_matched_vehicle", bdHasMatchedVehicle?.toString()),
      ("bd_route", bdRoute),
      ("page_length", pageLength?.toString()),
      ("offset", offset?.toString()),
    ].where((x) => x.$2 != null);

    for (var x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${Uri.encodeQueryComponent(x.$2.$2!)}";
    }

    final data = await Api().get("/photos$query");

    return (data as List).map((json) => ApiPhoto.fromJson(json)).toList();
  }

  Future<void> updateDetails({
    int? matchedVehicleId,
    bool? overrideMatch,
    String? reg,
    String? fleet,
    int? liveryId,
    int? vehicleTypeId,
    String? routeId,
  }) async {
    final body = <String, dynamic>{};

    // if (matchedVehicleId != null) {
    body["matched_vehicle_id"] = matchedVehicleId;
    // }

    if (overrideMatch != null) {
      body["override_match"] = overrideMatch;
    }

    // if (reg != null) {
    body["reg"] = reg;
    // }

    // if (fleet != null) {
    body["fleet"] = fleet;
    // }

    // if (liveryId != null) {
    body["livery_id"] = liveryId;
    // }

    // if (vehicleTypeId != null) {
    body["vehicle_type_id"] = vehicleTypeId;
    // }

    // if (routeId != null) {
    body["route_id"] = routeId;
    // }

    await Api().patch("/photos/$photoId/bus-details", body);
  }
}
