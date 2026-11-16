import 'package:transportia/api/api.dart';
import 'package:transportia/constants.dart';

class ApiTramAnnouncementAudio {
  final int id;
  final String fileName;
  final String audioGroup;
  final String? label;
  final int? operatorId;
  final int? routeId;
  final int? nextStopId;
  final String createdAt;

  String get audioUrl => "${Api().baseUrl}/tram-announcement-audios/$id/file";

  ApiTramAnnouncementAudio({
    required this.id,
    required this.fileName,
    required this.audioGroup,
    this.label,
    this.operatorId,
    this.routeId,
    this.nextStopId,
    required this.createdAt,
  });

  factory ApiTramAnnouncementAudio.fromJson(Map<String, dynamic> json) {
    return ApiTramAnnouncementAudio(
      id: json["id"],
      fileName: json["file_name"],
      audioGroup: json["audio_group"],
      label: json["label"],
      operatorId: json["operator_id"],
      routeId: json["route_id"],
      nextStopId: json["next_stop_id"],
      createdAt: json["created_at"],
    );
  }

  ApiTramAnnouncementAudio copyWith({
    int? id,
    String? fileName,
    String? audioGroup,
    String? label,
    int? operatorId,
    int? routeId,
    int? nextStopId,
    String? createdAt,
  }) {
    return ApiTramAnnouncementAudio(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      audioGroup: audioGroup ?? this.audioGroup,
      label: label ?? this.label,
      operatorId: operatorId ?? this.operatorId,
      routeId: routeId ?? this.routeId,
      nextStopId: nextStopId ?? this.nextStopId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static Future<List<ApiTramAnnouncementAudio>> search({
    String? fileName,
    String? audioGroup,
    String? label,
    int? operatorId,
    int? routeId,
    int? nextStopId,
    String? search,
    int? pageLength = pageSize,
    int? offset,
  }) async {
    String query = "";

    var parts = [
      ("file_name", fileName),
      ("audio_group", audioGroup),
      ("label", label),
      ("operator", operatorId),
      ("route", routeId),
      ("next_stop", nextStopId),
      ("search", search),
      ("page_length", pageLength),
      ("offset", offset),
    ].where((x) => x.$2 != null);

    for (var x in parts.indexed) {
      query += x.$1 == 0 ? "?" : "&";
      query += "${x.$2.$1}=${Uri.encodeQueryComponent(x.$2.$2.toString())}";
    }

    final data = await Api().get("/tram-announcement-audios$query");

    return (data as List)
        .map((json) => ApiTramAnnouncementAudio.fromJson(json))
        .toList();
  }

  static Future<ApiTramAnnouncementAudio?> get(int id) async {
    final data = await Api().get("/tram-announcement-audios/$id");

    if (data == null) {
      return null;
    }

    return ApiTramAnnouncementAudio.fromJson(data);
  }

  static Future<List<String>> getGroups() async {
    final data = await Api().get("/tram-announcement-audios/groups");

    return (data as List).map((group) => group.toString()).toList();
  }

  Future<void> updateAudio({
    String? fileName,
    String? audioGroup,
    String? label,
    int? operatorId,
    int? routeId,
    int? nextStopId,
  }) async {
    await Api().patch("/tram-announcement-audios/$id", {
      "file_name": fileName,
      "audio_group": audioGroup,
      "label": label,
      "operator_id": operatorId,
      "route_id": routeId,
      "next_stop_id": nextStopId,
    });
  }
}
