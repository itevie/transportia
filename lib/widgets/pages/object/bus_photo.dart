import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/comment.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/api/photo_rating_response.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/main.dart';
import 'package:transportia/prompts/livery_search.dart';
import 'package:transportia/prompts/route_search.dart';
import 'package:transportia/prompts/todo.dart';
import 'package:transportia/prompts/vehicle_search.dart';
import 'package:transportia/prompts/vehicle_type_search.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/theme.dart';
import 'package:transportia/util/date.dart';
import 'package:transportia/widgets/util/drop_down.dart';
import 'package:transportia/widgets/util/panel.dart';
import 'package:transportia/widgets/comment_thread.dart';
import 'package:transportia/widgets/util/detail_chip.dart';
import 'package:transportia/widgets/favourite_icon.dart';
import 'package:transportia/widgets/profile_picture.dart';
import 'package:transportia/widgets/util/progressive_photo.dart';
import 'package:transportia/widgets/star_rating.dart';

class BusPhotoViewer extends StatefulWidget {
  final ApiFilledOutPhotoBus photo;
  const BusPhotoViewer({super.key, required this.photo});

  @override
  State<BusPhotoViewer> createState() => _BusPhotoViewerState();
}

class _BusPhotoViewerState extends State<BusPhotoViewer> {
  late ApiFilledOutPhotoBus photo;
  ApiPhotoRatingResponse? photoRating;

  List<ApiComment> comments = [];

  late TextEditingController reg;
  late TextEditingController fleet;
  ApiBtVehicleType? vt;
  ApiBtLivery? livery;
  ApiBtVehicle? vehicle;
  ApiTxLine? line;
  bool overwriteMatched = false;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    photo = widget.photo;

    reg = TextEditingController();
    fleet = TextEditingController();

