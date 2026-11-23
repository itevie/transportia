import 'package:flutter/material.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/comment.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/widgets/util/cm_base.dart';
import 'package:transportia/widgets/lists/model_bus_list.dart';
import 'package:transportia/widgets/pages/search/bus_photo_search_page.dart';
import 'package:transportia/widgets/pages/search/vehicle_search.dart';
import 'package:transportia/widgets/util/object_labels.dart';
import 'package:transportia/widgets/util/tab_bar.dart';
import 'package:transportia/widgets/comment_thread.dart';
import 'package:transportia/widgets/favourite_icon.dart';
import 'package:transportia/widgets/flickr_grid.dart';
import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/util/withdrawn.dart';

class VehicleTypePage extends StatefulWidget {
  final ApiBtVehicleType vehicleType;
  const VehicleTypePage({super.key, required this.vehicleType});

  @override
  State<VehicleTypePage> createState() => _VehicleTypePageState();
}

class _VehicleTypePageState extends State<VehicleTypePage> {
  late ApiBtVehicleType vehicleType;
  List<ApiPhoto> photos = [];
  List<ApiComment> comments = [];
  List<ApiModelBus> potentialModels = [];

  @override
  void initState() {
    super.initState();

    vehicleType = widget.vehicleType;

    load();
    // loadComments();
  }

  void load({bool reload = false}) async {
    // final loadedPhotos = await ApiPhoto.fetchAll(search: widget.vehicle.reg);
    final matches = await ApiModelBus.search(vehicleTypeLink: vehicleType.id);

    // // ApiBtVehicle? vehicle;
    // // if (reload) {
    // //   loadVehicle();
    // // }

    setState(() {
      // photos = loadedPhotos;
      potentialModels = matches;
    });
  }

  // void loadComments() async {
  //   final comments = widget.vehicle.commentThread == null
  //       ? null
  //       : await ApiComment.fetchByThread(widget.vehicle.commentThread!);

  //   setState(() {
  //     if (comments != null) this.comments = comments;
  //   });
  // }

  void loadVehicle() async {
    final vehicleType = await ApiBtVehicleType.get(widget.vehicleType.id);

    setState(() {
      if (vehicleType != null) this.vehicleType = vehicleType;
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              vehicleType.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Spacer(),
                    // Column(
                    //   children: [
                    //     FavouriteButton(
                    //       type: FavouriteType.vehicle,
                    //       id: vehicleType.id.toString(),
                    //       isFavourited: vehicleType.isFavourited,
                    //       onChanged: () async => loadVehicle(),
                    //     ),
                    //     createCm(context, [], vehicleType),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child: AppTabController(
            tabs: [
              AppTab(
                id: "photos",
                name: "Photos",
                icon: Icons.camera,
                child: BusPhotoSearchPage(
                  isNested: true,
                  vehicleType: vehicleType,
                ),
              ),
              AppTab(
                id: "vehicles",
                name: "Vehicles",
                icon: Icons.camera,
                child: VehicleSearchPage(
                  isNested: true,
                  vehicleType: vehicleType,
                ),
              ),
              // AppTab(
              //   id: "comments",
              //   name: "Comments (${comments.length})",
              //   icon: Icons.comment,
              //   child: Padding(
              //     padding: EdgeInsetsGeometry.all(8),
              //     child: CommentThread(
              //       threadId: widget.vehicle.commentThread!,
              //       comments: comments,
              //       onChange: () {
              //         loadComments();
              //       },
              //     ),
              //   ),
              // ),
              if (potentialModels.isNotEmpty)
                AppTab(
                  id: "models",
                  name: "Models (${potentialModels.length})",
                  icon: Icons.directions_bus,
                  child: Column(
                    children: [
                      const Text(
                        "These are potential models based on the vehicle type.",
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ModelBusList(modelBuses: potentialModels),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
