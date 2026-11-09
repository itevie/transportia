import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/widgets/lists/model_bus_list.dart';
import 'package:transportia/widgets/util/search_page.dart';

class ModelBusOwnershipSearchPage extends StatefulWidget {
  const ModelBusOwnershipSearchPage({super.key});

  @override
  State<ModelBusOwnershipSearchPage> createState() =>
      _ModelBusOwnershipSearchPageState();
}

class _ModelBusOwnershipSearchPageState
    extends State<ModelBusOwnershipSearchPage> {
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
      searchHint: "Search model bus ownerships..",
      onSearch: (v) {
        load(query: v);
      },
      filters: [Text("hi")],
      onClear: () {},
      createCallback: () {
        context.go("/model-bus-ownerships/create");
      },
      results: () => Expanded(
        child: SingleChildScrollView(child: ModelBusList(modelBuses: models)),
      ),
      // resultsTable: () => Expanded(child: ModelBusListRows(vehicles: models)),
    );
  }
}
