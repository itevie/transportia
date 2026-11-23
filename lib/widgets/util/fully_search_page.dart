import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/util/async_widget_thing.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_widget.dart';
import 'package:transportia/widgets/inputs/search_filtering/main_obj.dart';
import 'package:transportia/widgets/util/search_page.dart';

enum OrderByType { photo }

class FullySearchPage<T> extends StatefulWidget {
  final String searchHint;
  final List<SearchFilter> filters;
  final Future<List<T>> Function(SearchFilters filter) query;
  final void Function(SearchFilters filters)? initFilters;
  final Widget Function(List<T> results) results;
  final Widget Function(List<T> results)? resultsTable;
  final VoidCallback? createCallback;
  final bool isNested;
  final String Function(String)? nestedExternalLink;
  final OrderByType? orderByType;

  const FullySearchPage({
    super.key,
    required this.searchHint,
    required this.filters,
    required this.results,
    this.resultsTable,
    this.initFilters,
    required this.query,
    this.createCallback,
    this.isNested = false,
    this.nestedExternalLink,
    this.orderByType,
  });

  @override
  State<FullySearchPage<T>> createState() => _FullySearchPageState<T>();
}

class _FullySearchPageState<T> extends State<FullySearchPage<T>> {
  final filters = SearchFilters();
  List<T> results = [];
  bool loading = false;
  AsyncWidgetThingResponse asyncThing = AsyncWidgetThingResponse();

  @override
  void initState() {
    super.initState();

    if (widget.initFilters != null) {
      widget.initFilters!(filters);
    }

    load();
  }

  void load() async {
    final results = await handleAsync(
      "Fetch",
      widget.query(filters),
      callback: (v) {
        setState(() {
          asyncThing = v;
        });
      },
    );

    if (results == null) return;

    setState(() {
      this.results = results;
    });
  }

  void addPostLoad() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      load();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? nextToSearch;

    if (widget.orderByType == OrderByType.photo) {
      nextToSearch = DropdownButton<PhotoOrderBy>(
        value: filters.orderBy ?? PhotoOrderBy.newest,
        hint: Text('Order by'),
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: PhotoOrderBy.newest, child: Text('Newest')),
          DropdownMenuItem(value: PhotoOrderBy.oldest, child: Text('Oldest')),
          DropdownMenuItem(
            value: PhotoOrderBy.highestRated,
            child: Text('Highest rated'),
          ),
          DropdownMenuItem(
            value: PhotoOrderBy.lowestRated,
            child: Text('Lowest rated'),
          ),
        ],
        onChanged: (PhotoOrderBy? value) {
          setState(() {
            filters.orderBy = value;
          });

          addPostLoad();
        },
      );
    }

    return SearchPage(
      searchHint: "Search by fleet or reg...",
      prefilledQuery: filters.query,
      isNested: widget.isNested,
      nestedExternalLink: widget.nestedExternalLink != null
          ? () {
              return widget.nestedExternalLink!(filters.toQueryString());
            }
          : null,
      onSearch: (v) {
        setState(() {
          filters.query = v;
          filters.offset = 0;
        });

        addPostLoad();
      },
      nextToSearch: nextToSearch,
      loading: asyncThing.loading,
      error: asyncThing.error,
      currentOffset: filters.offset,
      offsetCallback: (offset) {
        setState(() {
          filters.offset = offset;
        });

        addPostLoad();
      },
      createCallback: widget.createCallback,
      filters: SearchFilterBuilder(
        context: context,
        filters: filters,
        onChanged: () {
          setState(() {
            filters.offset = 0;
          });

          load();
        },
      ).build(widget.filters),
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
