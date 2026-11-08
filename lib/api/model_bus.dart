import 'package:transportia/api/api.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/constants.dart';

class ApiModelBus {
  final int id;

  final String productCode;
  final String manufacturer;
  final int scale;

  final String? operator;
  final String? operatorLink;
  final ApiTxOperator? operatorObj;

  final String? livery;
  final int? liveryLink;
  final ApiBtLivery? liveryObj;

  final String? fleetNumber;
  final String? registration;
  final int? vehicleLink;
  final ApiBtVehicle? vehicleObj;

  final String? routeNumber;
  final String? destination;
  final String? routeLink;
  final ApiTxLine? routeObj;

  final String? vehicleType;
  final int? vehicleTypeLink;
  final ApiBtVehicleType? vehicleTypeObj;

  final bool hasCertificate;
  final int certificateMax;

  final String? released;

  final String createdAt;
  final String updatedAt;

  ApiModelBus({
    required this.id,
    required this.productCode,
    required this.manufacturer,
    required this.scale,
    this.operator,
    this.operatorLink,
    this.operatorObj,
    this.livery,
    this.liveryLink,
    this.liveryObj,
    this.fleetNumber,
    this.registration,
    this.vehicleLink,
    this.vehicleObj,
    this.routeNumber,
    this.destination,
    this.routeLink,
    this.routeObj,
    this.vehicleType,
    this.vehicleTypeLink,
    this.vehicleTypeObj,
    this.hasCertificate = false,
    this.certificateMax = 0,
    this.released,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApiModelBus.fromJson(Map<String, dynamic> json) {
    return ApiModelBus(
      id: json["id"],
      productCode: json["product_code"],
      manufacturer: json["manufacturer"],
      scale: json["scale"],

      operator: json["operator"],
      operatorLink: json["operator_link"],
      operatorObj: json["operator_obj"] != null
          ? ApiTxOperator.fromJson(json["operator_obj"])
          : null,

      livery: json["livery"],
      liveryLink: json["livery_link"],
      liveryObj: json["livery_obj"] != null
          ? ApiBtLivery.fromJson(json["livery_obj"])
          : null,

      fleetNumber: json["fleet_number"],
      registration: json["registration"],
      vehicleLink: json["vehicle_link"],
      vehicleObj: json["vehicle_obj"] != null
          ? ApiBtVehicle.fromJson(json["vehicle_obj"])
          : null,

      routeNumber: json["route_number"],
      destination: json["destination"],
      routeLink: json["route_link"],
      routeObj: json["route_obj"] != null
          ? ApiTxLine.fromJson(json["route_obj"])
          : null,

      vehicleType: json["vehicle_type"],
      vehicleTypeLink: json["vehicle_type_link"],
      vehicleTypeObj: json["vehicle_type_obj"] != null
          ? ApiBtVehicleType.fromJson(json["vehicle_type_obj"])
          : null,

      hasCertificate:
          json["has_certificate"] == true || json["has_certificate"] == 1,
      certificateMax: json["certificate_max"] ?? 0,

      released: json["released"],

      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  ApiModelBus copyWith({
    int? id,
    String? productCode,
    String? manufacturer,
    int? scale,
    String? operator,
    String? operatorLink,
    String? livery,
    int? liveryLink,
    String? fleetNumber,
    String? registration,
    int? vehicleLink,
    String? routeNumber,
    String? destination,
    String? routeLink,
    String? vehicleType,
    int? vehicleTypeLink,
    bool? hasCertificate,
    int? certificateMax,
    String? released,
    String? createdAt,
    String? updatedAt,
  }) {
    return ApiModelBus(
      id: id ?? this.id,
      productCode: productCode ?? this.productCode,
      manufacturer: manufacturer ?? this.manufacturer,
      scale: scale ?? this.scale,
      operator: operator ?? this.operator,
      operatorLink: operatorLink ?? this.operatorLink,
      livery: livery ?? this.livery,
      liveryLink: liveryLink ?? this.liveryLink,
      fleetNumber: fleetNumber ?? this.fleetNumber,
      registration: registration ?? this.registration,
      vehicleLink: vehicleLink ?? this.vehicleLink,
      routeNumber: routeNumber ?? this.routeNumber,
      destination: destination ?? this.destination,
      routeLink: routeLink ?? this.routeLink,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleTypeLink: vehicleTypeLink ?? this.vehicleTypeLink,
      hasCertificate: hasCertificate ?? this.hasCertificate,
      certificateMax: certificateMax ?? this.certificateMax,
      released: released ?? this.released,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Future<List<ApiModelBus>> search({
    String? search,
    String? productCode,
    String? manufacturer,
    int? scale,
    String? operator,
    String? operatorLink,
    String? livery,
    int? liveryLink,
    String? fleetNumber,
    String? registration,
    int? vehicleLink,
    String? routeNumber,
    String? destination,
    String? routeLink,
    String? vehicleType,
    int? vehicleTypeLink,
    bool? hasCertificate,
    String? released,
    bool? hasImage,
    int? pageLength = pageSize,
    int? offset,
  }) async {
    String query = "";

    var parts = [
      ("search", search),
      ("product_code", productCode),
      ("manufacturer", manufacturer),
      ("scale", scale),
      ("operator", operator),
      ("operator_link", operatorLink),
      ("livery", livery),
      ("livery_link", liveryLink),
      ("fleet_number", fleetNumber),
      ("registration", registration),
      ("vehicle_link", vehicleLink),
      ("route_number", routeNumber),
      ("destination", destination),
      ("route_link", routeLink),
      ("vehicle_type", vehicleType),
      ("vehicle_type_link", vehicleTypeLink),
      ("has_certificate", hasCertificate),
      ("released", released),
      ("has_image", hasImage),
      ("page_length", pageLength),
      ("offset", offset),
    ].where((x) => x.$2 != null);

    for (var x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${Uri.encodeQueryComponent(x.$2.$2.toString())}";
    }

    final data = await Api().get("/model-buses$query");

    return (data as List).map((json) => ApiModelBus.fromJson(json)).toList();
  }

  static Future<ApiModelBus?> get(int id) async {
    final data = await Api().get("/model-buses/$id");

    if (data == null) {
      return null;
    }

    return ApiModelBus.fromJson(data);
  }

  static Future<int> create({
    String? productCode,
    required String manufacturer,
    int? scale,
    String? operator,
    String? operatorLink,
    String? livery,
    int? liveryLink,
    String? fleetNumber,
    String? registration,
    int? vehicleLink,
    String? routeNumber,
    String? destination,
    String? routeLink,
    String? vehicleType,
    int? vehicleTypeLink,
    bool hasCertificate = false,
    int certificateMax = 0,
    String? released,
  }) async {
    final data = await Api().post("/model-buses", {
      "product_code": productCode,
      "manufacturer": manufacturer,
      "scale": scale,
      "operator": operator,
      "operator_link": operatorLink,
      "livery": livery,
      "livery_link": liveryLink,
      "fleet_number": fleetNumber,
      "registration": registration,
      "vehicle_link": vehicleLink,
      "route_number": routeNumber,
      "destination": destination,
      "route_link": routeLink,
      "vehicle_type": vehicleType,
      "vehicle_type_link": vehicleTypeLink,
      "has_certificate": hasCertificate,
      "certificate_max": certificateMax,
      "released": released,
    });

    if (data is num) {
      return data.toInt();
    }

    if (data is Map && data["id"] is num) {
      return (data["id"] as num).toInt();
    }

    throw const FormatException(
      "Expected the create model bus response to contain an ID.",
    );
  }

  static Future<void> delete(int id) async {
    await Api().delete("/model-buses/$id");
  }

  Future<void> updateModelBus({
    String? productCode,
    String? manufacturer,
    int? scale,
    String? operator,
    String? operatorLink,
    String? livery,
    int? liveryLink,
    String? fleetNumber,
    String? registration,
    int? vehicleLink,
    String? routeNumber,
    String? destination,
    String? routeLink,
    String? vehicleType,
    int? vehicleTypeLink,
    bool? hasCertificate,
    int? certificateMax,
    String? released,
  }) async {
    await Api().patch("/model-buses/$id", {
      "product_code": productCode,
      "manufacturer": manufacturer,
      "scale": scale,
      "operator": operator,
      "operator_link": operatorLink,
      "livery": livery,
      "livery_link": liveryLink,
      "fleet_number": fleetNumber,
      "registration": registration,
      "vehicle_link": vehicleLink,
      "route_number": routeNumber,
      "destination": destination,
      "route_link": routeLink,
      "vehicle_type": vehicleType,
      "vehicle_type_link": vehicleTypeLink,
      "has_certificate": hasCertificate,
      "certificate_max": certificateMax,
      "released": released,
    });
  }
}
