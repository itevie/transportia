import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/prompts/photo_type.dart';
import 'package:transportia/prompts/progress.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/util/date.dart';
import 'package:transportia/util/images.dart';
import 'package:transportia/widgets/lists/photo_list.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  List<ApiPhoto> userPictures = [];
  Map<String, List<ApiPhoto>> mappedUserPictures = {};

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    final userPictures = await ApiPhoto.fetchAll(
      authorId: context.read<CurrentUserStore>().user!.id,
    );

    final mapped = <String, List<ApiPhoto>>{};

    for (final picture in userPictures) {
      final date = DateTime.parse(picture.createdAt);

      final day = DateTime(date.year, date.month, date.day);

      mapped.putIfAbsent(day.toIso8601String(), () => []);
      mapped[day.toIso8601String()]!.add(picture);
    }

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
    final photoType = await showPhotoTypePrompt(context: context);

    if (photoType == null) return;

    final images = await pickImages();

    await showLoadingPrompt(
      context,
      (onProgress) =>
          ApiPhoto.upload(images, photoType, onProgress: onProgress),
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
              title: Text("${formatIsoDate(x.key)} (${x.value.length} Photos)"),
              initiallyExpanded: x.key == mappedUserPictures.entries.first.key,
              children: [PhotoList(photos: x.value)],
            );
          }),
        ],
      ),
    );
  }
}
