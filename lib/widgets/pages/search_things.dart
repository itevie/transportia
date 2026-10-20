import 'package:flutter/material.dart';
import 'package:transportia/main_old.dart';
import 'package:transportia/prompts/operator_search.dart';
import 'package:transportia/widgets/pages/operator_page.dart';

class SearchThingsPage extends StatefulWidget {
  const SearchThingsPage({super.key});

  @override
  State<SearchThingsPage> createState() => _SearchThingsPageState();
}

class _SearchThingsPageState extends State<SearchThingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final op = await showOperatorSearchPrompt(context: context);

            if (op == null) return;

            setAppPage(OperatorPage(operator: op));
          },
          child: Text("Operators"),
        ),
      ],
    );
  }
}
