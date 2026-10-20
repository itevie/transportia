import 'package:transportia/api/api.dart';
import 'package:transportia/api/route_checklist_item.dart';

class ApiRouteChecklist {
  final int id;

  final String title;
  final String? description;

  final int ownerId;

  final String createdAt;

  final List<ApiRouteChecklistItem> items;

  ApiRouteChecklist({
    required this.id,
    required this.title,
    this.description,
    required this.ownerId,
    required this.createdAt,
    required this.items,
  });

  factory ApiRouteChecklist.fromJson(Map<String, dynamic> json) {
    return ApiRouteChecklist(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      ownerId: json["owner_id"],
      createdAt: json["created_at"],
      items: (json["items"] as List)
          .map((x) => ApiRouteChecklistItem.fromJson(x))
          .toList(),
    );
  }

  static Future<List<ApiRouteChecklist>> fetchAll() async {
    final response = await Api().get("/route-checklists");

    return (response as List)
        .map((json) => ApiRouteChecklist.fromJson(json))
        .toList();
  }

  static Future<ApiRouteChecklist> fetch(int id) async {
    final response = await Api().get("/route-checklists/$id");

    return ApiRouteChecklist.fromJson(response);
  }

  static Future<void> create(String title, String? description) async {
    await Api().post("/route-checklists", {
      "title": title,
      "description": description,
    });
  }

  Future<void> addLine(String lineId) async {
    await Api().post("/route-checklists/$id/items/$lineId", {});
  }

  Future<void> addOperator(String operatorId) async {
    await Api().post("/route-checklists/$id/items/operators/$operatorId", {});
  }
}
