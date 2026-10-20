import 'package:flutter/material.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/api/user.dart';
import 'package:transportia/main_old.dart';
import 'package:transportia/util_widgets/icon_with_text.dart';
import 'package:transportia/widgets/lists/bus_photos_list.dart';
import 'package:transportia/widgets/pages/photo_search_page.dart';
import 'package:transportia/widgets/profile_picture.dart';

class UserViewer extends StatefulWidget {
  final ApiUser user;
  const UserViewer({super.key, required this.user});

  @override
  State<UserViewer> createState() => _UserViewerState();
}

class _UserViewerState extends State<UserViewer> {
  List<ApiFilledOutPhotoBus> photos = [];

  String? bio =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque non eros in ligula consequat dignissim. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Curabitur rutrum condimentum lectus sit amet sollicitudin. Morbi condimentum consequat orci. Nam ultrices, eros id pulvinar ullamcorper, mauris nisl sollicitudin leo, a sodales nunc magna ut lacus. Praesent quis lectus ac orci eleifend ornare ultrices nec tortor. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed suscipit arcu eget dui luctus congue. Nulla feugiat velit ut ante condimentum blandit ut at purus. Ut pulvinar erat at lacus hendrerit laoreet. Ut convallis sed metus et ultricies. Fusce vel tristique elit. Interdum et malesuada fames ac ante ipsum primis in faucibus. Etiam urna lacus, accumsan eu purus in, pellentesque blandit risus. Integer semper quis lorem id ullamcorper.";
  String handle = "@john";
  String displayName = "John";

  late TextEditingController handleController;
  late TextEditingController displayNameController;
  late TextEditingController bioController;

  bool isEditinng = false;

  @override
  void initState() {
    super.initState();

    bio = widget.user.bio;
    handle = widget.user.username;
    displayName = widget.user.displayName ?? widget.user.username;

    bioController = TextEditingController();
    displayNameController = TextEditingController();
    handleController = TextEditingController();

    bioController.addListener(() {
      setState(() {});
    });

    displayNameController.addListener(() {
      setState(() {});
    });

    handleController.addListener(() {
      setState(() {});
    });

    load();
  }

  void load() async {
    final userPhotos = await ApiFilledOutPhotoBus.fetchAll(
      authorId: widget.user.id,
    );

    setState(() {
      photos = userPhotos;
    });
  }

  void startEditing() {
    setState(() {
      bioController.text = bio ?? "";
      displayNameController.text = displayName;
      handleController.text = handle;
      isEditinng = true;
    });
  }

  void save() {
    setState(() {
      isEditinng = false;
      bio = bioController.text;
      displayName = displayNameController.text;
      handle = handleController.text;
    });
  }

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
                crossAxisAlignment: CrossAxisAlignment.start,

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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isEditinng
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: 400,
                                          child: TextField(
                                            maxLength: 32,
                                            controller: displayNameController,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText: "Username",
                                              isDense: true,
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                              counterText: "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${displayNameController.text.length}/32",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      displayName,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                              isEditinng
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: 400,
                                          child: TextField(
                                            controller: handleController,
                                            maxLength: 16,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText: "@handle",
                                              isDense: true,
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                              counterText: "",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${handleController.text.length}/16",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(handle),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isEditinng
                              ? FilledButton.icon(
                                  label: const Text("Save"),
                                  onPressed: () {
                                    save();
                                  },
                                  icon: const Icon(Icons.save),
                                )
                              : ElevatedButton.icon(
                                  onPressed: () {
                                    startEditing();
                                  },
                                  label: Text("Edit"),
                                  icon: const Icon(Icons.edit),
                                ),
                          const SizedBox(height: 4),
                          IconWithText(
                            text: Text(photos.length.toString()),
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
                  isEditinng
                      ? TextField(
                          controller: bioController,
                          maxLines: 5,
                          maxLength: 1000,
                          decoration: InputDecoration(
                            hintText: "Type your bio...",
                            border: OutlineInputBorder(),
                          ),
                        )
                      : Text(bio ?? "", textAlign: TextAlign.start),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text("${photos.length} Photos...", textAlign: TextAlign.start),
              Spacer(),
              IconButton(
                onPressed: () {
                  setAppPage(PhotoSearchPage(author: widget.user));
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),

          BusPhotoList(photos: photos),
          // GridView.builder(
          //   shrinkWrap: true,
          //   padding: const EdgeInsets.all(8),
          //   physics: const NeverScrollableScrollPhysics(),
          //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //     maxCrossAxisExtent: 250,
          //     crossAxisSpacing: 8,
          //     mainAxisSpacing: 8,
          //     childAspectRatio: 4 / 3,
          //   ),
          //   itemCount: photos.length,
          //   itemBuilder: (context, index) {
          //     final photo = photos[index];
          //     return ImageCard(
          //       title: photo.fileName,
          //       url: "https://transportia-cdn.dawn.rest/${photo.uploadedId}",
          //       onTap: () {
          //         setAppPage(BusPhotoViewer(photo: photo));
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
