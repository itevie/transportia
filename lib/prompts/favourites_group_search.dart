import 'package:flutter/material.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/favourites_group.dart';
import 'package:transportia/prompts/generic_search.dart';

Future<ApiFavouriteGroup?> showFavouritesGroupSearch({
  required BuildContext context,
  required FavouriteType t,
}) async {
  final value = await showSearchPrompt<ApiFavouriteGroup>(
    title: "Search Groups",
    context: context,
    search: (_) async {
      var results = await ApiFavouriteGroup.getAll();
      return results.where((x) => x.favouriteType == t).toList();
    },
    widgetBuilder: (group) => Text(group.name),
    showSearch: false,
  );

  return value;
}
