import 'package:flutter/material.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiBtLivery?> showLiverySearchPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ApiBtLivery>(
    title: "Search Liveries",
    context: context,
    search: (q) async {
      var results = await ApiBtLivery.search(q);
      return results;
    },
    widgetBuilder: (livery) => Text(livery.name),
  );

  return value;
}
