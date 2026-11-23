import 'package:transportia/api/api.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_livery.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/constants.dart';

class ApiTramPhotoDetails {
  final int photoId;

  final int id;
  final int? matchedVehicleId;
  final ApiTram? matchedVehicle;
  final bool overrideMatch;
  final String? fleet;
  final int? liveryId;
  final ApiTramLivery? livery;
  final int? vehicleTypeId;
  final ApiTramType? vehicleType;
  final int? operatorId;
  final ApiTramOperator? operator;

  String? get dFleet => overrideMatch
      ? (fleet ?? matchedVehicle?.fleet)
      : (matchedVehicle?.fleet ?? fleet);

  ApiTramLivery? get dLivery => overrideMatch
      ? (livery ?? matchedVehicle?.livery)
      : (matchedVehicle?.livery ?? livery);

  ApiTramType? get dVehicleType => overrideMatch
      ? (vehicleType ?? matchedVehicle?.tramType)
      : (matchedVehicle?.tramType ?? vehicleType);

  ApiTramOperator? get dOperator => overrideMatch
      ? (operator ?? matchedVehicle?.operator)
      : (matchedVehicle?.operator ?? operator);

  ApiTramPhotoDetails({
    required this.id,
    required this.matchedVehicleId,
    required this.matchedVehicle,
    required this.overrideMatch,
    required this.fleet,
    required this.liveryId,
    required this.livery,
    required this.vehicleTypeId,
    required this.vehicleType,
    required this.operatorId,
    required this.operator,
    required this.photoId,
  });

  factory ApiTramPhotoDetails.fromJson(Map<String, dynamic> json, int photoId) {
    return ApiTramPhotoDetails(
      photoId: photoId,
      id: json["id"],
      matchedVehicleId: json["matched_vehicle_id"],
      matchedVehicle: json["matched_vehicle"] == null
          ? null
          : ApiTram.fromJson(json["matched_vehicle"]),
      overrideMatch: json["override_match"],
      fleet: json["fleet"],
      liveryId: json["livery_id"],
      livery: json["livery"] == null
          ? null
          : ApiTramLivery.fromJson(json["livery"]),
      vehicleTypeId: json["vehicle_type_id"],
      vehicleType: json["vehicle_type"] == null
          ? null
          : ApiTramType.fromJson(json["vehicle_type"]),
      operatorId: json["operator_id"],
      operator: json["operator"] == null
          ? null
          : ApiTramOperator.fromJson(json["operator"]),
    );
  }

  static Future<List<ApiPhoto>> fetchAll({
    int? id,
    int? authorId,
    String? title,
    String? description,
    String? search,
    String? tdFleet,
    int? tdLiveryId,
    int? tdVehicleTypeId,
    int? tdOperatorId,
    int? tdVehicleId,
    bool? tdHasMatchedVehicle,
    int? pageLength = pageSize,
    PhotoOrderBy? orderBy,
    int? offset,
  }) async {
    String query = "";

    var parts = [
      ("id", id?.toString()),
      ("author_id", authorId?.toString()),
      ("photo_type", PhotoType.tram.value.toString()),
      ("title", title),
      ("description", description),
      ("search", search),
      ("td_fleet", tdFleet),
      ("td_livery_id", tdLiveryId?.toString()),
      ("td_vehicle_type_id", tdVehicleTypeId?.toString()),
      ("td_operator_id", tdOperatorId?.toString()),
      ("td_vehicle_id", tdVehicleId?.toString()),
      ("td_has_matched_vehicle", tdHasMatchedVehicle?.toString()),
      ("page_length", pageLength?.toString()),
      ("order_by", orderBy?.toJson()),
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
    String? fleet,
    int? liveryId,
    int? vehicleTypeId,
    int? operatorId,
  }) async {
    final body = <String, dynamic>{};

    // if (matchedVehicleId != null) {
    body["matched_vehicle_id"] = matchedVehicleId;
    // }

    if (overrideMatch != null) {
      body["override_match"] = overrideMatch;
    }

    // if (fleet != null) {
    body["fleet"] = fleet;
    // }

    // if (liveryId != null) {
    body["livery_id"] = liveryId;
    // }

    // if (vehicleTypeId != null) {
    body["vehicle_type_id"] = vehicleTypeId;
    // }

    // if (operatorId != null) {
    body["operator_id"] = operatorId;
    // }

    await Api().patch("/photos/$photoId/tram-details", body);
  }
}
