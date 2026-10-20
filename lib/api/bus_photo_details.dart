import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/tx_line.dart';

class ApiBusPhotoDetails {
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
  });

  factory ApiBusPhotoDetails.fromJson(Map<String, dynamic> json) {
    return ApiBusPhotoDetails(
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
}
