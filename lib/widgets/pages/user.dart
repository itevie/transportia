import 'package:flutter/material.dart';
import 'package:transportia/main.dart';
import 'package:transportia/util_widgets/icon_with_text.dart';
import 'package:transportia/widgets/image_card.dart';
import 'package:transportia/widgets/pages/photo.dart';
import 'package:transportia/widgets/profile_picture.dart';
import 'package:transportia/widgets/search_bar.dart';

class UserViewer extends StatelessWidget {
  const UserViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ProfilePicture(
                            usage: ProfilePictureUsage.userProfile,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "John",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconWithText(
                            text: Text("10"),
                            icon: Icon(Icons.camera),
                          ),
                          IconWithText(
                            text: Text("23"),
                            icon: Icon(Icons.comment),
                          ),
                          IconWithText(
                            text: Text("442"),
                            icon: Icon(Icons.favorite),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque non eros in ligula consequat dignissim. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Curabitur rutrum condimentum lectus sit amet sollicitudin. Morbi condimentum consequat orci. Nam ultrices, eros id pulvinar ullamcorper, mauris nisl sollicitudin leo, a sodales nunc magna ut lacus. Praesent quis lectus ac orci eleifend ornare ultrices nec tortor. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed suscipit arcu eget dui luctus congue. Nulla feugiat velit ut ante condimentum blandit ut at purus. Ut pulvinar erat at lacus hendrerit laoreet. Ut convallis sed metus et ultricies. Fusce vel tristique elit. Interdum et malesuada fames ac ante ipsum primis in faucibus. Etiam urna lacus, accumsan eu purus in, pellentesque blandit risus. Integer semper quis lorem id ullamcorper.",
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

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
