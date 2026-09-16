import 'package:dawn_ui_flutter/util.dart';
import 'package:flutter/material.dart';
import 'package:transportia/widgets/pages/filter_search.dart';

class TransportiaSearchBar extends StatefulWidget {
  const TransportiaSearchBar({super.key});

  @override
  State<TransportiaSearchBar> createState() => _TransportiaSearchBarState();
}

class _TransportiaSearchBarState extends State<TransportiaSearchBar> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBar(
            controller: controller,
            hintText: "Search Photos...",
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: () {
            navigate(context, FilterSearch(callback: (r) => {}));
          },
          icon: const Icon(Icons.filter_list),
        ),
      ],
    );
  }
}
