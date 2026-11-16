import 'package:flutter/material.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiTram?> showTramSearchPrompt({required BuildContext context}) async {
  final value = await showSearchPrompt<ApiTram>(
    title: "Search Tram Types",
    context: context,
    search: (q) async {
      var results = await ApiTram.search(search: q);
      return results;
    },
    widgetBuilder: (type) => Text(type.displayName),
  );

  return value;
}
