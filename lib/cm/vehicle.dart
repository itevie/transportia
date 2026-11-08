import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/prompts/favourites_group_search.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/widgets/util/drop_down.dart';

Widget vehicleContextMenu(
  BuildContext context, {
  required ApiBtVehicle vehicle,
  Widget? child,
}) {
  final user = context.read<CurrentUserStore>();

  if (user.loggedIn == false) return SizedBox.shrink();

  return TDropDownMenu(
    options: {},
    loadOptions: () async {
      final favourite = await ApiFavourite.get(
        FavouriteType.vehicle,
        vehicle.id,
      );
      return {
        if (user.loggedIn && user.user!.trustedUser)
          'Edit Vehicle': () async {
            context.go("/vehicle/${vehicle.id}/edit");
          },

        if (favourite == null)
          'Favourite': () async {
            await ApiFavourite.create(
              FavouriteType.vehicle,
              vehicle.id.toString(),
            );
          },
        if (favourite != null)
          'Unfavourite': () async {
            await ApiFavourite.delete(
              FavouriteType.vehicle,
              vehicle.id.toString(),
            );
          },
        if (favourite?.group != null)
          'Remove Favourite Group': () async {
            await favourite?.setGroup(null);
          },
        if (favourite != null)
          'Change Favourite Group': () async {
            final group = await showFavouritesGroupSearch(
              context: context,
              t: FavouriteType.vehicle,
            );

            if (group == null) return;

            await favourite.setGroup(group.id);
          },
      };
    },
    child:
        child ??
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
  );
}
