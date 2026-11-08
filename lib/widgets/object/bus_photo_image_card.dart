import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/favourites_group.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/prompts/favourites_group_search.dart';
import 'package:transportia/widgets/util/drop_down.dart';
import 'package:transportia/widgets/favourite_icon.dart';
import 'package:transportia/widgets/object/image_card.dart';

class BusPhotoImageCard extends StatefulWidget {
  final ApiFilledOutPhotoBus photo;
  final VoidCallback? onTap;
  const BusPhotoImageCard({super.key, required this.photo, this.onTap});

  @override
  State<BusPhotoImageCard> createState() => _BusPhotoImageCardState();
}

class _BusPhotoImageCardState extends State<BusPhotoImageCard> {
  late ApiFilledOutPhotoBus photo;

  @override
  void initState() {
    super.initState();

    photo = widget.photo;
  }

  void load() async {
    final loaded = await ApiFilledOutPhotoBus.fetch(photo.id);

    setState(() {
      photo = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    var badges = <Widget>[];
    if (photo.objDetails == null ||
        (photo.objDetails!.matchedVehicleId == null &&
            photo.objDetails!.reg == null &&
            photo.objDetails!.fleet == null &&
            photo.objDetails!.liveryId == null &&
            photo.objDetails!.vehicleTypeId == null &&
            photo.objDetails!.routeId == null)) {
      badges.add(
        Tooltip(
          message: "This photo has no details filled out",
          child: const Icon(Icons.warning, color: Colors.yellow),
        ),
      );
    }

    if (photo.isFavourited != null) {
      badges.add(
        FavouriteButton(
          type: FavouriteType.photo,
          id: photo.id.toString(),
          isFavourited: photo.isFavourited,
          onChanged: () async {
            load();
          },
          compact: true,
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: ImageCard(
            title: photo.displyName,
            url: photo.withSize(200),
            badges: badges,
            onTap: widget.onTap,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: TDropDownMenu(
            options: {},
            loadOptions: () async {
              final favourite = await ApiFavourite.get(
                FavouriteType.photo,
                photo.id,
              );

              return {
                if (favourite == null)
                  'Favourite': () async {
                    await ApiFavourite.create(
                      FavouriteType.photo,
                      photo.id.toString(),
                    );
                    load();
                  },
                if (favourite != null)
                  'Unfavourite': () async {
                    await ApiFavourite.delete(
                      FavouriteType.photo,
                      photo.id.toString(),
                    );
                  },
                if (favourite != null && favourite.group != null)
                  'Remove Favourite Group': () async {
                    await favourite.setGroup(null);
                    load();
                  },
                if (favourite != null)
                  'Change Favourite Group': () async {
                    final group = await showFavouritesGroupSearch(
                      context: context,
                      t: FavouriteType.photo,
                    );

                    if (group == null) return;

                    await favourite.setGroup(group.id);
                    load();
                  },
              };
            },
            showOnSecondaryClick: false,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
