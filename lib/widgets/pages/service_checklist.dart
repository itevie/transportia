import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:transportia/api/checklist.dart';
import 'package:transportia/api/checklist_item.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/widgets/prompts/big_button_selector.dart';
import 'package:transportia/widgets/prompts/operator_search.dart';
import 'package:transportia/widgets/prompts/route_checklist_prompt.dart';
import 'package:transportia/widgets/prompts/service_presets.dart';
import 'package:transportia/util/checklist_manager.dart';
import 'package:transportia/widgets/service_number.dart';
import 'package:transportia/widgets/util/sub_text.dart';
import 'package:transportia/widgets/util/toasts.dart';

class ServiceChecklist extends StatefulWidget {
  final ApiChecklist checklist;

  const ServiceChecklist({super.key, required this.checklist});

  @override
  State<ServiceChecklist> createState() => _ServiceChecklistState();
}

class _ServiceChecklistState extends State<ServiceChecklist> {
  late TextEditingController searchController;
  late List<ApiChecklistItem> allItems;

  bool loading = false;

  List<ApiChecklistItem> items = [];
  List<int> ignoredChecks = [];

  bool completedOnly = false;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();

    reload();
  }

  void reload() async {
    setState(() {
      loading = true;
    });
    // final loaded = await ApiRouteChecklist.fetch(widget.checklist.id);
    final items = await widget.checklist.getItems();

    setState(() {
      allItems = items;
      this.items = items;
      loading = false;
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      search(searchController.text);
    });
  }

  void search(String search) {
    final query = search.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        items = allItems;
      });
      return;
    }

    final filtered = allItems.where((item) {
      if (widget.checklist.checklistType == ChecklistType.service) {
        final line = item.txLine;

        return line.name.toLowerCase().contains(query) ||
            (line.inboundDescription ?? '').toLowerCase().contains(query) ||
            (line.outboundDescription ?? '').toLowerCase().contains(query) ||
            (line.operatorNationalCode ?? '').toLowerCase().contains(query);
      } else if (widget.checklist.checklistType == ChecklistType.vehicle) {
        final vehicle = item.vehicle;

        return vehicle.reg.toLowerCase().contains(query) ||
            vehicle.fleet.toLowerCase().contains(query);
      } else {
        return false;
      }
    }).toList();

    setState(() {
      items = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedItems =
        [
            ...items,
          ].where((x) => completedOnly ? x.completedAt != null : true).toList()
          ..sort((a, b) {
            final aName =
                (widget.checklist.checklistType == ChecklistType.service
                        ? a.txLine.name
                        : a.vehicle.reg)
                    .trim()
                    .toLowerCase();

            final bName =
                (widget.checklist.checklistType == ChecklistType.service
                        ? b.txLine.name
                        : b.vehicle.reg)
                    .trim()
                    .toLowerCase();

            final aNumber = int.tryParse(aName);
            final bNumber = int.tryParse(bName);

            if (aNumber != null && bNumber != null) {
              return aNumber.compareTo(bNumber);
            }

            if (aNumber != null) return -1;
            if (bNumber != null) return 1;

            return aName.compareTo(bName);
          });

    final completed = sortedItems.where((x) => x.completedAt != null).length;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchBar(
              hintText: "Search in this checklist...",
              controller: searchController,
              onChanged: search,
            ),

            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 4,
              children: [
                Text("$completed/${sortedItems.length} completed"),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: completedOnly,
                      onChanged: (v) {
                        setState(() {
                          completedOnly = v ?? false;
                        });
                      },
                    ),
                    const Text("Completed?"),
                  ],
                ),
              ],
            ),

            sortedItems.isEmpty
                ? Expanded(
                    child: Center(
                      child: loading
                          ? CircularProgressIndicator()
                          : Text(
                              completedOnly
                                  ? "Nothing completed yet!"
                                  : "No services yet, click the + to add some!",
                            ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: sortedItems.length,
                      itemBuilder: (context, index) {
                        final item = sortedItems[index];

                        final subText =
                            widget.checklist.checklistType ==
                                ChecklistType.service
                            ? ""
                            : [
                                    item.vehicle.vehicleType?.name,
                                    item.vehicle.operator?.displayName,
                                    item.vehicle.livery?.name,
                                  ]
                                  .whereType<String>()
                                  .where((e) => e.isNotEmpty)
                                  .join(' - ');

                        return Card(
                          child: Row(
                            children: [
                              if (widget.checklist.checklistType ==
                                  ChecklistType.service) ...[
                                ServiceNumber(
                                  lineName: item.txLine.name,
                                  operator: item.txLine.operatorNationalCode,
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    item.txLine.inboundDescription ??
                                        item.txLine.outboundDescription ??
                                        "",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ] else if (widget.checklist.checklistType ==
                                  ChecklistType.vehicle) ...[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.vehicle.displayName,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (subText.isNotEmpty)
                                          SubText(subText),
                                      ],
                                    ),
                                  ),
                                ),
                              ],

                              Checkbox(
                                key: Key("${item.id}:${item.objId}"),
                                value: item.completedAt != null,
                                onChanged: (_) async {
                                  if (ignoredChecks.contains(item.id)) return;
                                  ignoredChecks.add(item.id);

                                  try {
                                    await item.toggleCompleted();
                                    reload();
                                  } finally {
                                    ignoredChecks.remove(item.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),

        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () async {
              await checklistAddFully(
                context,
                widget.checklist,
                reload: reload,
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
