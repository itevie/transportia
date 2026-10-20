import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/prompts/progress.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/util/images.dart';
import 'package:transportia/widgets/lists/bus_photos_list.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  List<ApiFilledOutPhotoBus> userPictures = [];
  Map<String, List<ApiFilledOutPhotoBus>> mappedUserPictures = {};

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    final userPictures = await ApiFilledOutPhotoBus.fetchAll(
      authorId: context.read<CurrentUserStore>().user!.id,
    );

    final mapped = <String, List<ApiFilledOutPhotoBus>>{};

    for (final picture in userPictures) {
      final date = DateTime.parse(picture.createdAt);

      // Remove the time component.
      final day = DateTime(date.year, date.month, date.day);

      mapped.putIfAbsent(day.toIso8601String(), () => []);
      mapped[day.toIso8601String()]!.add(picture);
    }

    // Sort newest date first.
    final sorted = Map.fromEntries(
      mapped.entries.toList()..sort(
        (a, b) => DateTime.parse(b.key).compareTo(DateTime.parse(a.key)),
      ),
    );

    setState(() {
      this.userPictures = userPictures;
      mappedUserPictures = sorted;
    });
  }

  void upload() async {
    final images = await pickImages();

    // await ApiFilledOutPhotoBus.upload(images);

    await showLoadingPrompt(
      context,
      (onProgress) =>
          ApiFilledOutPhotoBus.upload(images, onProgress: onProgress),
      title: const Text("Uploading photos"),
      message: const Text("Please wait while your photos upload…"),
    );

    load();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Your Uploads",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              Spacer(),
              FilledButton.icon(
                onPressed: upload,
                label: const Text("Upload"),
                icon: const Icon(Icons.upload),
              ),
            ],
          ),
          ...mappedUserPictures.entries.map((x) {
            return ExpansionTile(
              title: Text("${x.key.toString()} (${x.value.length} Photos)"),
              initiallyExpanded: x.key == mappedUserPictures.entries.first.key,
              children: [
                BusPhotoList(photos: x.value),
                // GridView.builder(
                //   shrinkWrap: true,
                //   padding: const EdgeInsets.all(8),
                //   physics: const NeverScrollableScrollPhysics(),
                //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                //     maxCrossAxisExtent: 250,
                //     crossAxisSpacing: 8,
                //     mainAxisSpacing: 8,
                //     childAspectRatio: 1 / 1,
                //   ),
                //   itemCount: x.value.length,
                //   itemBuilder: (context, index) {
                //     final image = x.value[index];
                //     return ImageCard(
                //       onTap: () {
                //         setAppPage(BusPhotoViewer(photo: image));
                //       },
                //       title: image.fileName,
                //       url: image.withSize(300),
                //     );
                //   },
                // ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
