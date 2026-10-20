import 'dart:async';

import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String searchHint;
  final String? prefilledQuery;
  final void Function(String query) onSearch;
  final List<Widget> filters;
  final VoidCallback onClear;
  final Widget results;
  final bool loading;

  const SearchPage({
    super.key,
    required this.searchHint,
    required this.onSearch,
    required this.filters,
    required this.onClear,
    required this.results,
    this.loading = false,
    this.prefilledQuery,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController search;
  Timer? _searchTimer;

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
                Center(child: CircularProgressIndicator())
              else
                widget.results,
            ],
          ),
        ),
      ],
    );
  }
}
