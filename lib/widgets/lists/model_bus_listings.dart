import 'package:flutter/material.dart';
import 'package:transportia/api/bus_listing.dart';
import 'package:transportia/widgets/object/bus_listing_card.dart';

class ModelBusListingsList extends StatelessWidget {
  final List<ApiBusListingResource> listings;

  const ModelBusListingsList({super.key, required this.listings});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 285,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3 / 4,
      ),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final listing = listings[index];
        return BusListingCard(listing: listing);
      },
    );
  }
}
