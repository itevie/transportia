import 'package:flutter/material.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/main_old.dart';
import 'package:transportia/util_widgets/clickable.dart';
import 'package:transportia/util_widgets/sub_text.dart';
import 'package:transportia/util_widgets/tab_bar.dart';
import 'package:transportia/widgets/favourite_icon.dart';
import 'package:transportia/widgets/flickr_grid.dart';
import 'package:transportia/widgets/lists/bus_photos_list.dart';
import 'package:transportia/widgets/pages/operator_page.dart';
import 'package:transportia/widgets/withdrawn.dart';

class VehiclePage extends StatefulWidget {
  final ApiBtVehicle vehicle;
  const VehiclePage({super.key, required this.vehicle});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  late ApiBtVehicle vehicle;
  List<ApiFilledOutPhotoBus> photos = [];

  @override
  void initState() {
    super.initState();

    vehicle = widget.vehicle;

    load();
  }

  void load({bool reload = false}) async {
    final loadedPhotos = await ApiFilledOutPhotoBus.fetchAll(
      search: widget.vehicle.reg,
    );

    ApiBtVehicle? vehicle;
    if (reload) {
      vehicle = await ApiBtVehicle.get(widget.vehicle.id);
    }

    setState(() {
      photos = loadedPhotos;

      if (vehicle != null) {
        this.vehicle = vehicle;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${vehicle.reg} - ${vehicle.fleet}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (vehicle.withdrawn) ...[
                      const SizedBox(width: 8),
                      const Withdrawn(),
                    ],
                    Spacer(),
                    FavouriteButton(
                      type: FavouriteType.vehicle,
                      id: vehicle.id.toString(),
                      isFavourited: vehicle.isFavourited,
                      onChanged: () async => load(reload: true),
                    ),
                  ],
                ),
                Text(vehicle.livery?.name ?? ""),
                if (vehicle.operator != null)
                  Clickable(
                    onTap: () {
                      setAppPage(OperatorPage(operator: vehicle.operator!));
                    },
                    child: SubText(
                      "Operated by ${vehicle.operator!.shortName} (${vehicle.operator!.nationalCode})",
                    ),
                  ),
              ],
            ),
          ),
        ),

        Expanded(
          child: AppTabController(
            tabs: [
              AppTab(
                name: "Photos",
                icon: Icons.camera,
                child: SingleChildScrollView(
                  child: BusPhotoList(photos: photos),
                ),
              ),
              AppTab(
                name: "Flickr Photos",
                icon: Icons.camera,
                child: SingleChildScrollView(
                  child: FlickrGrid(tags: vehicle.reg),
                ),
              ),
              AppTab(
                name: "Comments",
                icon: Icons.comment,
                child: SingleChildScrollView(
                  child: FlickrGrid(tags: vehicle.reg),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
