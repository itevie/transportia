import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/checklist.dart';
import 'package:transportia/widgets/prompts/checklist_type.dart';
import 'package:transportia/widgets/util/sub_text.dart';

class ServiceChecklists extends StatefulWidget {
  const ServiceChecklists({super.key});

  @override
  State<ServiceChecklists> createState() => _ServiceChecklistsState();
}

class _ServiceChecklistsState extends State<ServiceChecklists> {
  List<ApiChecklist> checklists = [];

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    final fetched = await ApiChecklist.fetchAll();

    setState(() {
      checklists = fetched;
    });
  }

  void create() async {
    final t = await showChecklistTypePrompt(context: context);

    if (t == null) return;

    final title = await showInputPrompt(context, Text("Checklist Title"), null);

    if (title == null) return;

    await ApiChecklist.create(t, title, null);

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
                  final count = x.itemCount;
                  final completed = x.completedItemCount;

                  return Card(
                    child: ListTile(
                      onTap: () =>
                          context.pushReplacement("/checklist/${x.id}"),
                      leading: Icon(x.checklistType.icon),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(x.title),
                          const SizedBox(width: 4),
                          SubText("$completed/$count"),
                        ],
                      ),
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
