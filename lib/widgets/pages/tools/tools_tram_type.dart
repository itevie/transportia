import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/widgets/object/tram_type.dart';
import 'package:transportia/widgets/util/t_search_bar.dart';

class ToolTramTypesPage extends StatefulWidget {
  const ToolTramTypesPage({super.key});

  @override
  State<ToolTramTypesPage> createState() => _ToolTramTypesPageState();
}

class _ToolTramTypesPageState extends State<ToolTramTypesPage> {
  List<ApiTramType> tramTypes = [];

  @override
  void initState() {
    super.initState();

    load("");
  }

  void load(String query) async {
    final loaded = await ApiTramType.search(query);

    setState(() {
      tramTypes = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TSearchBar(
                hintText: 'Search tram types...',
                onChanged: (String value) {
                  load(value);
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () {
                context.go("/tram-types/create");
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: tramTypes
                .map(
                  (x) => TramTypeView(
                    tramType: x,
                    isTool: true,
                    reload: () => load(""),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
