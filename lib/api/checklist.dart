import 'package:flutter/material.dart';
import 'package:transportia/api/api.dart';
import 'package:transportia/api/checklist_item.dart';
import 'package:transportia/api/tx_line.dart';

class ApiChecklist {
  final int id;

  final String title;
  final String? description;

  final int ownerId;

  final String createdAt;

  final ChecklistType checklistType;

  final int itemCount;
  final int completedItemCount;

  ApiChecklist({
    required this.id,
    required this.title,
    this.description,
    required this.ownerId,
    required this.createdAt,
    required this.itemCount,
    required this.completedItemCount,
    required this.checklistType,
  });

  factory ApiChecklist.fromJson(Map<String, dynamic> json) {
    return ApiChecklist(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      ownerId: json["owner_id"],
      createdAt: json["created_at"],
      itemCount: json["item_count"],
      completedItemCount: json["completed_item_count"],
      checklistType: ChecklistType.fromJson(json["checklist_type"]),
    );
  }

  static Future<List<ApiChecklist>> fetchAll() async {
    final response = await Api().get("/route-checklists");

    return (response as List)
        .map((json) => ApiChecklist.fromJson(json))
        .toList();
  }

  static Future<ApiChecklist> fetch(int id) async {
    final response = await Api().get("/route-checklists/$id");

    return ApiChecklist.fromJson(response);
  }

  Future<List<ApiChecklistItem>> getItems() async {
    final response = await Api().get("/route-checklists/$id/items");

    return (response as List)
        .map((item) => ApiChecklistItem.fromJson(item))
        .toList();
  }

  static Future<void> create(
    ChecklistType t,
    String title,
    String? description,
  ) async {
    await Api().post("/route-checklists", {
      "title": title,
      "description": description,
      "checklist_type": t.apiValue,
    });
  }

  Future<void> addObj(String objId) async {
    await Api().post("/route-checklists/$id/items/$objId", {});
  }

  Future<void> addOperator(String operatorId) async {
    await Api().post("/route-checklists/$id/items/operators/$operatorId", {});
  }

  Future<void> addBulkOperator(List<String> operators) async {
    await Api().post("/route-checklists/$id/items/operators-bulk", operators);
  }

  static Future<int> countBulkOperator(
    List<String> operators,
    ChecklistType t,
  ) async {
    final data = await Api().post(
      "/route-checklists/items/operators-bulk/count",
      {"operators": operators, "checklist_type": t.apiValue},
    );

    return data as int;
  }
}

enum ChecklistType {
  service(0, "Service", Icons.route),
  vehicle(1, "Vehicle", Icons.directions_bus);

  final int value;
  final String apiValue;
  final IconData icon;

  const ChecklistType(this.value, this.apiValue, this.icon);

  static ChecklistType fromJson(String value) {
    return ChecklistType.values.firstWhere((type) => type.apiValue == value);
  }
}
