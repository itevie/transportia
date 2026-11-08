import 'dart:async';

import 'package:flutter/material.dart';

Future<T?> showSearchPrompt<T>({
  required BuildContext context,
  required Future<List<T>> Function(String query) search,
  required Widget Function(T item) widgetBuilder,
  String title = "Search",
  String hintText = "Search...",
  bool showSearch = true,
}) async {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return _SearchPrompt<T>(
        search: search,
        widget: widgetBuilder,
        title: title,
        hintText: hintText,
        showSearch: showSearch,
      );
    },
  );
}

class _SearchPrompt<T> extends StatefulWidget {
  final Future<List<T>> Function(String query) search;
  final Widget Function(T item) widget;
  final String title;
  final String hintText;
  final bool showSearch;

  const _SearchPrompt({
    required this.search,
    required this.widget,
    required this.title,
    required this.hintText,
    required this.showSearch,
  });

  @override
  State<_SearchPrompt<T>> createState() => _SearchPromptState<T>();
}

class _SearchPromptState<T> extends State<_SearchPrompt<T>> {
  final controller = TextEditingController();

  List<T> results = [];
  bool loading = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    if (widget.showSearch == false) load();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        setState(() {
          results = [];
          loading = false;
        });
        return;
      }

      setState(() {
        loading = true;
      });

      try {
        final newResults = await widget.search(query);

        if (!mounted) return;

        setState(() {
          results = newResults;
          loading = false;
        });
      } catch (_) {
        if (!mounted) return;

        setState(() {
          results = [];
          loading = false;
        });
      }
    });
  }

  void load() async {
    try {
      final newResults = await widget.search("");

      if (!mounted) return;

      setState(() {
        results = newResults;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        results = [];
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 500,
        height: 400,
        child: Column(
          children: [
            if (widget.showSearch) ...[
              TextField(
                controller: controller,
                autofocus: true,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
            ],

            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];

                        return ListTile(
                          title: widget.widget(item),
                          onTap: () {
                            Navigator.pop(context, item);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
