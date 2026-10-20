import 'package:flutter/material.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/comment.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/main_old.dart';
import 'package:transportia/util_widgets/sub_text.dart';
import 'package:transportia/util_widgets/tab_bar.dart';
import 'package:transportia/widgets/comment_thread.dart';
import 'package:transportia/widgets/pages/vehicle_page.dart';
import 'package:transportia/widgets/pages/vehicle_search.dart';
import 'package:transportia/widgets/service_number.dart';

class OperatorPage extends StatefulWidget {
  final ApiTxOperator operator;
  const OperatorPage({super.key, required this.operator});

  @override
  State<OperatorPage> createState() => _OperatorPageState();
}

class _OperatorPageState extends State<OperatorPage> {
  List<ApiTxLine> lines = [];
  List<ApiBtVehicle> vehicles = [];
  List<ApiBtLivery> liveries = [];
  Map<String, List<ApiBtVehicle>> vehiclesMapped = {};
  List<ApiComment> comments = [];

  @override
  void initState() {
    super.initState();
    load();
    loadComments();
  }

  void load() async {
    final loadedLines = await ApiTxLine.fetchAll(
      operatorNationalCode: widget.operator.nationalCode,
      pageLength: 1000,
    );

    final loadedVehicles = await ApiBtVehicle.search(
      operatorId: widget.operator.nationalCode,
      pageLength: 1000,
    );

    Map<String, List<ApiBtVehicle>> mapped = {};
    List<int> liveryIds = [];
    List<ApiBtLivery> liveries = [];

    for (var v in loadedVehicles) {
      final t = v.vehicleType?.name ?? "Unknown Type";
      if (mapped[t] == null) mapped[t] = [];
      mapped[t]!.add(v);

      if (v.livery != null && !liveryIds.contains(v.livery!.id)) {
        liveryIds.add(v.livery!.id);
        liveries.add(v.livery!);
      }
    }

    setState(() {
      lines = loadedLines;
      vehicles = loadedVehicles;
      vehiclesMapped = mapped;
      this.liveries = liveries;
      if (comments != null) this.comments = comments;
    });
  }

  void loadComments() async {
    final comments = widget.operator.commentThread == null
        ? null
        : await ApiComment.fetchByThread(widget.operator.commentThread!);

    setState(() {
      if (comments != null) this.comments = comments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${widget.operator.shortName} (${widget.operator.id})",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        Expanded(
          child: AppTabController(
            tabs: [
              AppTab(
                name: "Routes (${lines.length})",
                icon: Icons.route,
                child: ListView(
                  children: [
                    ...lines.map((x) {
                      return Card(
                        child: Row(
                          children: [
                            ServiceNumber(
                              lineName: x.name,
                              operator: x.operatorNationalCode,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                x.inboundDescription ??
                                    x.outboundDescription ??
                                    "",
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              AppTab(
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
                                setAppPage(VehiclePage(vehicle: vehicle));
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
                                      Text("${vehicle.reg} - ${vehicle.fleet}"),
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
                name: "Liveries (${liveries.length})",
                icon: Icons.palette,
                child: ListView(
                  children: [
                    ...liveries.map(
                      (x) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 3,
                        ),
                        child: ListTile(
                          title: Text(x.name),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            setAppPage(VehicleSearchPage(livery: x));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.operator.commentThread != null)
                AppTab(
                  name: "Comments (${comments.length})",
                  icon: Icons.comment,
                  child: CommentThread(
                    threadId: widget.operator.commentThread!,
                    comments: comments,
                    onChange: () {
                      loadComments();
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
