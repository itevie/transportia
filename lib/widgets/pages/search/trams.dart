import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/widgets/lists/tram_list.dart';
import 'package:transportia/widgets/lists/tram_list_rows.dart';
import 'package:transportia/widgets/util/search_page.dart';

class TramsSearchPage extends StatefulWidget {
  const TramsSearchPage({super.key});

  @override
  State<TramsSearchPage> createState() => _TramsSearchPageState();
}

class _TramsSearchPageState extends State<TramsSearchPage> {
  List<ApiTram> trams = [];

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    final loadedTrams = await ApiTram.search();

    setState(() {
      trams = loadedTrams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchPage(
      searchHint: "Search trams..",
      onSearch: (v) {},
      filters: [Text("hi")],
      onClear: () {},
      createCallback: () {
        context.go("/trams/create");
      },
      results: () => Expanded(
        child: SingleChildScrollView(
          child: TramList(vehicles: trams, reload: load),
        ),
      ),
      resultsTable: () => Expanded(
        child: TramListRow(vehicles: trams, reload: load),
      ),
    );
  }
}
