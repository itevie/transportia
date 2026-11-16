import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_livery.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_widget.dart';
import 'package:transportia/widgets/inputs/search_filtering/main_obj.dart';
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

  final filters = SearchFilters();

  String? query;
  int offset = 0;

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    final loadedTrams = await ApiTram.search(
      search: query,
      liveryId: filters.tramLivery?.id,
      tramTypeId: filters.tramType?.id,
      operatorId: filters.tramOperator?.id,
    );

    setState(() {
      trams = loadedTrams;
    });
  }

  void addPostLoad() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchPage(
      searchHint: "Search trams..",
      onSearch: (v) {
        setState(() {
          query = v;
        });

        addPostLoad();
      },
      filters: SearchFilterBuilder(
        context: context,
        filters: filters,
        onChanged: () {
          setState(() {
            filters.offset = 0;
          });

          load();
        },
      ).build([SearchFilter.tramType, SearchFilter.tramOperator]),
      onClear: () {
        setState(() {
          filters.clear();
        });

        addPostLoad();
      },
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
