import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/widgets/object/tram_operator.dart';
import 'package:transportia/widgets/util/t_search_bar.dart';

class ToolTramOperatorsPage extends StatefulWidget {
  const ToolTramOperatorsPage({super.key});

  @override
  State<ToolTramOperatorsPage> createState() => _ToolTramOperatorsPageState();
}

class _ToolTramOperatorsPageState extends State<ToolTramOperatorsPage> {
  List<ApiTramOperator> operators = [];

  @override
  void initState() {
    super.initState();

    load("");
  }

  void load(String query) async {
    final loaded = await ApiTramOperator.search(query);

    setState(() {
      operators = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TSearchBar(
                hintText: 'Search operators...',
                onChanged: (String value) {
                  load(value);
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () {
                context.go("/tram-operators/create");
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: operators
                .map((x) => TramOperatorView(operator: x))
                .toList(),
          ),
        ),
      ],
    );
  }
}
