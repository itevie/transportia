import 'package:dio/dio.dart'
    show Dio, FormData, MultipartFile, DioMediaType, BaseOptions;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart' show lookupMimeType;

import 'package:transportia/api/api.dart';
import 'package:transportia/api/bus_photo_details.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/api/model_bus_photo_details.dart';
import 'package:transportia/api/photo_rating_response.dart';
import 'package:transportia/api/tram_photo_details.dart';
import 'package:transportia/api/user.dart';
import 'package:transportia/constants.dart';

class ApiPhoto {
  final int id;
  final int authorId;
  final ApiUser? author;
  final PhotoType photoType;
  final int? objDetailsId;
  final dynamic privateObjDetails;
  final int? commentThread;
  final String fileName;
  final String uploadedId;
  final String title;
  final String? description;
  final String createdAt;
  final Map<String, dynamic> originalJson;
  final bool? isFavourited;

  ApiBusPhotoDetails? bus;
  ApiTramPhotoDetails? tram;
  ApiModelBusPhotoDetails? modelBus;

  String get displyName {
    if (title.isNotEmpty) return title;

    if (photoType == PhotoType.bus) {
      if (bus != null && bus!.dFleet != null && bus!.dReg != null) {
        return "${bus!.dFleet} ${bus!.dReg} ${bus?.dVehicleType?.name}";
      }
    } else if (photoType == PhotoType.tram) {
      if (tram != null && tram!.dFleet != null && tram!.dVehicleType != null) {
        return "${tram!.dFleet} - ${tram!.dVehicleType?.name}";
      }
    }

    return fileName;
  }

  ApiPhoto({
    required this.id,
    required this.authorId,
    required this.author,
    required this.photoType,
    required this.objDetailsId,
    required this.privateObjDetails,
    required this.commentThread,
    required this.fileName,
    required this.uploadedId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.originalJson,
    required this.isFavourited,
  });

  factory ApiPhoto.fromJson(Map<String, dynamic> json) {
    var photo = ApiPhoto(
      id: json["id"],
      authorId: json["author_id"],
      author: json["author"] == null ? null : ApiUser.fromJson(json["author"]),
      photoType: PhotoType.fromJson(json["photo_type"]),
      objDetailsId: json["obj_details_id"],
      privateObjDetails: json["obj_details"],
      commentThread: json["comment_thread"],
      fileName: json["file_name"],
      uploadedId: json["uploaded_id"],
      title: json["title"],
      description: json["description"],
      createdAt: json["created_at"],
      isFavourited: json["is_favourited"],
      originalJson: json,
    );

    if (json["obj_details"] != null) {
      if (photo.photoType == PhotoType.bus) {
        photo.bus = ApiBusPhotoDetails.fromJson(json["obj_details"], photo.id);
      } else if (photo.photoType == PhotoType.tram) {
        photo.tram = ApiTramPhotoDetails.fromJson(
          json["obj_details"],
          photo.id,
        );
      } else if (photo.photoType == PhotoType.modelBus) {
        photo.modelBus = ApiModelBusPhotoDetails.fromJson(
          json["obj_details"],
          photo.id,
        );
      }
    }

    return photo;
  }

  static Future<ApiPhoto> fetch(int id) async {
    final data = await Api().get("/photos/$id");

    return ApiPhoto.fromJson(data);
  }

  static Future<List<ApiPhoto>> fetchAll({
    int? id,
    int? authorId,
    PhotoType? photoType,
    String? title,
    String? description,
    String? search,
    int? pageLength = pageSize,
    int? offset,
  }) async {
    String query = "";

    var parts = [
      ("id", id?.toString()),
      ("author_id", authorId?.toString()),
      ("photo_type", photoType?.value.toString()),
      ("title", title),
      ("description", description),
      ("search", search),
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

  static Future<List<ApiPhoto>> upload(
    List<XFile> files,
    PhotoType type, {
    void Function(String file, double progress)? onProgress,
  }) async {
    final uploaded = <ApiPhoto>[];

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

      final response = await dio.post(
        '/photos/upload?photo_type=${type.value}',
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
        ApiPhoto.fromJson(Map<String, dynamic>.from(response.data[0] as Map)),
      );
    }

    return uploaded;
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

enum PhotoType {
  bus(0, "Bus", Icons.directions_bus),
  modelBus(1, "Model Bus", Icons.directions_bus_outlined),
  train(2, "Train", Icons.train),
  tram(3, "Tram", Icons.tram);

  final int value;
  final String humanValue;
  final IconData icon;

  const PhotoType(this.value, this.humanValue, this.icon);

  static PhotoType fromJson(int value) {
    return PhotoType.values.firstWhere((type) => type.value == value);
  }

  int toJson() => value;
}
