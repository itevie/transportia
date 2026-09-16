import 'package:flutter/material.dart';
import 'package:transportia/main.dart';
import 'package:transportia/theme.dart';
import 'package:transportia/util_widgets/panel.dart';
import 'package:transportia/widgets/detail_chip.dart';
import 'package:transportia/widgets/pages/user.dart';
import 'package:transportia/widgets/profile_picture.dart';
import 'package:transportia/widgets/star_rating.dart';

class FullscreenPhotoViewer extends StatefulWidget {
  const FullscreenPhotoViewer({super.key});

  @override
  State<FullscreenPhotoViewer> createState() => _FullscreenPhotoViewerState();
}

class _FullscreenPhotoViewerState extends State<FullscreenPhotoViewer> {
  @override
  Widget build(BuildContext context) {
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
                      child: Image.network(
                        "https://album.dawn.rest/images/968/view?smid=ieyyfucika",
                        fit: BoxFit.contain,
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
                                  setAppPage(UserViewer());
                                },
                                child: Row(
                                  children: [
                                    ProfilePicture(
                                      usage: ProfilePictureUsage.nextToName,
                                    ),
                                    const SizedBox(width: 8),
                                    Text("John"),
                                  ],
                                ),
                              ),
                            ),

                            const Divider(),
                            DetailChip(
                              contents: Text("2392"),
                              icon: Icons.numbers,
                            ),
                            const SizedBox(height: 4),
                            DetailChip(
                              contents: Text("LJ91 GXD"),
                              icon: Icons.badge,
                            ),
                            const SizedBox(height: 4),
                            DetailChip(
                              contents: Text("Wright Gemini 3"),
                              icon: Icons.bus_alert,
                            ),
                            const SizedBox(height: 4),
                            DetailChip(
                              contents: Text("Bee Network"),
                              icon: Icons.palette,
                            ),
                            const SizedBox(height: 4),
                            DetailChip(
                              contents: Text("Go North West"),
                              icon: Icons.business,
                            ),
                            Spacer(),
                            Text("25/04/2026"),
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
                        children: [Text("IMG_8593.JPG"), Text("©️ Your Mom")],
                      ),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque non eros in ligula consequat dignissim. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Curabitur rutrum condimentum lectus sit amet sollicitudin. Morbi condimentum consequat orci. Nam ultrices, eros id pulvinar ullamcorper, mauris nisl sollicitudin leo, a sodales nunc magna ut lacus. Praesent quis lectus ac orci eleifend ornare ultrices nec tortor. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed suscipit arcu eget dui luctus congue. Nulla feugiat velit ut ante condimentum blandit ut at purus. Ut pulvinar erat at lacus hendrerit laoreet. Ut convallis sed metus et ultricies. Fusce vel tristique elit. Interdum et malesuada fames ac ante ipsum primis in faucibus. Etiam urna lacus, accumsan eu purus in, pellentesque blandit risus. Integer semper quis lorem id ullamcorper.",
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    StarRating(),
                    VerticalDivider(),
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
