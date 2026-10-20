import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:transportia/api/route_checklist.dart';
import 'package:transportia/main_old.dart';
import 'package:transportia/widgets/pages/service_checklist.dart';

class ServiceChecklists extends StatefulWidget {
  const ServiceChecklists({super.key});

  @override
  State<ServiceChecklists> createState() => _ServiceChecklistsState();
}

class _ServiceChecklistsState extends State<ServiceChecklists> {
  List<ApiRouteChecklist> checklists = [];

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    final fetched = await ApiRouteChecklist.fetchAll();

    setState(() {
      checklists = fetched;
    });
  }

  void create() async {
    final title = await showInputPrompt(context, Text("Checklist Title"), null);

    if (title == null) return;

    await ApiRouteChecklist.create(title, null);

    load();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: SearchBar(hintText: "Search your checklists..."),
                ),
                const SizedBox(height: 8),

                ...checklists.map((x) {
                  final count = x.items.length;
                  final completed = x.items
                      .where((x) => x.completedAt != null)
                      .length;

                  return Card(
                    child: ListTile(
                      onTap: () => setAppPage(ServiceChecklist(checklist: x)),
                      title: Text(x.title),
                      subtitle: Text("$completed/$count"),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  );
                }),
              ],
            ),
          ),

          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: create,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
