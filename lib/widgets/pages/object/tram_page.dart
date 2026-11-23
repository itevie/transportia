import 'package:flutter/material.dart';
import 'package:transportia/api/comment.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_photo_details.dart';
import 'package:transportia/widgets/util/cm_base.dart';
import 'package:transportia/widgets/util/object_labels.dart';
import 'package:transportia/widgets/util/tab_bar.dart';
import 'package:transportia/widgets/favourite_icon.dart';
import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/util/withdrawn.dart';

class TramPage extends StatefulWidget {
  final ApiTram vehicle;
  const TramPage({super.key, required this.vehicle});

  @override
  State<TramPage> createState() => _TramPageState();
}

class _TramPageState extends State<TramPage> {
  late ApiTram vehicle;
  List<ApiPhoto> photos = [];
  List<ApiComment> comments = [];
  List<ApiModelBus> potentialModels = [];

  @override
  void initState() {
    super.initState();

    vehicle = widget.vehicle;

    load();
    // loadComments();
  }

  void load({bool reload = false}) async {
    final loadedPhotos = await ApiTramPhotoDetails.fetchAll(
      tdVehicleId: vehicle.id,
    );

    // final matches = await ApiModelBus.searchPotentialMatchesForVehicle(
    //   widget.vehicle.reg,
    // );

    // ApiBtVehicle? vehicle;
    // if (reload) {
    //   loadVehicle();
    // }

    setState(() {
      photos = loadedPhotos;
      // potentialModels = matches;
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
    final vehicle = await ApiTram.get(widget.vehicle.id);

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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              vehicle.displayName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (vehicle.withdrawn) ...[
                              const SizedBox(width: 8),
                              const Withdrawn(),
                            ],
                          ],
                        ),

                        // if (vehicle.livery != null)
                        //   LiveryLabel(livery: vehicle.livery!),
                        if (vehicle.operator != null)
                          TramOperatorLabel(
                            leadingText: "Operated by ",
                            operator: vehicle.operator!,
                          ),
                      ],
                    ),

                    Spacer(),
                    Column(
                      children: [
                        FavouriteButton(
                          type: FavouriteType.tram,
                          id: vehicle.id.toString(),
                          isFavourited: vehicle.isFavourited,
                          onChanged: () async => loadVehicle(),
                        ),
                        createCm(context, [], vehicle),
                      ],
                    ),
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
                child: SingleChildScrollView(child: PhotoList(photos: photos)),
              ),
              // AppTab(
              //   id: "flickr_photos",
              //   name: "Flickr Photos",
              //   icon: Icons.camera,
              //   child: SingleChildScrollView(
              //     child: FlickrGrid(tags: vehicle.reg),
              //   ),
              // ),
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
              // if (potentialModels.isNotEmpty)
              //   AppTab(
              //     id: "models",
              //     name: "Models (${potentialModels.length})",
              //     icon: Icons.directions_bus,
              //     child: Column(
              //       children: [
              //         const Text(
              //           "These are potential models based on the registration.",
              //         ),
              //         const SizedBox(height: 8),
              //         Expanded(
              //           child: SingleChildScrollView(
              //             child: ModelBusList(modelBuses: potentialModels),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
            ],
          ),
        ),
      ],
    );
  }
}
