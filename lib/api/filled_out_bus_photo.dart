// import 'dart:async';

// import 'package:image_picker/image_picker.dart';
// import 'package:mime/mime.dart';
// import 'package:transportia/api/api.dart';
// import 'package:transportia/api/bus_photo_details.dart';
// import 'package:transportia/api/photo.dart';
// import 'package:transportia/api/photo_rating_response.dart';
// import 'package:transportia/api/user.dart';

// import 'package:transportia/constants.dart';

// class ApiFilledOutPhotoBus extends ApiPhoto {
//   @override
//   final ApiBusPhotoDetails? busPhoto;
//   final bool? isFavourited;

//   String get displyName {
//     if (title.isNotEmpty) return title;
//     if (objDetails != null &&
//         objDetails!.dFleet != null &&
//         objDetails!.dReg != null) {
//       return "${objDetails!.dFleet} ${objDetails!.dReg} ${objDetails?.dVehicleType?.name}";
//     }
//     return fileName;
//   }

//   ApiFilledOutPhotoBus({
//     required super.id,
//     required super.authorId,
//     required super.author,
//     required super.photoType,
//     required super.objDetailsId,
//     required super.objDetails,
//     required super.commentThread,
//     required super.fileName,
//     required super.uploadedId,
//     required super.title,
//     required super.description,
//     required super.createdAt,
//     required this.isFavourited,
//     required this.busPhoto,
//   });

//   factory ApiFilledOutPhotoBus.fromJson(Map<String, dynamic> json) {
//     return ApiFilledOutPhotoBus(
//       id: json["id"],
//       authorId: json["author_id"],
//       author: ApiUser.fromJson(json["author"]),
//       photoType: json["photo_type"],
//       objDetailsId: json["obj_details_id"],
//       objDetails: json["obj_details"] != null
//           ? ApiBusPhotoDetails.fromJson(json["obj_details"])
//           : null,
//       commentThread: json["comment_thread"],
//       fileName: json["file_name"],
//       uploadedId: json["uploaded_id"],
//       title: json["title"],
//       description: json["description"],
//       createdAt: json["created_at"],
//       isFavourited: json["is_favourited"],
//       busPhoto: null,
//     );
//   }

//   String withSize(int width, {int? height}) {
//     if (width == 0) return originalSize();
//     return "${Api().baseUrl}/photos/$id/image?width=$width${height != null ? "&height=$height" : ""}";
//   }

//   String originalSize() {
//     return "${Api().baseUrl}/photos/$id/image";
//   }
// }
