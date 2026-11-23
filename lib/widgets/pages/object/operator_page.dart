import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/bus_photo_details.dart';
import 'package:transportia/api/comment.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/widgets/lists/operator_liveries.dart';
import 'package:transportia/widgets/lists/operator_vehicle_tyes.dart';
import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/object/small/service.dart';
import 'package:transportia/widgets/pages/search/bus_photo_search_page.dart';
import 'package:transportia/widgets/pages/search/vehicle_search.dart';
import 'package:transportia/widgets/util/sub_text.dart';
import 'package:transportia/widgets/util/tab_bar.dart';
import 'package:transportia/widgets/comment_thread.dart';
import 'package:transportia/widgets/service_number.dart';

import '../../livery/livery.dart';

class OperatorPage extends StatefulWidget {
  final ApiTxOperator operator;
  const OperatorPage({super.key, required this.operator});

  @override
  State<OperatorPage> createState() => _OperatorPageState();
}

class _OperatorPageState extends State<OperatorPage> {
  List<ApiTxLine> lines = [];
  List<ApiBtVehicleType> vehicleTypes = [];
  List<ApiBtLivery> liveries = [];
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

    if (!mounted) return;

    setState(() {
      lines = loadedLines;
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
                id: "routes",
                name: "Routes (${lines.length})",
                icon: Icons.route,
                child: ListView(
                  children: [
                    ...lines.map((x) {
                      return SmallServiceRow(route: x);
                    }),
                  ],
                ),
              ),
              AppTab(
                id: "vehicles",
                name: "Vehicles",
                icon: Icons.directions_bus,
                child: VehicleSearchPage(
                  isNested: true,
                  operator: widget.operator,
                ),
              ),
              if (widget.operator.nationalCode != null) ...[
                AppTab(
                  id: "vehicle_types",
                  name: "Vehicle Types",
                  icon: Icons.directions_bus,
                  child: OperatorVehicleTypes(
                    operatorId: widget.operator.nationalCode!,
                  ),
                ),

                AppTab(
                  id: "liveries",
                  name: "Liveries",
                  icon: Icons.palette,
                  child: OperatorLiveries(
                    operatorId: widget.operator.nationalCode!,
                  ),
                ),
              ],
              if (widget.operator.commentThread != null)
                AppTab(
                  id: "comments",
                  name: "Comments (${comments.length})",
                  icon: Icons.comment,
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(8),
                    child: CommentThread(
                      threadId: widget.operator.commentThread!,
                      comments: comments,
                      onChange: () {
                        loadComments();
                      },
                    ),
                  ),
                ),
              AppTab(
                id: "photos",
                name: "Photos",
                icon: Icons.camera,
                child: BusPhotoSearchPage(
                  isNested: true,
                  operator: widget.operator,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
