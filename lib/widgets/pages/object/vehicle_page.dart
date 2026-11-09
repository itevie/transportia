import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/comment.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/cm/vehicle.dart';
import 'package:transportia/widgets/util/clickable.dart';
import 'package:transportia/widgets/util/sub_text.dart';
import 'package:transportia/widgets/util/tab_bar.dart';
import 'package:transportia/widgets/comment_thread.dart';
import 'package:transportia/widgets/favourite_icon.dart';
import 'package:transportia/widgets/flickr_grid.dart';
import 'package:transportia/widgets/lists/bus_photos_list.dart';
import 'package:transportia/widgets/util/withdrawn.dart';

class VehiclePage extends StatefulWidget {
  final ApiBtVehicle vehicle;
  const VehiclePage({super.key, required this.vehicle});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  late ApiBtVehicle vehicle;
  List<ApiFilledOutPhotoBus> photos = [];
  List<ApiComment> comments = [];

  @override
  void initState() {
    super.initState();

    vehicle = widget.vehicle;

    load();
    loadComments();
  }

  void load({bool reload = false}) async {
    final loadedPhotos = await ApiFilledOutPhotoBus.fetchAll(
      search: widget.vehicle.reg,
    );

    // ApiBtVehicle? vehicle;
    // if (reload) {
    //   loadVehicle();
    // }

    setState(() {
      photos = loadedPhotos;
    });
  }

  void loadComments() async {
    final comments = widget.vehicle.commentThread == null
        ? null
        : await ApiComment.fetchByThread(widget.vehicle.commentThread!);

    setState(() {
      if (comments != null) this.comments = comments;
    });
  }

  void loadVehicle() async {
    final vehicle = await ApiBtVehicle.get(widget.vehicle.id);

    setState(() {
      if (vehicle != null) this.vehicle = vehicle;
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
                    Column(
                      children: [
                        FavouriteButton(
                          type: FavouriteType.vehicle,
                          id: vehicle.id.toString(),
                          isFavourited: vehicle.isFavourited,
                          onChanged: () async => loadVehicle(),
                        ),
                        vehicleContextMenu(context, vehicle: vehicle),
                      ],
                    ),
                  ],
                ),
                Text(vehicle.livery?.name ?? ""),
                if (vehicle.operator != null)
                  Clickable(
                    onTap: () {
                      context.go("/operator/${vehicle.operator!.id}");
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
                name: "Comments (${comments.length})",
                icon: Icons.comment,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: CommentThread(
                    threadId: widget.vehicle.commentThread!,
                    comments: comments,
                    onChange: () {
                      loadComments();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
