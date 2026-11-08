import 'package:transportia/api/api.dart';

class ApiMeta {
  ApiMeta._();

  static final ApiMeta instance = ApiMeta._();

  late String cdn;
  late Map<String, List<String>> presets;
  late List<String> modelBusManufacturers;

  bool _initialized = false;

  bool get initialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;

    final data = await Api().get('/meta');
    final json = data as Map<String, dynamic>;

    cdn = json['cdn'] as String;
    presets = (json['presets'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, List<String>.from(value)),
    );
    modelBusManufacturers = (json["model_bus_manufacturers"] as List)
        .whereType<String>()
        .toList();

    _initialized = true;
  }
}
