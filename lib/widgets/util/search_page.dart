import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/constants.dart';
import 'package:transportia/util/mobile.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/widgets/util/error_widget.dart';

class SearchPage extends StatefulWidget {
  final String searchHint;
  final String? prefilledQuery;
  final void Function(String query) onSearch;
  final List<Widget> filters;
  final VoidCallback onClear;
  final Widget Function() results;
  final Widget Function()? resultsTable;
  final bool loading;
  final dynamic error;
  final int? currentOffset;
  final void Function(int offset)? offsetCallback;
  final VoidCallback? createCallback;
  final String Function()? nestedExternalLink;
  final bool isNested;
  final Widget? nextToSearch;

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
    this.isNested = false,
    this.nestedExternalLink,
    this.nextToSearch,
    this.error,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController search;
  Timer? _searchTimer;
  bool isTable = false;
  bool mobileDrawerShown = false;

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
    final filters = SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile(context) && widget.nextToSearch != null) ...[
            widget.nextToSearch!,
            const SizedBox(height: 8),
          ],

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
    );

    Widget main;
    if (widget.loading) {
      main = Expanded(child: Center(child: CircularProgressIndicator()));
    } else if (widget.error != null) {
      main = Expanded(
        child: Center(child: TransportiaErrorWidget(error: widget.error)),
      );
    } else {
      main = Expanded(
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
                    if (widget.createCallback != null && !widget.isNested)
                      Positioned(
                        left: 0,
                        child: IconButton(
                          onPressed: () async {
                            widget.createCallback!();
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    if (widget.isNested && widget.nestedExternalLink != null)
                      Positioned(
                        left: 0,
                        child: IconButton(
                          onPressed: () {
                            context.go(widget.nestedExternalLink!());
                          },
                          icon: const Icon(Icons.open_in_new),
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
                            final path = GoRouterState.of(context).uri.path;

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
      );
    }

    if (isMobile(context)) {
      if (mobileDrawerShown) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Filters",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      mobileDrawerShown = false;
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: filters,
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
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
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      mobileDrawerShown = true;
                    });
                  },
                  icon: const Icon(Icons.menu),
                ),
              ],
            ),

            const SizedBox(height: 8),

            main,
          ],
        );
      }
    }

    return Column(
      children: [
        if (!widget.isNested) ...[
          Row(
            children: [
              Expanded(
                child: SearchBar(
                  hintText: widget.searchHint,
                  controller: search,
                  onChanged: _onSearchChanged,
                ),
              ),
              if (widget.nextToSearch != null) ...[
                const SizedBox(width: 8),
                widget.nextToSearch!,
              ],
            ],
          ),
        ],

        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filters
              if (!widget.isNested) ...[
                SizedBox(width: 250, child: filters),

                const VerticalDivider(width: 1),
              ],

              const SizedBox(height: 8),

              main,
            ],
          ),
        ),
      ],
    );
  }
}
