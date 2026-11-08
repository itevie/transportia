import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:transportia/api/route_checklist.dart';
import 'package:transportia/api/route_checklist_item.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/prompts/operator_search.dart';
import 'package:transportia/prompts/route_checklist_prompt.dart';
import 'package:transportia/prompts/service_presets.dart';
import 'package:transportia/widgets/service_number.dart';

class ServiceChecklist extends StatefulWidget {
  final ApiRouteChecklist checklist;

  const ServiceChecklist({super.key, required this.checklist});

  @override
  State<ServiceChecklist> createState() => _ServiceChecklistState();
}

class _ServiceChecklistState extends State<ServiceChecklist> {
  late TextEditingController searchController;
  late List<ApiRouteChecklistItem> allItems;

  List<ApiRouteChecklistItem> items = [];
  List<int> ignoredChecks = [];

  bool completedOnly = false;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();

    reload();
  }

  void reload() async {
    // final loaded = await ApiRouteChecklist.fetch(widget.checklist.id);
    final items = await widget.checklist.getItems();

    setState(() {
      allItems = items;
      this.items = items;
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
      final line = item.line;

      return line.name.toLowerCase().contains(query) ||
          (line.inboundDescription ?? '').toLowerCase().contains(query) ||
          (line.outboundDescription ?? '').toLowerCase().contains(query) ||
          (line.operatorNationalCode ?? '').toLowerCase().contains(query);
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
            final aName = a.line.name.trim().toLowerCase();
            final bName = b.line.name.trim().toLowerCase();

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
                      child: Text(
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

                        return Card(
                          child: Row(
                            children: [
                              ServiceNumber(
                                lineName: item.line.name,
                                operator: item.line.operatorNationalCode,
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  item.line.inboundDescription ??
                                      item.line.outboundDescription ??
                                      "",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              Checkbox(
                                key: Key("${item.id}:${item.lineId}"),
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
              final result = await showRouteChecklistPrompt(context);

              if (result == "Operator") {
                final operator = await showOperatorSearchPrompt(
                  // ignore: use_build_context_synchronously
                  context: context,
                );

                if (operator == null) return;

                final lines = await ApiTxLine.fetchAll(
                  operatorNationalCode: operator.nationalCode,
                  pageLength: 1000,
                );

                final confirmed = await showConfirmPrompt(
                  // ignore: use_build_context_synchronously
                  context,
                  const Text("Add Lines?"),
                  Text(
                    "Are you sure you want to add "
                    "${lines.length} lines from "
                    "${operator.shortName} (${operator.nationalCode}) "
                    "to the ${widget.checklist.title} checklist?",
                  ),
                );

                if (!confirmed) return;

                await widget.checklist.addOperator(operator.nationalCode!);
              } else if (result == "Preset") {
                // ignore: use_build_context_synchronously, unused_local_variable
                final preset = await showServicePresetPrompt(context: context);
                if (preset == null) return;

                final count = await ApiRouteChecklist.countBulkOperator(
                  preset.value,
                );

                print(preset.value);

                final confirmed = await showConfirmPrompt(
                  context,
                  const Text("Add Lines?"),
                  Text(
                    "Are you sure you want to add $count lines from ${preset.value.length} operators to the ${widget.checklist.title} checlist?",
                  ),
                );

                if (!confirmed) return;

                await widget.checklist.addBulkOperator(preset.value);
              }

              reload();
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
