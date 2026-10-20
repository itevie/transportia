import 'package:flutter/material.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiTxOperator?> showOperatorSearchPrompt({
  required BuildContext context,
}) async {
  final value = await showSearchPrompt<ApiTxOperator>(
    title: "Search Operators",
    context: context,
    search: (q) async {
      var results = await ApiTxOperator.search(q);
      return results;
    },
    widgetBuilder: (operator) => Text(
      "${operator.shortName} (${operator.code} ${operator.nationalCode})",
    ),
  );

  return value;
}
