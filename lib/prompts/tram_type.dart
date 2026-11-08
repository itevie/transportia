import 'package:flutter/material.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiTramType?> showTramTypeSearchPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ApiTramType>(
    title: "Search Tram Types",
    context: context,
    search: (q) async {
      var results = await ApiTramType.search(q);
      return results;
    },
    widgetBuilder: (type) => Text(type.name),
  );

  return value;
}
