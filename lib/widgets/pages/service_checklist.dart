import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:transportia/api/route_checklist.dart';
import 'package:transportia/api/route_checklist_item.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/prompts/operator_search.dart';
import 'package:transportia/prompts/route_checklist_prompt.dart';
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

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();

    allItems = widget.checklist.items;
    items = allItems;
  }

  void reload() async {
    final loaded = await ApiRouteChecklist.fetch(widget.checklist.id);

    setState(() {
      allItems = loaded.items;
      items = loaded.items;
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
    final sortedItems = [...items]
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

            const SizedBox(height: 8),

            Expanded(
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
                            await item.toggleCompleted();
                            reload();
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
                  context: context,
                );

                if (operator == null) return;

                final lines = await ApiTxLine.fetchAll(
                  operatorNationalCode: operator.nationalCode,
                  pageLength: 1000,
                );

                final confirmed = await showConfirmPrompt(
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
