import 'package:flutter/material.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiTxLine?> showLinePrompt({required BuildContext context}) async {
  final value = await showSearchPrompt<ApiTxLine>(
    title: "Search Services",
    context: context,
    search: (q) async {
      var results = await ApiTxLine.fetchAll(search: q);
      return results;
    },
    widgetBuilder: (v) =>
        Text("${v.name} ${v.outboundDescription ?? v.inboundDescription}"),
  );

  return value;
}
