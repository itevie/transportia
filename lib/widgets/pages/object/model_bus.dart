import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bus_listing.dart';
import 'package:transportia/api/comment.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/model_bus_photo_details.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/cm/vehicle.dart';
import 'package:transportia/util/util.dart';
import 'package:transportia/widgets/lists/model_bus_list.dart';
import 'package:transportia/widgets/lists/model_bus_listings.dart';
import 'package:transportia/widgets/util/clickable.dart';
import 'package:transportia/widgets/util/sub_text.dart';
import 'package:transportia/widgets/util/tab_bar.dart';
import 'package:transportia/widgets/comment_thread.dart';
import 'package:transportia/widgets/favourite_icon.dart';
import 'package:transportia/widgets/flickr_grid.dart';
import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/util/withdrawn.dart';

import '../../livery/livery.dart';

class ModelBusPage extends StatefulWidget {
  final ApiModelBus modelBuss;
  const ModelBusPage({super.key, required this.modelBuss});

  @override
  State<ModelBusPage> createState() => _ModelBusPageState();
}

class _ModelBusPageState extends State<ModelBusPage> {
  late ApiModelBus vehicle;
  List<ApiPhoto> photos = [];
  List<ApiComment> comments = [];
  List<ApiBusListingResource> potentialModels = [];

  @override
  void initState() {
    super.initState();

    vehicle = widget.modelBuss;

    load();
    // loadComments();
  }

  void load({bool reload = false}) async {
    final loadedPhotos = await ApiModelBusPhotoDetails.fetchAll(
      mbdModelId: widget.modelBuss.id,
    );
    final matches = await ApiBusListingResource.fetchPossibleModelBusMatches(
      widget.modelBuss,
    );

    // ApiBtVehicle? vehicle;
    // if (reload) {
    //   loadVehicle();
    // }

    setState(() {
      photos = loadedPhotos;
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

  // void loadVehicle() async {
  //   final vehicle = await ApiBtVehicle.get(widget.vehicle.id);

  //   setState(() {
  //     if (vehicle != null) this.vehicle = vehicle;
  //   });
  // }

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
                      "1:${vehicle.scale} ${vehicle.manufacturer} - ${vehicle.productCode}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Spacer(),
                    // Column(
                    //   children: [
                    //     FavouriteButton(
                    //       type: FavouriteType.vehicle,
                    //       id: vehicle.id.toString(),
                    //       isFavourited: vehicle.isFavourited,
                    //       onChanged: () async => loadVehicle(),
                    //     ),
                    //     vehicleContextMenu(context, vehicle: vehicle),
                    //   ],
                    // ),
                  ],
                ),
                if (vehicle.livery != null || vehicle.liveryObj != null)
                  Row(
                    children: [
                      if (!isLinux() && vehicle.liveryObj != null) ...[
                        LiveryView(livery: vehicle.liveryObj!),
                        const SizedBox(width: 8),
                      ],
                      Text(vehicle.liveryObj?.name ?? vehicle.livery ?? ""),
                    ],
                  ),
                // if (vehicle.operator != null)
                //   Clickable(
                //     onTap: () {
                //       context.go("/operator/${vehicle.operator!.id}");
                //     },
                //     child: SubText(
                //       "Operated by ${vehicle.operator!.shortName} (${vehicle.operator!.nationalCode})",
                //     ),
                //   ),
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
                child: SingleChildScrollView(child: PhotoList(photos: photos)),
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
                  name: "Listings (${potentialModels.length})",
                  icon: Icons.directions_bus,
                  child: Column(
                    children: [
                      const Text(
                        "These are potential listings based on the product code.",
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ModelBusListingsList(
                            listings: potentialModels,
                          ),
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
