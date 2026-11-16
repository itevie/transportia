import 'package:flutter/material.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiModelBus?> showModelBusSearchPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ApiModelBus>(
    title: "Search Tram Types",
    context: context,
    search: (q) async {
      var results = await ApiModelBus.search(search: q);
      return results;
    },
    widgetBuilder: (type) => Text(type.displayName),
  );

  return value;
}