    load(fetchPhoto: true);
  }

  void load({bool fetchPhoto = false}) async {
    ApiPhotoRatingResponse? rating;
    if (context.read<CurrentUserStore>().loggedIn) {
      rating = await widget.photo.getRating();
    }

    final comments = widget.photo.commentThread == null
        ? null
        : await ApiComment.fetchByThread(widget.photo.commentThread!);

    ApiFilledOutPhotoBus? photo;
    if (fetchPhoto) {
      photo = await ApiFilledOutPhotoBus.fetch(widget.photo.id);
    }

    setState(() {
      if (rating != null) photoRating = rating;
      if (comments != null) this.comments = comments;

      if (photo != null) {
        this.photo = photo;
      }
    });
  }

  void edit() {
    // print(photo.objDetails.)
    setState(() {
      isEditing = true;
      reg.text = photo.objDetails?.reg ?? "";
      fleet.text = photo.objDetails?.fleet ?? "";
      vt = photo.objDetails?.vehicleType;
      livery = photo.objDetails?.livery;
      overwriteMatched = photo.objDetails?.overrideMatch ?? false;
      line = photo.objDetails?.route;
      vehicle = photo.objDetails?.matchedVehicle;
    });
  }

  void cancelEdit() {
    setState(() {
      isEditing = false;
      reg.text = "";
      fleet.text = "";
      vt = null;
      livery = null;
      line = null;
      overwriteMatched = false;
      vehicle = null;
    });
  }

  void save() async {
    await photo.updateDetails(
      matchedVehicleId: vehicle?.id,
      overrideMatch: overwriteMatched,
      reg: reg.text.isEmpty ? null : reg.text,
      fleet: fleet.text.isEmpty ? null : fleet.text,
      liveryId: livery?.id,
      vehicleTypeId: vt?.id,
      routeId: line?.txId,
    );

    final loaded = await ApiFilledOutPhotoBus.fetch(photo.id);

    setState(() {
      photo = loaded;
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<CurrentUserStore>();
    final height = MediaQuery.sizeOf(context).height;
    final details = photo.objDetails;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height * 0.75),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Expanded(
                    //   child: Image.network(
                    //     "https://transportia-cdn.dawn.rest/${photo.uploadedId}",
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                    Expanded(
                      child: ProgressivePhotoImage(
                        thumbnailWidth: 200,
                        imageUrl: (width) => photo.withSize(width),
                      ),
                    ),

                    const SizedBox(width: seperatorPadding),

                    SizedBox(
                      width: 250,
                      child: Panel(
                        child: Column(
                          children: [
                            Material(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  context.go("/user/${photo.author.id}");
                                  // setAppPage(UserViewer(user: photo.author));
                                },
                                child: Row(
                                  children: [
                                    ProfilePicture(
                                      usage: ProfilePictureUsage.nextToName,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        photo.author.displayName ??
                                            photo.author.username,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (user.loggedIn &&
                                        user.user!.id == photo.author.id)
                                      isEditing
                                          ? Row(
                                              children: [
                                                IconButton(
                                                  key: Key("delete"),
                                                  onPressed: () async {
                                                    final confirmation =
                                                        await showConfirmPrompt(
                                                          context,
                                                          const Text(
                                                            "Confirm Deletion",
                                                          ),
                                                          Text(
                                                            "Are you sure you want to delete this photo? The photo and all it's details will be deleted and unrecoverable.",
                                                          ),
                                                        );

                                                    if (!confirmation) return;

                                                    await photo.delete();

                                                    if (lastUri != null) {
                                                      context.go(lastUri!);
                                                    } else {
                                                      context.go("/photos");
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                IconButton(
                                                  key: Key("cancel"),
                                                  onPressed: cancelEdit,
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: save,
                                                  icon: const Icon(Icons.save),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                IconButton(
                                                  key: Key("edit"),
                                                  onPressed: edit,
                                                  icon: const Icon(Icons.edit),
                                                ),
                                              ],
                                            ),
                                  ],
                                ),
                              ),
                            ),

                            const Divider(),

                            if (isEditing) ...[
                              TextField(
                                controller: fleet,
                                decoration: InputDecoration(
                                  hintText: "Fleet #",
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: reg,
                                decoration: InputDecoration(hintText: "Reg"),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () async {
                                        final res =
                                            await showLiverySearchPrompt(
                                              context: context,
                                            );

                                        if (res == null) return;

                                        setState(() {
                                          livery = res;
                                        });
                                      },
                                      label: Text(
                                        livery != null
                                            ? livery!.name
                                            : "Select Livery",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      icon: const Icon(Icons.palette),
                                    ),
                                  ),
                                  if (livery != null) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      tooltip: 'Clear livery',
                                      onPressed: () {
                                        setState(() {
                                          livery = null;
                                        });
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () async {
                                        final res =
                                            await showVehicleTypeSearchPrompt(
                                              context: context,
                                            );

                                        if (res == null) return;

                                        setState(() {
                                          vt = res;
                                        });
                                      },
                                      label: Text(
                                        vt != null
                                            ? vt!.name
                                            : "Select Vehicle Type",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      icon: const Icon(Icons.directions_bus),
                                    ),
                                  ),
                                  if (vt != null) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      tooltip: 'Clear vehicle type',
                                      onPressed: () {
                                        setState(() {
                                          vt = null;
                                        });
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () async {
                                        final res =
                                            await showvehicleSearchPrompt(
                                              context: context,
                                            );

                                        if (res == null) return;

                                        setState(() {
                                          vehicle = res;
                                        });
                                      },
                                      label: Text(
                                        vehicle != null
                                            ? "${vehicle?.reg} - ${vehicle?.fleet} (${vehicle?.operator?.nationalCode})"
                                            : "Select Vehicle",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      icon: const Icon(Icons.directions_bus),
                                    ),
                                  ),
                                  if (vehicle != null) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      tooltip: 'Clear vehicle',
                                      onPressed: () {
                                        setState(() {
                                          vehicle = null;
                                        });
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () async {
                                        final res = await showLinePrompt(
                                          context: context,
                                        );

                                        if (res == null) return;

                                        setState(() {
                                          line = res;
                                        });
                                      },
                                      label: Text(
                                        line != null
                                            ? "${line!.name} ${line!.outboundDescription ?? line!.inboundDescription}"
                                            : "Select Line",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      icon: const Icon(Icons.route),
                                    ),
                                  ),
                                  if (line != null) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      tooltip: 'Clear line',
                                      onPressed: () {
                                        setState(() {
                                          line = null;
                                        });
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Checkbox(
                                    value: overwriteMatched,
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() {
                                        overwriteMatched = v;
                                      });
                                    },
                                  ),
                                  Text("Overwrite Vehicle"),
                                  Spacer(),
                                  Tooltip(
                                    message:
                                        "If selected, your own details will take precedence over the matched vehicle.\nE.g. if this is selected and you have a matched vehicle, the reg you type here will be used instead.\nUse this if a vehicle has changed after you uploaded your photo.",
                                    child: const Icon(Icons.help),
                                  ),
                                ],
                              ),
                            ] else ...[
                              if (details?.dFleet != null) ...[
                                TDropDownMenu(
                                  options: {
                                    'Search Photos': () {
                                      context.go(
                                        "/photos?query=${details?.dFleet}",
                                      );
                                      // setAppPage(
                                      //   PhotoSearchPage(query: details?.dFleet),
                                      // );
                                    },
                                    'Search Vehicles': () {
                                      context.go(
                                        "/vehicles?query=${details?.dFleet}",
                                      );
                                      // setAppPage(
                                      //   VehicleSearchPage(
                                      //     query: details?.dFleet,
                                      //   ),
                                      // );
                                    },
                                    if (details?.matchedVehicle != null)
                                      'Vehicle Profile': () {
                                        context.go(
                                          "/vehicle/${details!.matchedVehicle!.id}",
                                        );
                                        // setAppPage(
                                        //   VehiclePage(
                                        //     vehicle: details!.matchedVehicle!,
                                        //   ),
                                        // );
                                      },
                                  },
                                  child: DetailChip(
                                    contents: Text(details!.dFleet!),
                                    icon: Icons.numbers,
                                    onClick: () {},
                                  ),
                                ),
                              ],

                              if (details?.dReg != null) ...[
                                const SizedBox(height: 4),

                                TDropDownMenu(
                                  options: {
                                    'Search Photos': () {
                                      context.go(
                                        "/photos?query=${details?.dReg}",
                                      );
                                      // setAppPage(
                                      //   PhotoSearchPage(query: details?.dReg),
                                      // );
                                    },
                                    'Search Vehicles': () {
                                      context.go(
                                        "/vehicles?query=${details?.dReg}",
                                      );
                                      // setAppPage(
                                      //   VehicleSearchPage(query: details?.dReg),
                                      // );
                                    },
                                    if (details?.matchedVehicle != null)
                                      'Vehicle Profile': () {
                                        context.go(
                                          "/vehicle/${details!.matchedVehicle!.id}",
                                        );
                                        // setAppPage(
                                        //   VehiclePage(
                                        //     vehicle: details!.matchedVehicle!,
                                        //   ),
                                        // );
                                      },
                                  },
                                  child: DetailChip(
                                    contents: Text(details!.dReg!),
                                    icon: Icons.badge,
                                    onClick: () {},
                                  ),
                                ),
                              ],

                              if (details?.dLivery != null) ...[
                                const SizedBox(height: 4),

                                TDropDownMenu(
                                  options: {
                                    'Search Photos': () {
                                      context.go(
                                        "/photos?livery=${details!.dLivery!.id}",
                                      );
                                      // setAppPage(
                                      //   PhotoSearchPage(
                                      //     livery: details!.dLivery,
                                      //   ),
                                      // );
                                    },
                                    'Search Vehicles': () {
                                      context.go(
                                        "/vehicles?livery=${details!.dLivery!.id}",
                                      );
                                      // setAppPage(
                                      //   VehicleSearchPage(
                                      //     livery: details!.dLivery,
                                      //   ),
                                      // );
                                    },
                                  },
                                  child: DetailChip(
                                    contents: Text(details!.dLivery!.name),
                                    icon: Icons.palette,
                                    onClick: () {},
                                  ),
                                ),
                              ],

                              if (details?.dVehicleType != null) ...[
                                const SizedBox(height: 4),

                                TDropDownMenu(
                                  options: {
                                    'Search Photos': () {
                                      context.go(
                                        "/photos?vt=${details!.dVehicleType!.id}",
                                      );
                                      // setAppPage(
                                      //   PhotoSearchPage(
                                      //     vehicleType: details!.dVehicleType,
                                      //   ),
                                      // );
                                    },
                                    'Search Vehicles': () {
                                      context.go(
                                        "/vehicles?vt=${details!.dVehicleType!.id}",
                                      );
                                      // setAppPage(
                                      //   VehicleSearchPage(
                                      //     vehicleType: details!.dVehicleType,
                                      //   ),
                                      // );
                                    },
                                  },
                                  child: DetailChip(
                                    contents: Text(details!.dVehicleType!.name),
                                    icon: Icons.bus_alert,
                                    onClick: () {},
                                  ),
                                ),
                              ],

                              if (details?.matchedVehicle?.operator !=
                                  null) ...[
                                const SizedBox(height: 4),
                                DetailChip(
                                  contents: Text(
                                    details!
                                        .matchedVehicle!
                                        .operator!
                                        .displayName,
                                  ),
                                  icon: Icons.business,
                                  onClick: () => context.go(
                                    "/operators/${details.matchedVehicle!.operator!.id}",
                                  ),

                                  // setAppPage(
                                  //   OperatorPage(
                                  //     operator:
                                  //         details.matchedVehicle!.operator!,
                                  //   ),
                                  // ),
                                ),
                              ],

                              if (details?.route != null) ...[
                                const SizedBox(height: 4),
                                DetailChip(
                                  contents: Text(
                                    "${details!.route?.name} ${details.route?.inboundDescription}",
                                  ),
                                  icon: Icons.route,
                                  onClick: () => context.go(
                                    "/photos?route=${details.route!.txId}",
                                  ),

                                  // setAppPage(
                                  //   PhotoSearchPage(route: details.route),
                                  // ),
                                ),
                              ],
                            ],
                            Spacer(),
                            Row(
                              children: [
                                Text(formatIsoDate(photo.createdAt)),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    todo(context);
                                  },
                                  icon: const Icon(Icons.info_outline),
                                ),
                                IconButton(
                                  onPressed: () {
                                    todo(context);
                                  },
                                  icon: const Icon(Icons.share),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            photo.title.isEmpty ? photo.fileName : photo.title,
                          ),
                          Text("©️ Your Mom"),
                        ],
                      ),
                      if (photo.description != null) Text(photo.title),
                    ],
                  ),
                ),
                Row(
                  children: [
                    photoRating == null
                        ? StarRating(
                            averageRating: 0,
                            userRating: 0,
                            removeRating: () {},
                            setRating: (_) {},
                          )
                        : StarRating(
                            averageRating: photoRating!.averageRating,
                            userRating: photoRating!.rating,
                            removeRating: () async {
                              final response = await widget.photo
                                  .deleteRating();

                              setState(() {
                                photoRating = response;
                              });
                            },
                            setRating: (int rating) async {
                              final response = await widget.photo.setRating(
                                rating,
                              );

                              setState(() {
                                photoRating = response;
                              });
                            },
                          ),
                    VerticalDivider(),

                    FavouriteButton(
                      type: FavouriteType.photo,
                      id: photo.id.toString(),
                      isFavourited: photo.isFavourited,
                      onChanged: () async => load(fetchPhoto: true),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.photo.commentThread != null) ...[
              const SizedBox(height: 8),
              CommentThread(
                threadId: widget.photo.commentThread!,
                comments: comments,
                onChange: () => load(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
