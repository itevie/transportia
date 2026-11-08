import 'package:transportia/api/api.dart';
import 'package:transportia/api/tram_livery.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/constants.dart';

class ApiTram {
  final int id;
  final int? operatorId;
  final ApiTramOperator? operator;
  final String fleet;
  final int? liveryId;
  final ApiTramLivery? livery;
  final int? tramTypeId;
  final ApiTramType? tramType;
  final String? garage;
  final bool withdrawn;
  final String? name;
  final String? branding;
  final bool? isFavourited;

  ApiTram({
    required this.id,
    this.operatorId,
    this.operator,
    required this.fleet,
    this.liveryId,
    this.livery,
    this.tramTypeId,
    this.tramType,
    this.garage,
    this.withdrawn = false,
    this.name,
    this.branding,
    this.isFavourited,
  });

  factory ApiTram.fromJson(Map<String, dynamic> json) {
    print(json);
    return ApiTram(
      id: json["id"],
      operatorId: json["operator_id"],
      operator: json["operator"] == null
          ? null
          : ApiTramOperator.fromJson(json["operator"]),
      fleet: json["fleet"],
      liveryId: json["livery_id"],
      livery: json["livery"] == null
          ? null
          : ApiTramLivery.fromJson(json["livery"]),
      tramTypeId: json["tram_type_id"],
      tramType: json["tram_type"] == null
          ? null
          : ApiTramType.fromJson(json["tram_type"]),
      garage: json["garage"],
      withdrawn: json["withdrawn"] == true || json["withdrawn"] == 1,
      name: json["name"],
      branding: json["branding"],
      isFavourited: json["is_favourited"],
    );
  }

  ApiTram copyWith({
    int? id,
    int? operatorId,
    ApiTramOperator? operator,
    String? fleet,
    int? liveryId,
    ApiTramLivery? livery,
    int? tramTypeId,
    ApiTramType? tramType,
    String? garage,
    bool? withdrawn,
    String? name,
    String? branding,
    bool? isFavourited,
  }) {
    return ApiTram(
      id: id ?? this.id,
      operatorId: operatorId ?? this.operatorId,
      operator: operator ?? this.operator,
      fleet: fleet ?? this.fleet,
      liveryId: liveryId ?? this.liveryId,
      livery: livery ?? this.livery,
      tramTypeId: tramTypeId ?? this.tramTypeId,
      tramType: tramType ?? this.tramType,
      garage: garage ?? this.garage,
      withdrawn: withdrawn ?? this.withdrawn,
      name: name ?? this.name,
      branding: branding ?? this.branding,
      isFavourited: isFavourited ?? this.isFavourited,
    );
  }

  static Future<List<ApiTram>> search({
    String? search,
    int? operatorId,
    String? fleet,
    int? liveryId,
    int? tramTypeId,
    String? garage,
    bool? withdrawn,
    String? name,
    String? branding,
    int? pageLength = pageSize,
    int? offset,
  }) async {
    String query = "";

    var parts = [
      ("search", search),
      ("operator", operatorId),
      ("fleet", fleet),
      ("livery", liveryId),
      ("tram_type", tramTypeId),
      ("garage", garage),
      ("withdrawn", withdrawn),
      ("name", name),
      ("branding", branding),
      ("page_length", pageLength),
      ("offset", offset),
    ].where((x) => x.$2 != null);

    for (var x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${Uri.encodeQueryComponent(x.$2.$2.toString())}";
    }

    final data = await Api().get("/trams$query");

    return (data as List).map((json) => ApiTram.fromJson(json)).toList();
  }

  static Future<ApiTram?> get(int id) async {
    final data = await Api().get("/trams/$id");

    if (data == null) {
      return null;
    }

    return ApiTram.fromJson(data);
  }

  static Future<int> create({
    int? operatorId,
    required String fleet,
    int? liveryId,
    int? tramTypeId,
    String? garage,
    bool withdrawn = false,
    String? name,
    String? branding,
  }) async {
    final data = await Api().post("/trams", {
      "id": 0,
      "operator_id": operatorId,
      "fleet": fleet,
      "livery_id": liveryId,
      "tram_type_id": tramTypeId,
      "garage": garage,
      "withdrawn": withdrawn,
      "name": name,
      "branding": branding,
    });

    if (data is num) {
      return data.toInt();
    }

    if (data is Map && data["id"] is num) {
      return (data["id"] as num).toInt();
    }

    throw const FormatException(
      "Expected the create tram response to contain an ID.",
    );
  }

  static Future<void> delete(int id) async {
    await Api().delete("/trams/$id");
  }

  Future<void> updateTram({
    int? operatorId,
    String? fleet,
    int? liveryId,
    int? tramTypeId,
    String? garage,
    bool? withdrawn,
    String? name,
    String? branding,
  }) async {
    await Api().patch("/trams/$id", {
      "operator_id": operatorId,
      "fleet": fleet,
      "livery_id": liveryId,
      "tram_type_id": tramTypeId,
      "garage": garage,
      "withdrawn": withdrawn,
      "name": name,
      "branding": branding,
    });
  }
}
