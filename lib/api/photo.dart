import 'package:transportia/api/api.dart';

class ApiPhoto {
  final int id;
  final int authorId;
  final String photoType;
  final int? objDetailsId;
  final int? commentThread;
  final String fileName;
  final String uploadedId;
  final String title;
  final String? description;
  final String createdAt;

  ApiPhoto({
    required this.id,
    required this.authorId,
    required this.photoType,
    required this.objDetailsId,
    required this.commentThread,
    required this.fileName,
    required this.uploadedId,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory ApiPhoto.fromJson(Map<String, dynamic> json) {
    return ApiPhoto(
      id: json["id"],
      authorId: json["author_id"],
      photoType: json["photo_type"],
      objDetailsId: json["obj_details_id"],
      commentThread: json["comment_thread"],
      fileName: json["file_name"],
      uploadedId: json["uploaded_id"],
      title: json["title"],
      description: json["description"],
      createdAt: json["created_at"],
    );
  }

  String withSize(int width, {int? height}) {
    return "${Api().baseUrl}/photos/$id/image?width=$width${height != null ? "&height=$height" : ""}";
  }
}
