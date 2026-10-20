import 'package:transportia/api/api.dart';

class ApiCommentThread {
  final int id;
  final String createdAt;

  ApiCommentThread({required this.id, required this.createdAt});

  factory ApiCommentThread.fromJson(Map<String, dynamic> json) {
    return ApiCommentThread(id: json["id"], createdAt: json["created_at"]);
  }

  static Future<ApiCommentThread?> fetch(int id) async {
    final data = await Api().get("/comment-threads/$id");

    if (data == null) return null;

    return ApiCommentThread.fromJson(data);
  }

  static Future<int> create() async {
    final data = await Api().post("/comment-threads", {});

    return data["id"] as int;
  }

  static Future<List<ApiCommentThread>> fetchAll({
    int? pageLength = 50,
    int? offset,
  }) async {
    final parts = [
      ("page_length", pageLength?.toString()),
      ("offset", offset?.toString()),
    ].where((x) => x.$2 != null);

    String query = "";

    for (final x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${Uri.encodeQueryComponent(x.$2.$2!)}";
    }

    final data = await Api().get("/comment-threads$query");

    return (data as List)
        .map((json) => ApiCommentThread.fromJson(json))
        .toList();
  }

  static Future<void> delete(int id) async {
    await Api().delete("/comment-threads/$id");
  }
}
