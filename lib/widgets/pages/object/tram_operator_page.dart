import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/comment.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_livery.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/api/tram_photo_details.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/util/sub_text.dart';
import 'package:transportia/widgets/util/tab_bar.dart';
import 'package:transportia/widgets/comment_thread.dart';
import 'package:transportia/widgets/service_number.dart';

import '../../livery/livery.dart';

class TramOperatorPage extends StatefulWidget {
  final ApiTramOperator operator;
  const TramOperatorPage({super.key, required this.operator});

  @override
  State<TramOperatorPage> createState() => _TramOperatorPageState();
}

class _TramOperatorPageState extends State<TramOperatorPage> {
  // List<ApiTxLine> lines = [];
  List<ApiTram> vehicles = [];
  List<ApiTramLivery> liveries = [];
  Map<String, List<ApiTram>> vehiclesMapped = {};
  List<ApiComment> comments = [];
  List<ApiPhoto> photos = [];

  @override
  void initState() {
    super.initState();
    load();
    // loadComments();
  }

  void load() async {
    // final loadedLines = await ApiTxLine.fetchAll(
    //   operatorNationalCode: widget.operator.nationalCode,
    //   pageLength: 1000,
    // );

    final loadedVehicles = await ApiTram.search(
      operatorId: widget.operator.id,
      pageLength: 1000,
    );

    final photos = await ApiTramPhotoDetails.fetchAll(
      tdOperatorId: widget.operator.id,
    );

    Map<String, List<ApiTram>> mapped = {};
    List<int> liveryIds = [];
    List<ApiTramLivery> liveries = [];

    for (var v in loadedVehicles) {
      final t = v.tramType?.name ?? "Unknown Type";
      if (mapped[t] == null) mapped[t] = [];
      mapped[t]!.add(v);

      if (v.livery != null && !liveryIds.contains(v.livery!.id)) {
        liveryIds.add(v.livery!.id);
        liveries.add(v.livery!);
      }
    }

    setState(() {
      // lines = loadedLines;
      vehicles = loadedVehicles;
      vehiclesMapped = mapped;
      this.liveries = liveries;
      this.photos = photos;
    });
  }

  // void loadComments() async {
  //   final comments = widget.operator.commentThread == null
  //       ? null
  //       : await ApiComment.fetchByThread(widget.operator.commentThread!);

  //   setState(() {
  //     if (comments != null) this.comments = comments;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.operator.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        Expanded(
          child: AppTabController(
            tabs: [
              // AppTab(
              //   id: "routes",
              //   name: "Routes (${lines.length})",
              //   icon: Icons.route,
              //   child: ListView(
              //     children: [
              //       ...lines.map((x) {
              //         return Card(
              //           child: Row(
              //             children: [
              //               ServiceNumber(
              //                 lineName: x.name,
              //                 operator: x.operatorNationalCode,
              //               ),
              //               const SizedBox(width: 8),
              //               Expanded(
              //                 child: Text(
              //                   x.inboundDescription ??
              //                       x.outboundDescription ??
              //                       "",
              //                 ),
              //               ),
              //             ],
              //           ),
              //         );
              //       }),
              //     ],
              //   ),
              // ),
              AppTab(
                id: "vehicles",
                name: "Vehicles (${vehicles.length})",
                icon: Icons.directions_bus,
                child: ListView(
                  children: [
                    ...vehiclesMapped.entries.map((entry) {
                      return ExpansionTile(
                        title: Text("${entry.key} (${entry.value.length})"),
                        children: [
                          ...entry.value.map(
                            (vehicle) => ListTile(
                              onTap: () {
                                context.go("/tram/${vehicle.id}");
                                // setAppPage(VehiclePage(vehicle: vehicle));
                              },
                              trailing: const Icon(Icons.chevron_right),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (vehicle.withdrawn) ...[
                                        Text(
                                          "Withdrawn",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      Text(vehicle.displayName),
                                    ],
                                  ),
                                  if (vehicle.livery != null)
                                    SubText(vehicle.livery!.name),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              AppTab(
                id: "photos",
                name: "Vehicle Photos (${photos.length})",
                icon: Icons.camera,
                child: SingleChildScrollView(child: PhotoList(photos: photos)),
              ),
              // AppTab(
              //   id: "liveries",
              //   name: "Liveries (${liveries.length})",
              //   icon: Icons.palette,
              //   child: ListView(
              //     children: [
              //       ...liveries.map(
              //         (x) => Card(
              //           margin: const EdgeInsets.symmetric(
              //             horizontal: 4,
              //             vertical: 3,
              //           ),
              //           child: ListTile(
              //             title: Text(x.name),
              //             trailing: const Icon(Icons.chevron_right),
              //             // leading: LiveryView(
              //             //   livery: x,
              //             //   key: Key(x.id.toString()),
              //             // ),
              //             onTap: () {
              //               context.go("/vehicles?livery=${x.id}");
              //               // setAppPage(VehicleSearchPage(livery: x));
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // if (widget.operator.commentThread != null)
              //   AppTab(
              //     id: "comments",
              //     name: "Comments (${comments.length})",
              //     icon: Icons.comment,
              //     child: Padding(
              //       padding: EdgeInsetsGeometry.all(8),
              //       child: CommentThread(
              //         threadId: widget.operator.commentThread!,
              //         comments: comments,
              //         onChange: () {
              //           loadComments();
              //         },
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ],
    );
  }
}
