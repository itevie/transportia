import 'package:flutter/material.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/widgets/favourite_icon.dart';
import 'package:transportia/widgets/image_card.dart';

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
            print("hi");
            load();
          },
          compact: true,
        ),
      );
    }

    return ImageCard(
      title: photo.displyName,
      url: photo.withSize(200),
      badges: badges,
      onTap: widget.onTap,
    );
  }
}
