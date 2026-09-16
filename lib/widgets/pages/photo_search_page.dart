import 'package:flutter/material.dart';
import 'package:transportia/main.dart';
import 'package:transportia/widgets/image_card.dart';
import 'package:transportia/widgets/pages/photo.dart';
import 'package:transportia/widgets/search_bar.dart';

class PhotoSearchPage extends StatefulWidget {
  const PhotoSearchPage({super.key});

  @override
  State<PhotoSearchPage> createState() => _PhotoSearchPageState();
}

class _PhotoSearchPageState extends State<PhotoSearchPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TransportiaSearchBar(),

          const SizedBox(height: 8),

          const Text("69 Photos...", textAlign: TextAlign.start),

          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 4 / 3,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return ImageCard(
                title: "Bus",
                url: "https://album.dawn.rest/images/968/view?smid=ieyyfucika",
                onTap: () {
                  setAppPage(FullscreenPhotoViewer());
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
