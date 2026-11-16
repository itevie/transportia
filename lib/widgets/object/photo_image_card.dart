import 'package:flutter/material.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/cm/cm_base.dart';
import 'package:transportia/prompts/favourites_group_search.dart';
import 'package:transportia/widgets/util/drop_down.dart';
import 'package:transportia/widgets/favourite_icon.dart';
import 'package:transportia/widgets/object/image_card.dart';

class BusPhotoImageCard extends StatefulWidget {
  final ApiPhoto photo;
  final VoidCallback? onTap;
  const BusPhotoImageCard({super.key, required this.photo, this.onTap});

  @override
  State<BusPhotoImageCard> createState() => _BusPhotoImageCardState();
}

class _BusPhotoImageCardState extends State<BusPhotoImageCard> {
  late ApiPhoto photo;

  @override
  void initState() {
    super.initState();

    photo = widget.photo;
  }

  void load() async {
    final loaded = await ApiPhoto.fetch(photo.id);

    setState(() {
      photo = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    var badges = <Widget>[];
    final noDetails = [
      photo.bus?.matchedVehicleId,
      photo.bus?.reg,
      photo.bus?.fleet,
      photo.bus?.liveryId,
      photo.bus?.vehicleTypeId,
      photo.bus?.routeId,

      photo.tram?.matchedVehicleId,
      photo.tram?.fleet,
      photo.tram?.liveryId,
      photo.tram?.operatorId,
      photo.tram?.vehicleTypeId,

      photo.modelBus?.matchedModel,
    ].every((x) => x == null);

    if (noDetails) {
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

    badges.add(Icon(photo.photoType.icon));

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
          child: createCm(
            context,
            [],
            photo,
            reload: load,
            secondaryClick: false,
          ),

          // DropDownMenu(
          //   options: {},
          //   loadOptions: () async {
          //     final favourite = await ApiFavourite.get(
          //       FavouriteType.photo,
          //       photo.id,
          //     );

          //     return {
          //       if (favourite == null)
          //         'Favourite': () async {
          //           await ApiFavourite.create(
          //             FavouriteType.photo,
          //             photo.id.toString(),
          //           );
          //           load();
          //         },
          //       if (favourite != null)
          //         'Unfavourite': () async {
          //           await ApiFavourite.delete(
          //             FavouriteType.photo,
          //             photo.id.toString(),
          //           );
          //         },
          //       if (favourite != null && favourite.group != null)
          //         'Remove Favourite Group': () async {
          //           await favourite.setGroup(null);
          //           load();
          //         },
          //       if (favourite != null)
          //         'Change Favourite Group': () async {
          //           final group = await showFavouritesGroupSearch(
          //             context: context,
          //             t: FavouriteType.photo,
          //           );

          //           if (group == null) return;

          //           await favourite.setGroup(group.id);
          //           load();
          //         },
          //     };
          //   },
          //   showOnSecondaryClick: false,
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: const Icon(Icons.more_vert),
          //     style: IconButton.styleFrom(
          //       backgroundColor: Colors.black54,
          //       foregroundColor: Colors.white,
          //     ),
          //   ),
          // ),
        ),
      ],
    );
  }
}
