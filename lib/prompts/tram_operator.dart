import 'package:flutter/material.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiTramOperator?> showTramOperatorSearchPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ApiTramOperator>(
    title: "Search Tram Operators",
    context: context,
    search: (q) async {
      var results = await ApiTramOperator.search(q);
      return results;
    },
    widgetBuilder: (operator) => Text(operator.name),
  );

  return value;
}
