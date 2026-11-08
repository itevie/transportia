import 'package:transportia/api/api.dart';
import 'package:transportia/constants.dart';

class ApiModelBusOwnership {
  final int id;
  final int userId;
  final int modelBus;

  final int? certificateNumber;
  final String? boughtAt;
  final String? defects;

  final String createdAt;

  ApiModelBusOwnership({
    required this.id,
    required this.userId,
    required this.modelBus,
    this.certificateNumber,
    this.boughtAt,
    this.defects,
    required this.createdAt,
  });

  factory ApiModelBusOwnership.fromJson(Map<String, dynamic> json) {
    return ApiModelBusOwnership(
      id: json["id"],
      userId: json["user_id"],
      modelBus: json["model_bus"],
      certificateNumber: json["certificate_number"],
      boughtAt: json["bought_at"],
      defects: json["defects"],
      createdAt: json["created_at"],
    );
  }

  ApiModelBusOwnership copyWith({
    int? id,
    int? userId,
    int? modelBus,
    int? certificateNumber,
    String? boughtAt,
    String? defects,
    String? createdAt,
  }) {
    return ApiModelBusOwnership(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      modelBus: modelBus ?? this.modelBus,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      boughtAt: boughtAt ?? this.boughtAt,
      defects: defects ?? this.defects,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static Future<List<ApiModelBusOwnership>> search({
    int? modelBus,
    int? certificateNumber,
    String? boughtAt,
    String? defects,
    int? pageLength = pageSize,
    int? offset,
  }) async {
    String query = "";

    var parts = [
      ("model_bus", modelBus),
      ("certificate_number", certificateNumber),
      ("bought_at", boughtAt),
      ("defects", defects),
      ("page_length", pageLength),
      ("offset", offset),
    ].where((x) => x.$2 != null);

    for (var x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${Uri.encodeQueryComponent(x.$2.$2.toString())}";
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
      "model_bus": modelBus,
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
