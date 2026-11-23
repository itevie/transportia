import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/favourites_group.dart';
import 'package:transportia/widgets/prompts/generic_search.dart';
import 'package:transportia/stores/current_user_store.dart';

Future<ApiFavouriteGroup?> showFavouritesGroupSearch({
  required BuildContext context,
  required FavouriteType t,
}) async {
  final value = await showSearchPrompt<ApiFavouriteGroup>(
    title: "Search Groups",
    context: context,
    search: (_) async {
      final currentUser = context.read<CurrentUserStore>().user;
      if (currentUser == null) return [];

      var results = await ApiFavouriteGroup.getAll(currentUser.id);
      return results.where((x) => x.favouriteType == t).toList();
    },
    widgetBuilder: (group) => Text(group.name),
    showSearch: false,
  );

  return value;
}
