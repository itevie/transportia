import 'package:transportia/api/api.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/model_bus_ownership.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/constants.dart';

class ApiModelBusPhotoDetails {
  final int photoId;

  final int id;
  final int? matchedModelId;
  final ApiModelBus? matchedModel;
  final int? ownership;
  final ApiModelBusOwnership? ownershipDetails;
  final bool overrideMatch;

  ApiModelBusPhotoDetails({
    required this.id,
    required this.matchedModelId,
    required this.matchedModel,
    required this.ownership,
    required this.ownershipDetails,
    required this.overrideMatch,
    required this.photoId,
  });

  factory ApiModelBusPhotoDetails.fromJson(
    Map<String, dynamic> json,
    int photoId,
  ) {
    return ApiModelBusPhotoDetails(
      photoId: photoId,
      id: json["id"],
      matchedModelId: json["matched_model_id"],
      matchedModel: json["matched_model"] == null
          ? null
          : ApiModelBus.fromJson(json["matched_model"]),
      ownership: json["ownership"],
      ownershipDetails: json["ownership_details"] == null
          ? null
          : ApiModelBusOwnership.fromJson(json["ownership_details"]),
      overrideMatch: json["override_match"],
    );
  }

  static Future<List<ApiPhoto>> fetchAll({
    int? id,
    int? authorId,
    String? title,
    String? description,
    String? search,

    // Model bus details
    String? mbdManufacturer,
    String? mbdProductCode,
    int? mbdScale,
    String? mbdOperator,
    String? mbdLivery,
    String? mbdFleetNumber,
    String? mbdRegistration,
    String? mbdRouteNumber,
    String? mbdDestination,
    String? mbdVehicleType,
    bool? mbdHasCertificate,
    bool? mbdReleased,
    int? mbdModelId,
    bool? mbdHasMatchedModel,
    int? mbdOwnerId,

    int? pageLength = pageSize,
    int? offset,
  }) async {
    String query = "";

    var parts = [
      ("id", id?.toString()),
      ("author_id", authorId?.toString()),
      ("photo_type", PhotoType.modelBus.value.toString()),
      ("title", title),
      ("description", description),
      ("search", search),

      // Model bus details
      ("mbd_manufacturer", mbdManufacturer),
      ("mbd_product_code", mbdProductCode),
      ("mbd_scale", mbdScale?.toString()),
      ("mbd_operator", mbdOperator),
      ("mbd_livery", mbdLivery),
      ("mbd_fleet_number", mbdFleetNumber),
      ("mbd_registration", mbdRegistration),
      ("mbd_route_number", mbdRouteNumber),
      ("mbd_destination", mbdDestination),
      ("mbd_vehicle_type", mbdVehicleType),
      ("mbd_has_certificate", mbdHasCertificate?.toString()),
      ("mbd_released", mbdReleased?.toString()),
      ("mbd_model_id", mbdModelId?.toString()),
      ("mbd_has_matched_model", mbdHasMatchedModel?.toString()),
      ("mbd_owner_id", mbdOwnerId?.toString()),

      // Pagination
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
    int? matchedModelId,
    int? ownership,
    bool? overrideMatch,
  }) async {
    final body = <String, dynamic>{};

    body["matched_model_id"] = matchedModelId;
    body["ownership"] = ownership;

    if (overrideMatch != null) {
      body["override_match"] = overrideMatch;
    }

    await Api().patch("/photos/$photoId/model-bus-details", body);
  }
}
