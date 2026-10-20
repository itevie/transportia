import 'package:flutter/material.dart';
import 'package:transportia/api/user.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiUser?> showUserSearchPrompt({required BuildContext context}) async {
  final value = await showSearchPrompt<ApiUser>(
    title: "Search Users",
    context: context,
    search: (q) async {
      var results = await ApiUser.search(q);
      return results;
    },
    widgetBuilder: (operator) => Text(operator.username),
  );

  return value;
}
