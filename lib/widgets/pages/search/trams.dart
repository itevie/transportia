import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';
import 'package:transportia/widgets/lists/tram_list.dart';
import 'package:transportia/widgets/lists/tram_list_rows.dart';
import 'package:transportia/widgets/util/fully_search_page.dart';

class TramsSearchPage extends StatelessWidget {
  const TramsSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FullySearchPage<ApiTram>(
      searchHint: "Search trams...",
      filters: [SearchFilter.tramType, SearchFilter.tramOperator],
      initFilters: (filters) {
        filters.offset = 0;
      },
      query: (filters) async {
        return await ApiTram.search(
          search: filters.query == null || filters.query!.isEmpty
              ? null
              : filters.query,
          liveryId: filters.tramLivery?.id,
          tramTypeId: filters.tramType?.id,
          operatorId: filters.tramOperator?.id,
          offset: filters.offset,
        );
      },
      createCallback: () {
        context.go("/trams/create");
      },
      results: (results) => Expanded(
        child: SingleChildScrollView(child: TramList(vehicles: results)),
      ),
      resultsTable: (results) =>
          Expanded(child: TramListRow(vehicles: results)),
    );
  }
}
