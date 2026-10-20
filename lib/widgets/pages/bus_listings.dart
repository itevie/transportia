import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:transportia/api/bus_listing.dart';
import 'package:transportia/api/bus_listing_options.dart';
import 'package:transportia/widgets/bus_listing_card.dart';
import 'package:transportia/widgets/search_page.dart';

class BusListingsPage extends StatefulWidget {
  const BusListingsPage({super.key});

  @override
  State<BusListingsPage> createState() => _BusListingsPageState();
}

class _BusListingsPageState extends State<BusListingsPage> {
  List<ApiBusListingResource> busListings = [];

  ApiBusListingQueryOptions? queryOptions;

  String? sortBy;
  String? searchedScale;
  String? searchedOrigin;
  String? searchedManufacturer;
  String? searchedCondition;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load({String? query}) async {
    final listings = await ApiBusListingResource.fetchAll(
      search: query,
      sortBy: sortBy,
      scale: searchedScale,
      manufacturer: searchedManufacturer,
      origin: searchedOrigin,
      condition: searchedCondition,
    );

    final options = await ApiBusListingQueryOptions.fetch();

    if (!mounted) return;

    setState(() {
      queryOptions = options;

      busListings = listings
          .skip(listings.length > 50 ? listings.length - 50 : 0)
          .toList();
    });
  }

  void addPostLoad() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      load();
    });
  }

  Widget _buildOptionFilter({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onChanged,
  }) {
    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: false,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      children: options
          .map(
            (option) => CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(option),
              value: selected == option,
              onChanged: (_) {
                onChanged(selected == option ? null : option);
                addPostLoad();
              },
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchPage(
      searchHint: 'Search',
      onSearch: (value) => load(query: value.isEmpty ? null : value),
      filters: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Sort',
            border: OutlineInputBorder(),
          ),
          value: sortBy == null
              ? 'None'
              : sortBy!
                    .replaceAll('-', ' ')
                    .split(' ')
                    .map(
                      (word) => word.isEmpty
                          ? word
                          : '${word[0].toUpperCase()}${word.substring(1)}',
                    )
                    .join(' '),
          items: const [
            DropdownMenuItem(value: 'None', child: Text('None')),
            DropdownMenuItem(
              value: 'price-low-high',
              child: Text('Price Low - High'),
            ),
            DropdownMenuItem(
              value: 'price-high-low',
              child: Text('Price High - Low'),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              sortBy = value == 'None' ? null : value;
            });

            addPostLoad();
          },
        ),
        _buildOptionFilter(
          title: 'Scale',
          options: queryOptions?.scale ?? [],
          selected: searchedScale,
          onChanged: (value) {
            setState(() {
              searchedScale = value;
            });
          },
        ),
        _buildOptionFilter(
          title: 'Origin',
          options: queryOptions?.originCode ?? [],
          selected: searchedOrigin,
          onChanged: (value) {
            setState(() {
              searchedOrigin = value;
            });
          },
        ),
        _buildOptionFilter(
          title: 'Manufacturer',
          options: queryOptions?.manufacturer ?? [],
          selected: searchedManufacturer,
          onChanged: (value) {
            setState(() {
              searchedManufacturer = value;
            });
          },
        ),
        _buildOptionFilter(
          title: 'Condition',
          options: queryOptions?.condition ?? [],
          selected: searchedCondition,
          onChanged: (value) {
            setState(() {
              searchedCondition = value;
            });
          },
        ),
      ],
      onClear: () {
        setState(() {
          sortBy = null;
          searchedScale = null;
          searchedOrigin = null;
          searchedManufacturer = null;
          searchedCondition = null;
        });

        addPostLoad();
      },
      results: Expanded(
        child: SingleChildScrollView(
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 285,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3 / 4,
            ),
            itemCount: busListings.length,
            itemBuilder: (context, index) {
              final listing = busListings[index];
              return BusListingCard(listing: listing);
            },
          ),
        ),
      ),
    );
  }
}
