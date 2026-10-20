import 'package:transportia/api/api.dart';
import 'package:transportia/api/user.dart';

class ApiComment {
  final int id;
  final int thread;
  final int authorId;
  final ApiUser author;
  final String body;
  final bool edited;
  final String? editedAt;
  final int? parentCommentId;
  final String createdAt;
  final bool? isFavourited;

  ApiComment({
    required this.id,
    required this.thread,
    required this.authorId,
    required this.author,
    required this.body,
    required this.edited,
    required this.editedAt,
    required this.parentCommentId,
    required this.createdAt,
    required this.isFavourited,
  });

  factory ApiComment.fromJson(Map<String, dynamic> json) {
    return ApiComment(
      id: json["id"],
      thread: json["thread"],
      authorId: json["author_id"],
      author: ApiUser.fromJson(json["author"]),
      body: json["body"],
      edited: json["edited"],
      editedAt: json["edited_at"],
      parentCommentId: json["parent_comment_id"],
      createdAt: json["created_at"],

      isFavourited: json["is_favourited"],
    );
  }

  static Future<ApiComment?> fetch(int id) async {
    final data = await Api().get("/comments/$id");

    if (data == null) return null;

    return ApiComment.fromJson(data);
  }

  static Future<List<ApiComment>> fetchByThread(int thread) async {
    final data = await Api().get("/comment-threads/$thread");

    return (data as List).map((json) => ApiComment.fromJson(json)).toList();
  }

  static Future<List<ApiComment>> fetchReplies(int parentCommentId) async {
    final data = await Api().get("/comments/$parentCommentId/replies");

    return (data as List).map((json) => ApiComment.fromJson(json)).toList();
  }

  static Future<ApiComment> create({
    required int thread,
    required String body,
    int? parentCommentId,
  }) async {
    final data = await Api().post("/comment-threads/$thread/comments", {
      "body": body,
      "parent_comment_id": parentCommentId,
    });

    return ApiComment.fromJson(data);
  }

  Future<void> edit(String body) async {
    await Api().patch("/comments/$id", {"body": body});
  }

  Future<void> delete() async {
    await Api().delete("/comments/$id");
  }

  static Future<List<ApiComment>> fetchAll({
    String? search,
    int? thread,
    int? authorId,
    int? parentCommentId,
    int? pageLength = 50,
    int? offset,
  }) async {
    final parts = [
      ("search", search),
      ("thread", thread?.toString()),
      ("author_id", authorId?.toString()),
      ("parent_comment_id", parentCommentId?.toString()),
      ("page_length", pageLength?.toString()),
      ("offset", offset?.toString()),
    ].where((x) => x.$2 != null);

    String query = "";

    for (final x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${Uri.encodeQueryComponent(x.$2.$2!)}";
    }

    final data = await Api().get("/comments$query");

    return (data as List).map((json) => ApiComment.fromJson(json)).toList();
  }
}
