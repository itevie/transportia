import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class SearchResultsTable<T> extends StatelessWidget {
  final List<(String label, double? size, Function(T)? onTap)> columns;
  final List<T> items;
  final (Map<String, Widget> cells, Color? color) Function(T) builder;

  const SearchResultsTable({
    super.key,
    required this.columns,
    required this.builder,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      minWidth: 800,
      columnSpacing: 12,
      horizontalMargin: 8,
      fixedTopRows: 1,
      columns: [
        ...columns.map(
          (col) => DataColumn2(label: Text(col.$1), fixedWidth: col.$2),
        ),
      ],
      rows: items.map((part) {
        final results = builder(part);
        return DataRow2(
          color: results.$2 != null ? WidgetStatePropertyAll(results.$2) : null,
          cells: [
            ...columns.map((x) {
              if (!results.$1.containsKey(x.$1)) return DataCell(SizedBox());
              final data = results.$1[x.$1];
              return DataCell(
                data!,
                onTap: x.$3 != null
                    ? () {
                        x.$3!(part);
                      }
                    : null,
              );
            }),
          ],
        );
      }).toList(),
    );
  }
}
