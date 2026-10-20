import 'package:transportia/api/api.dart';
import 'package:transportia/api/tx_line.dart';

class ApiRouteChecklistItem {
  final int id;

  final int checklistId;
  final String lineId;
  final ApiTxLine line;

  final String addedAt;
  final String? completedAt;

  ApiRouteChecklistItem({
    required this.id,
    required this.checklistId,
    required this.lineId,
    required this.addedAt,
    required this.line,
    this.completedAt,
  });

  factory ApiRouteChecklistItem.fromJson(Map<String, dynamic> json) {
    return ApiRouteChecklistItem(
      id: json["id"],
      checklistId: json["checklist_id"],
      lineId: json["line_id"],
      line: ApiTxLine.fromJson(json["line"]),
      addedAt: json["added_at"],
      completedAt: json["completed_at"],
    );
  }

  Future<void> toggleCompleted() async {
    await Api().post(
      "/route-checklists/$checklistId/items/$id/toggle-completed",
      {},
    );
  }
}
