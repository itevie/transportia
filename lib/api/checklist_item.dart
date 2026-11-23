import 'package:transportia/api/api.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/tx_line.dart';

class ApiChecklistItem {
  final int id;

  final int checklistId;
  final String objId;
  final dynamic obj;

  final String addedAt;
  final String? completedAt;

  ApiTxLine get txLine => ApiTxLine.fromJson(obj);
  ApiBtVehicle get vehicle => ApiBtVehicle.fromJson(obj);

  ApiChecklistItem({
    required this.id,
    required this.checklistId,
    required this.objId,
    required this.addedAt,
    this.completedAt,
    this.obj,
  });

  factory ApiChecklistItem.fromJson(Map<String, dynamic> json) {
    return ApiChecklistItem(
      id: json["id"],
      checklistId: json["checklist_id"],
      objId: json["obj_id"],
      obj: json["obj"],
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
