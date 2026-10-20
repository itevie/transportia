import 'package:flutter/material.dart';

import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/main_old.dart';
import 'package:transportia/widgets/bus_photo_image_card.dart';
import 'package:transportia/widgets/pages/bus_photo.dart';

class BusPhotoList extends StatelessWidget {
  final List<ApiFilledOutPhotoBus> photos;

  const BusPhotoList({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 4 / 3,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];

        return BusPhotoImageCard(
          key: Key(photo.id.toString()),
          photo: photo,
          onTap: () {
            setAppPage(BusPhotoViewer(photo: photo));
          },
        );
      },
    );
  }
}
