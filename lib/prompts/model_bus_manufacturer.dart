import 'package:flutter/material.dart';
import 'package:transportia/api/meta.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<String?> showModelBusManufacturerPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<String>(
    title: "Search Manufacturers",
    context: context,
    search: (q) async {
      var results = ApiMeta.instance.modelBusManufacturers;
      return results
          .where((x) => x.toLowerCase().contains(q.toLowerCase()))
          .toList();
    },
    widgetBuilder: (m) => Text(m),
  );

  return value;
}
