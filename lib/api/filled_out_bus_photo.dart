import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:transportia/api/api.dart';
import 'package:transportia/api/bus_photo_details.dart';
import 'package:transportia/api/photo_rating_response.dart';
import 'package:transportia/api/user.dart';
import 'package:dio/dio.dart'
    show Dio, FormData, MultipartFile, DioMediaType, BaseOptions;
import 'package:mime/mime.dart' show lookupMimeType;
import 'package:transportia/constants.dart';

class ApiFilledOutPhotoBus {
  final int id;
  final int authorId;
  final ApiUser author;
  final String photoType;
  final int? objDetailsId;
  final ApiBusPhotoDetails? objDetails;
  final int? commentThread;
  final String fileName;
  final String uploadedId;
  final String title;
  final String? description;
  final String createdAt;
  final bool? isFavourited;

  String get displyName {
    if (title.isNotEmpty) return title;
    if (objDetails != null &&
        objDetails!.dFleet != null &&
        objDetails!.dReg != null) {
      return "${objDetails!.dFleet} ${objDetails!.dReg} ${objDetails?.dVehicleType?.name}";
    }
    return fileName;
  }

  ApiFilledOutPhotoBus({
    required this.id,
    required this.authorId,
    required this.author,
    required this.photoType,
    required this.objDetailsId,
    required this.objDetails,
    required this.commentThread,
    required this.fileName,
    required this.uploadedId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isFavourited,
  });

  factory ApiFilledOutPhotoBus.fromJson(Map<String, dynamic> json) {
    return ApiFilledOutPhotoBus(
      id: json["id"],
      authorId: json["author_id"],
      author: ApiUser.fromJson(json["author"]),
      photoType: json["photo_type"],
      objDetailsId: json["obj_details_id"],
      objDetails: json["obj_details"] != null
          ? ApiBusPhotoDetails.fromJson(json["obj_details"])
          : null,
      commentThread: json["comment_thread"],
      fileName: json["file_name"],
      uploadedId: json["uploaded_id"],
      title: json["title"],
      description: json["description"],
      createdAt: json["created_at"],
      isFavourited: json["is_favourited"],
    );
  }

  static Future<ApiFilledOutPhotoBus> fetch(int id) async {
    final data = await Api().get("/photos/$id");

    return ApiFilledOutPhotoBus.fromJson(data);
  }

  static Future<List<ApiFilledOutPhotoBus>> fetchAll({
    int? id,
    int? authorId,
    String? photoType,
    String? title,
    String? description,
    String? search,
    String? bdReg,
    String? bdFleet,
    int? bdLiveryId,
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
      ("photo_type", photoType?.toString()),
      ("title", title),
      ("description", description),
      ("search", search),
      ("bd_reg", bdReg),
      ("bd_fleet", bdFleet),
      ("bd_livery_id", bdLiveryId?.toString()),
      ("bd_vehicle_type_id", bdVehicleTypeId?.toString()),
      ("bd_vehicle_id", bdVehicleId?.toString()),
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

    return (data as List)
        .map((json) => ApiFilledOutPhotoBus.fromJson(json))
        .toList();
  }

  // static Future<List<ApiFilledOutPhotoBus>> upload(List<XFile> files) async {
  //   final token = Preferences().getString("token");

  //   final request = http.MultipartRequest(
  //     "POST",
  //     Uri.parse("${Api().baseUrl}/photos/upload"),
  //   );

  //   request.headers["Authorization"] = "Bearer $token";

  //   for (final image in files) {
  //     final bytes = await image.readAsBytes();

  //     final extension = image.name.split('.').last.toLowerCase();

  //     final mediaType = switch (extension) {
  //       "jpg" || "jpeg" => http.MediaType("image", "jpeg"),
  //       "png" => http.MediaType("image", "png"),
  //       _ => throw Exception("Unsupported image type: .$extension"),
  //     };

  //     request.files.add(
  //       http.MultipartFile.fromBytes(
  //         "file",
  //         bytes,
  //         filename: image.name,
  //         contentType: mediaType,
  //       ),
  //     );
  //   }

  //   final response = await request.send();

  //   final body = await response.stream.bytesToString();

  //   if (response.statusCode < 200 || response.statusCode >= 300) {
  //     throw Exception("Upload failed (${response.statusCode}): $body");
  //   }

  //   final data = jsonDecode(body);

  //   return (data as List).map((x) => ApiFilledOutPhotoBus.fromJson(x)).toList();
  // }

  static Future<List<ApiFilledOutPhotoBus>> upload(
    List<XFile> files, {
    void Function(String file, double progress)? onProgress,
  }) async {
    final uploaded = <ApiFilledOutPhotoBus>[];

    // Use the Dio instance configured for your API's base URL and authentication.
    final dio = Dio(
      BaseOptions(baseUrl: Api().baseUrl, headers: Api().headers()),
    );

    for (final file in files) {
      // Start progress for this file.
      onProgress?.call(file.name, 0);

      final bytes = await file.readAsBytes();

      final mimeType = lookupMimeType(
        file.name,
        headerBytes: bytes.take(12).toList(),
      );

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: file.name,
          contentType: mimeType == null ? null : DioMediaType.parse(mimeType),
        ),
      });

      print(file.path);
      print(file.name);

      final response = await dio.post(
        '/photos/upload',
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) {
            final progress = (sent / total * 100).clamp(0.0, 100.0).toDouble();

            onProgress?.call(file.name, progress);
          }
        },
      );

      // The upload has completed successfully.
      onProgress?.call(file.name, 100);

      uploaded.add(
        ApiFilledOutPhotoBus.fromJson(
          Map<String, dynamic>.from(response.data[0] as Map),
        ),
      );
    }

    return uploaded;
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

    await Api().patch("/photos/$id/bus-details", body);
  }

  Future<void> updatePhoto({String? title, String? description}) async {
    final body = <String, dynamic>{};

    if (title != null) {
      body["title"] = title;
    }

    if (description != null) {
      body["description"] = description;
    }

    await Api().patch("/photos/$id", body);
  }

  Future<ApiPhotoRatingResponse> setRating(int rating) async {
    final response = await Api().post("/photos/$id/ratings?rating=$rating", {});

    return ApiPhotoRatingResponse.fromJson(response);
  }

  Future<ApiPhotoRatingResponse> deleteRating() async {
    final response = await Api().delete("/photos/$id/ratings");

    return ApiPhotoRatingResponse.fromJson(response);
  }

  Future<void> delete() async {
    await Api().delete("/photos/$id");
  }

  Future<ApiPhotoRatingResponse> getRating() async {
    final response = await Api().get("/photos/$id/ratings");

    return ApiPhotoRatingResponse.fromJson(response);
  }

  String withSize(int width, {int? height}) {
    if (width == 0) return originalSize();
    return "${Api().baseUrl}/photos/$id/image?width=$width${height != null ? "&height=$height" : ""}";
  }

  String originalSize() {
    return "${Api().baseUrl}/photos/$id/image";
  }
}
