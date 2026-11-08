import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/widgets/lists/model_bus_list.dart';
import 'package:transportia/widgets/lists/model_bus_rows.dart';
import 'package:transportia/widgets/lists/tram_list.dart';
import 'package:transportia/widgets/lists/tram_list_rows.dart';
import 'package:transportia/widgets/util/search_page.dart';

class ModelBusSearchPage extends StatefulWidget {
  const ModelBusSearchPage({super.key});

  @override
  State<ModelBusSearchPage> createState() => _ModelBusSearchPageState();
}

class _ModelBusSearchPageState extends State<ModelBusSearchPage> {
  List<ApiModelBus> models = [];

  @override
  void initState() {
    super.initState();

    load();
  }

  void load({String? query}) async {
    final loadedTrams = await ApiModelBus.search(search: query);

    setState(() {
      models = loadedTrams;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Listen to reloads for deletion / edit
    return SearchPage(
      searchHint: "Search model buses..",
      onSearch: (v) {
        load(query: v);
      },
      filters: [Text("hi")],
      onClear: () {},
      createCallback: () {
        context.go("/model-buses/create");
      },
      results: () => Expanded(
        child: SingleChildScrollView(child: ModelBusList(modelBuses: models)),
      ),
      resultsTable: () => Expanded(child: ModelBusListRows(vehicles: models)),
    );
  }
}
