import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/constants.dart';
import 'package:transportia/util/prefs.dart';

class SearchPage extends StatefulWidget {
  final String searchHint;
  final String? prefilledQuery;
  final void Function(String query) onSearch;
  final List<Widget> filters;
  final VoidCallback onClear;
  final Widget Function() results;
  final Widget Function()? resultsTable;
  final bool loading;
  final int? currentOffset;
  final void Function(int offset)? offsetCallback;
  final VoidCallback? createCallback;

  const SearchPage({
    super.key,
    required this.searchHint,
    required this.onSearch,
    required this.filters,
    required this.onClear,
    required this.results,
    this.loading = false,
    this.prefilledQuery,
    this.currentOffset,
    this.offsetCallback,
    this.resultsTable,
    this.createCallback,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController search;
  Timer? _searchTimer;
  bool isTable = false;

  @override
  void initState() {
    super.initState();

    search = TextEditingController(text: widget.prefilledQuery ?? "");
  }

  @override
  void dispose() {
    super.dispose();

    _searchTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.resultsTable != null) {
      final path = GoRouterState.of(context).uri.path;
      isTable = Preferences().getBool("list_view_$path");
    }
  }

  void _onSearchChanged(String value) {
    _searchTimer?.cancel();

    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SearchBar(
                hintText: widget.searchHint,
                controller: search,
                onChanged: _onSearchChanged,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filters
              SizedBox(
                width: 250,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var filter in widget.filters) ...[
                        filter,
                        const SizedBox(height: 8),
                      ],

                      ElevatedButton.icon(
                        onPressed: widget.onClear,
                        label: Text("Clear"),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              ),

              const VerticalDivider(width: 1),

              if (widget.loading)
                Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: Column(
                    children: [
                      if (isTable && widget.resultsTable != null)
                        widget.resultsTable!()
                      else
                        widget.results(),
                      if ((widget.offsetCallback != null &&
                              widget.currentOffset != null) ||
                          widget.resultsTable != null ||
                          widget.createCallback != null)
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (widget.createCallback != null)
                                Positioned(
                                  left: 0,
                                  child: IconButton(
                                    onPressed: () async {
                                      widget.createCallback!();
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed:
                                        widget.currentOffset == null ||
                                            widget.currentOffset! < pageSize
                                        ? null
                                        : () {
                                            widget.offsetCallback!(
                                              widget.currentOffset! - pageSize,
                                            );
                                          },
                                    icon: const Icon(Icons.chevron_left),
                                  ),
                                  Text(
                                    widget.currentOffset == null
                                        ? "0 / 0"
                                        : "${widget.currentOffset! / pageSize}",
                                  ),
                                  IconButton(
                                    onPressed: widget.currentOffset == null
                                        ? null
                                        : () {
                                            widget.offsetCallback!(
                                              widget.currentOffset! + pageSize,
                                            );
                                          },
                                    icon: const Icon(Icons.chevron_right),
                                  ),
                                ],
                              ),
                              if (widget.resultsTable != null)
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    isSelected: isTable,
                                    onPressed: () async {
                                      final path = GoRouterState.of(
                                        context,
                                      ).uri.path;

                                      await Preferences().setBool(
                                        "list_view_$path",
                                        !isTable,
                                      );

                                      setState(() {
                                        isTable = !isTable;
                                      });
                                    },
                                    selectedIcon: const Icon(Icons.view_list),
                                    icon: const Icon(Icons.grid_view),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
