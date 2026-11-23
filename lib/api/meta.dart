import 'package:transportia/api/api.dart';

enum AllowedUniqueFilters {
  vehicles('vehicles'),
  trams('trams');

  final String value;

  const AllowedUniqueFilters(this.value);
}

class ApiMeta {
  ApiMeta._();

  static final ApiMeta instance = ApiMeta._();

  late String cdn;
  late Map<String, List<String>> presets;
  late List<String> modelBusManufacturers;
  late Map<String, List<String>> allowedUniqueFilters;

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

    modelBusManufacturers = (json['model_bus_manufacturers'] as List)
        .whereType<String>()
        .toList();

    allowedUniqueFilters =
        (json['allowed_unique_filters'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        );

    _initialized = true;
  }

  List<String> getUniqueFilters(AllowedUniqueFilters filter) {
    return allowedUniqueFilters[filter.value] ?? [];
  }
}
