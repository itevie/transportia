import 'package:flutter/material.dart';
import 'package:transportia/api/meta.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<MapEntry<String, List<String>>?> showServicePresetPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<MapEntry<String, List<String>>?>(
    title: "Route Presets",
    context: context,
    search: (_) async {
      var results = ApiMeta.instance.presets.entries.toList();
      return results;
    },
    widgetBuilder: (operator) => Text(operator?.key ?? ""),
    showSearch: false,
  );

  return value;
}
