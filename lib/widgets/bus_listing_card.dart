import 'package:flutter/material.dart';
import 'package:transportia/api/bus_listing.dart';
import 'package:transportia/main_old.dart';
import 'package:transportia/util_widgets/sub_text.dart';
import 'package:transportia/widgets/pages/bus_listing.dart';

class BusListingCard extends StatefulWidget {
  final ApiBusListingResource listing;

  const BusListingCard({super.key, required this.listing});

  @override
  State<BusListingCard> createState() => _BusListingCardState();
}

class _BusListingCardState extends State<BusListingCard> {
  @override
  Widget build(BuildContext context) {
    final image = widget.listing.imageList.split(";;;")[0];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          setAppPage(BusListingPage(listing: widget.listing));
        },
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 150,
              child: image.isEmpty
                  ? const Icon(Icons.broken_image)
                  : Image.network(
                      image,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 48,
                    child: Text(
                      widget.listing.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "${widget.listing.currency}${widget.listing.priceLow}${widget.listing.priceLow != widget.listing.priceHigh ? " - ${widget.listing.currency}${widget.listing.priceHigh}" : ""}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SubText(widget.listing.originCode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
