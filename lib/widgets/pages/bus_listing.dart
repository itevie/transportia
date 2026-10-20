import 'package:flutter/material.dart';
import 'package:transportia/api/bus_listing.dart';
import 'package:transportia/theme.dart';
import 'package:transportia/util/text.dart';
import 'package:transportia/util/util.dart';
import 'package:transportia/util_widgets/panel.dart';
import 'package:transportia/widgets/detail_chip.dart';

class BusListingPage extends StatefulWidget {
  final ApiBusListingResource listing;
  const BusListingPage({super.key, required this.listing});

  @override
  State<BusListingPage> createState() => _BusListingPageState();
}

class _BusListingPageState extends State<BusListingPage> {
  @override
  Widget build(BuildContext context) {
    final image = widget.listing.imageList.split(";;;")[0];

    final height = MediaQuery.sizeOf(context).height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height * 0.75),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 250),
                        child: image.isEmpty
                            ? const Icon(Icons.broken_image)
                            : Image.network(
                                image,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),

                    const SizedBox(width: seperatorPadding),

                    SizedBox(
                      width: 250,
                      child: Panel(
                        child: Column(
                          children: [
                            Material(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  launchExternalUrl(widget.listing.origin);
                                },
                                child: Text(widget.listing.origin),
                              ),
                            ),

                            const Divider(),
                            if (widget.listing.manufacturer != null) ...[
                              DetailChip(
                                contents: Text(widget.listing.manufacturer!),
                                icon: Icons.business,
                              ),
                              const SizedBox(height: 4),
                            ],
                            if (widget.listing.manufacturerCode != null) ...[
                              DetailChip(
                                contents: Text(
                                  "${widget.listing.manufacturer} ${widget.listing.manufacturerCode!}",
                                ),
                                icon: Icons.numbers,
                              ),
                              const SizedBox(height: 4),
                            ],
                            if (widget.listing.scale != null) ...[
                              DetailChip(
                                contents: Text(widget.listing.scale!),
                                icon: Icons.straighten,
                              ),
                              const SizedBox(height: 4),
                            ],
                            if (widget.listing.condition != null) ...[
                              DetailChip(
                                contents: Text(widget.listing.condition!),
                                icon: Icons.inventory_2_outlined,
                              ),
                              const SizedBox(height: 4),
                            ],
                            // DetailChip(
                            //   contents: Text("Wright Gemini 3"),
                            //   icon: Icons.bus_alert,
                            // ),
                            // const SizedBox(height: 4),
                            // DetailChip(
                            //   contents: Text("Bee Network"),
                            //   icon: Icons.palette,
                            // ),
                            // const SizedBox(height: 4),
                            // DetailChip(
                            //   contents: Text("Go North West"),
                            //   icon: Icons.business,
                            // ),
                            if (widget.listing.total != null) ...[
                              DetailChip(
                                contents: Text(
                                  "Stock: ${widget.listing.lowest}/${widget.listing.total}",
                                ),
                                icon: Icons.error,
                              ),
                              const SizedBox(height: 4),
                            ],
                            if (widget.listing.someSoldOut == true) ...[
                              DetailChip(
                                contents: Text("Some Sold Out"),
                                icon: Icons.error,
                              ),
                              const SizedBox(height: 4),
                            ],
                            if (widget.listing.soldOut == true) ...[
                              DetailChip(
                                contents: Text("Sold Out"),
                                icon: Icons.error,
                              ),
                              const SizedBox(height: 4),
                            ],
                            Spacer(),
                            FilledButton.icon(
                              onPressed: widget.listing.link == null
                                  ? null
                                  : () {
                                      launchExternalUrl(widget.listing.link!);
                                    },
                              style: const ButtonStyle(
                                minimumSize: WidgetStatePropertyAll(
                                  Size(double.infinity, 48),
                                ),
                              ),
                              label: Text(
                                "${widget.listing.currency}${widget.listing.priceLow}",
                              ),
                              icon: const Icon(Icons.open_in_new),
                              iconAlignment: IconAlignment.end,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.listing.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (widget.listing.description != null)
                        Text(stripHtml(widget.listing.description!)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.save)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
