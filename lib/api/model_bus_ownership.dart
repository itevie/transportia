import 'package:transportia/api/api.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/constants.dart';

class ApiModelBusOwnership {
  final int id;
  final int userId;
  final int modelBusId;
  final ApiModelBus modelBus;

  final int? certificateNumber;
  final String? boughtAt;
  final String? defects;

  final ApiPhoto? photo;

  final String createdAt;

  String get displayName => certificateNumber == null
      ? "Owned, no cert"
      : "Owned, cert #$certificateNumber";

  String get displayNameLong => "${modelBus.displayName} ($displayName)";

  ApiModelBusOwnership({
    required this.id,
    required this.userId,
    required this.modelBusId,
    required this.modelBus,
    this.certificateNumber,
    this.boughtAt,
    this.defects,
    required this.createdAt,
    this.photo,
  });

  factory ApiModelBusOwnership.fromJson(Map<String, dynamic> json) {
    return ApiModelBusOwnership(
      id: json["id"],
      userId: json["user_id"],
      modelBusId: json["model_bus_id"],
      modelBus: ApiModelBus.fromJson(json["model_bus"]),
      certificateNumber: json["certificate_number"],
      boughtAt: json["bought_at"],
      defects: json["defects"],
      photo: json["photo"] == null ? null : ApiPhoto.fromJson(json["photo"]),
      createdAt: json["created_at"],
    );
  }

  ApiModelBusOwnership copyWith({
    int? id,
    int? userId,
    int? modelBusId,
    ApiModelBus? modelBus,
    int? certificateNumber,
    String? boughtAt,
    String? defects,
    String? createdAt,
  }) {
    return ApiModelBusOwnership(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      modelBusId: modelBusId ?? this.modelBusId,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      boughtAt: boughtAt ?? this.boughtAt,
      defects: defects ?? this.defects,
      createdAt: createdAt ?? this.createdAt,
      modelBus: modelBus ?? this.modelBus,
    );
  }

  static Future<List<ApiModelBusOwnership>> search({
    int? userId,
    int? modelBusId,
    int? certificateNumber,
    String? boughtAt,

    // Search
    String? search,

    // Model bus filters
    String? productCode,
    String? manufacturer,
    int? scale,
    String? operator,
    String? livery,
    String? fleetNumber,
    String? registration,
    String? routeNumber,
    String? destination,
    String? vehicleType,
    bool? hasCertificate,
    String? released,

    int? pageLength = pageSize,
    int? offset,
  }) async {
    String query = "";

    var parts = [
      ("user_id", userId?.toString()),
      ("model_bus_id", modelBusId?.toString()),
      ("certificate_number", certificateNumber?.toString()),
      ("bought_at", boughtAt),

      // Search
      ("search", search),

      // Model bus filters
      ("product_code", productCode),
      ("manufacturer", manufacturer),
      ("scale", scale?.toString()),
      ("operator", operator),
      ("livery", livery),
      ("fleet_number", fleetNumber),
      ("registration", registration),
      ("route_number", routeNumber),
      ("destination", destination),
      ("vehicle_type", vehicleType),
      ("has_certificate", hasCertificate?.toString()),
      ("released", released),

      // Pagination
      ("page_length", pageLength?.toString()),
      ("offset", offset?.toString()),
    ].where((x) => x.$2 != null);

    for (var x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${Uri.encodeQueryComponent(x.$2.$2!)}";
    }

    final data = await Api().get("/model-bus-ownerships$query");

    return (data as List)
        .map((json) => ApiModelBusOwnership.fromJson(json))
        .toList();
  }

  static Future<ApiModelBusOwnership?> get(int id) async {
    final data = await Api().get("/model-bus-ownerships/$id");

    if (data == null) {
      return null;
    }

    return ApiModelBusOwnership.fromJson(data);
  }

  static Future<int> create({
    required int modelBus,
    int? certificateNumber,
    String? boughtAt,
    String? defects,
  }) async {
    final data = await Api().post("/model-bus-ownerships", {
      "model_bus_id": modelBus,
      "certificate_number": certificateNumber,
      "bought_at": boughtAt,
      "defects": defects,
    });

    if (data is num) {
      return data.toInt();
    }

    if (data is Map && data["id"] is num) {
      return (data["id"] as num).toInt();
    }

    throw const FormatException(
      "Expected the create model bus ownership response to contain an ID.",
    );
  }

  static Future<void> delete(int id) async {
    await Api().delete("/model-bus-ownerships/$id");
  }

  Future<void> updateModelBusOwnership({
    int? certificateNumber,
    String? boughtAt,
    String? defects,
  }) async {
    await Api().patch("/model-bus-ownerships/$id", {
      "certificate_number": certificateNumber,
      "bought_at": boughtAt,
      "defects": defects,
    });
  }
}
