import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_widget.dart';
import 'package:transportia/widgets/inputs/search_filtering/main_obj.dart';
import 'package:transportia/widgets/util/search_page.dart';

class FullySearchPage<T> extends StatefulWidget {
  final String searchHint;
  final List<SearchFilter> filters;
  final Future<List<T>> Function(SearchFilters filter) query;
  final void Function(SearchFilters filters)? initFilters;
  final Widget Function(List<T> results) results;
  final Widget Function(List<T> results)? resultsTable;

  const FullySearchPage({
    super.key,
    required this.searchHint,
    required this.filters,
    required this.results,
    this.resultsTable,
    this.initFilters,
    required this.query,
  });

  @override
  State<FullySearchPage<T>> createState() => _FullySearchPageState<T>();
}

class _FullySearchPageState<T> extends State<FullySearchPage<T>> {
  final filters = SearchFilters();
  List<T> results = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.initFilters != null) {
      widget.initFilters!(filters);
    }
  }

  void load() async {
    setState(() {
      loading = true;
    });

    final results = await widget.query(filters);

    setState(() {
      this.results = results;
      loading = false;
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
      searchHint: "Search by fleet or reg...",
      prefilledQuery: filters.query,
      onSearch: (v) {
        setState(() {
          filters.query = v;
          filters.offset = 0;
        });

        addPostLoad();
      },
      loading: loading,
      currentOffset: filters.offset,
      offsetCallback: (offset) {
        setState(() {
          filters.offset = offset;
        });

        addPostLoad();
      },
      filters:
          SearchFilterBuilder(
            context: context,
            filters: filters,
            onChanged: () {
              setState(() {
                filters.offset = 0;
              });

              load();
            },
          ).build([
            SearchFilter.livery,
            SearchFilter.vehicleType,
            SearchFilter.operator,
            SearchFilter.vehicle,
            SearchFilter.electric,
            SearchFilter.doubleDecker,
            SearchFilter.coach,
            SearchFilter.openTop,
            SearchFilter.demonstrator,
            SearchFilter.trainingVehicle,
            SearchFilter.withdrawn,
            SearchFilter.hasImage,
            SearchFilter.vehicleMatched,
          ]),
      onClear: () {
        setState(() {
          filters.clear();
        });

        addPostLoad();
      },
      results: () => widget.results(results),
      resultsTable: widget.resultsTable != null
          ? () => widget.resultsTable!(results)
          : null,
    );
  }
}
