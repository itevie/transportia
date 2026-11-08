import 'package:transportia/api/api.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/constants.dart';

class ApiBtVehicle {
  final int id;
  final String slug;
  final String fleet;
  final String reg;
  final String previousReg;
  final int? vehicleTypeId;
  final ApiBtVehicleType? vehicleType;
  final int? liveryId;
  final ApiBtLivery? livery;
  final String branding;
  final String operatorId;
  final ApiTxOperator? operator;
  final String? garageId;
  final String name;
  final String notes;
  final bool withdrawn;
  final ApiPhoto? photo;
  final int? commentThread;
  final bool? isFavourited;
  final bool trainingVehicle;
  final bool demonstrator;
  final bool openTop;

  ApiBtVehicle({
    required this.id,
    required this.slug,
    required this.fleet,
    required this.reg,
    required this.previousReg,
    this.vehicleTypeId,
    this.vehicleType,
    this.liveryId,
    this.livery,
    required this.branding,
    required this.operatorId,
    this.operator,
    this.garageId,
    required this.name,
    required this.notes,
    required this.withdrawn,
    this.photo,
    this.isFavourited,
    this.commentThread,
    required this.trainingVehicle,
    required this.demonstrator,
    required this.openTop,
  });

  factory ApiBtVehicle.fromJson(Map<String, dynamic> json) {
    return ApiBtVehicle(
      id: json["id"],
      slug: json["slug"],
      fleet: json["fleet"],
      reg: json["reg"],
      previousReg: json["previous_reg"],
      vehicleTypeId: json["vehicle_type_id"],
      vehicleType: json["vehicle_type"] == null
          ? null
          : ApiBtVehicleType.fromJson(json["vehicle_type"]),
      liveryId: json["livery_id"],
      livery: json["livery"] == null
          ? null
          : ApiBtLivery.fromJson(json["livery"]),
      branding: json["branding"],
      operatorId: json["operator_id"],
      operator: json["operator"] == null
          ? null
          : ApiTxOperator.fromJson(json["operator"]),
      garageId: json["garage_id"],
      name: json["name"],
      notes: json["notes"],
      withdrawn: json["withdrawn"],
      photo: json["photo"] == null ? null : ApiPhoto.fromJson(json["photo"]),
      isFavourited: json["is_favourited"],
      commentThread: json["comment_thread"],
      trainingVehicle: json["training_vehicle"],
      demonstrator: json["demonstrator"],
      openTop: json["open_top"],
    );
  }

  ApiBtVehicle copyWith({
    int? id,
    String? slug,
    String? fleet,
    String? reg,
    String? previousReg,
    int? vehicleTypeId,
    ApiBtVehicleType? vehicleType,
    int? liveryId,
    ApiBtLivery? livery,
    String? branding,
    String? operatorId,
    ApiTxOperator? operator,
    String? garageId,
    String? name,
    String? notes,
    bool? withdrawn,
    ApiPhoto? photo,
    int? commentThread,
    bool? isFavourited,
    bool? trainingVehicle,
    bool? demonstrator,
    bool? openTop,
  }) {
    return ApiBtVehicle(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      fleet: fleet ?? this.fleet,
      reg: reg ?? this.reg,
      previousReg: previousReg ?? this.previousReg,
      vehicleTypeId: vehicleTypeId ?? this.vehicleTypeId,
      vehicleType: vehicleType ?? this.vehicleType,
      liveryId: liveryId ?? this.liveryId,
      livery: livery ?? this.livery,
      branding: branding ?? this.branding,
      operatorId: operatorId ?? this.operatorId,
      operator: operator ?? this.operator,
      garageId: garageId ?? this.garageId,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      withdrawn: withdrawn ?? this.withdrawn,
      photo: photo ?? this.photo,
      commentThread: commentThread ?? this.commentThread,
      isFavourited: isFavourited ?? this.isFavourited,
      trainingVehicle: trainingVehicle ?? this.trainingVehicle,
      demonstrator: demonstrator ?? this.demonstrator,
      openTop: openTop ?? this.openTop,
    );
  }

  static Future<List<ApiBtVehicle>> search({
    String? search,
    String? slug,
    String? fleet,
    String? reg,
    String? previousReg,
    int? vehicleTypeId,
    int? liveryId,
    String? operatorId,
    String? name,
    bool? withdrawn,
    bool? electric,
    bool? doubleDecker,
    bool? coach,
    bool? trainingVehicle,
    bool? demonstrator,
    bool? openTop,
    bool? hasImage,
    int? pageLength = pageSize,
    int? offset,
  }) async {
    String query = "";

    var parts = [
      ("search", search),
      ("slug", slug),
      ("fleet", fleet),
      ("reg", reg),
      ("previous_reg", previousReg),
      ("vehicle_type_id", vehicleTypeId),
      ("livery_id", liveryId),
      ("name", name),
      ("withdrawn", withdrawn),
      ("operator_id", operatorId),
      ("electric", electric),
      ("double_decker", doubleDecker),
      ("open_top", openTop),
      ("demonstrator", demonstrator),
      ("training_vehicle", trainingVehicle),
      ("coach", coach),
      ("has_image", hasImage),
      ("page_length", pageLength),
      ("offset", offset),
    ].where((x) => x.$2 != null);

    for (var x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${Uri.encodeQueryComponent(x.$2.$2.toString())}";
    }

    final data = await Api().get("/vehicles$query");

    return (data as List).map((json) => ApiBtVehicle.fromJson(json)).toList();
  }

  static Future<ApiBtVehicle?> get(int id) async {
    final data = await Api().get("/vehicles/$id");

    if (data == null) {
      return null;
    }

    return ApiBtVehicle.fromJson(data);
  }

  Future<void> updateVehicle({
    bool? trainingVehicle,
    bool? demonstrator,
    bool? openTop,
  }) async {
    await Api().patch("/vehicles/$id", {
      "training_vehicle": ?trainingVehicle,
      'demonstrator': ?demonstrator,
      'open_top': ?openTop,
    });
  }
}
