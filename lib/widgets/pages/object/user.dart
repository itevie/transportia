import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/api.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/user.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/widgets/pages/favourites_page.dart';
import 'package:transportia/widgets/pages/not_implemented.dart';
import 'package:transportia/widgets/util/icon_with_text.dart';
import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/profile_picture.dart';
import 'package:transportia/widgets/util/tab_bar.dart';

class UserViewer extends StatefulWidget {
  final ApiUser user;
  const UserViewer({super.key, required this.user});

  @override
  State<UserViewer> createState() => _UserViewerState();
}

class _UserViewerState extends State<UserViewer> {
  late ApiUser user;
  List<ApiPhoto> photos = [];

  late TextEditingController usernameController;
  late TextEditingController displayNameController;
  late TextEditingController bioController;

  bool isEditinng = false;

  @override
  void initState() {
    super.initState();

    user = widget.user;

    bioController = TextEditingController();
    displayNameController = TextEditingController();
    usernameController = TextEditingController();

    bioController.addListener(() {
      setState(() {});
    });

    displayNameController.addListener(() {
      setState(() {});
    });

    usernameController.addListener(() {
      setState(() {});
    });

    load();
  }

  void load() async {
    final userPhotos = await ApiPhoto.fetchAll(authorId: widget.user.id);

    setState(() {
      photos = userPhotos;
    });
  }

  void startEditing() {
    setState(() {
      bioController.text = user.bio ?? "";
      displayNameController.text = user.displayName ?? "";
      usernameController.text = user.username;
      isEditinng = true;
    });
  }

  void save() async {
    await user.update(
      username: usernameController.text,
      displayName: PatchField.set(
        displayNameController.text.isEmpty ? null : displayNameController.text,
      ),
      bio: PatchField.set(
        bioController.text.isEmpty ? null : bioController.text,
      ),
    );

    final newUser = await ApiUser.get(user.id);

    setState(() {
      user = newUser!;
      isEditinng = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUserStore>();

    return Column(
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
                        ProfilePicture(usage: ProfilePictureUsage.userProfile),
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
                                            hintText: "Display Name",
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
                                    user.displayName ?? "",
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
                                          controller: usernameController,
                                          maxLength: 16,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: const InputDecoration(
                                            hintText: "@username",
                                            isDense: true,
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                            counterText: "",
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${usernameController.text.length}/16",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(user.username),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (currentUser.loggedIn &&
                            widget.user.id == currentUser.user!.id)
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
                    : Text(user.bio ?? "", textAlign: TextAlign.start),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        Expanded(
          child: AppTabController(
            tabs: [
              AppTab(
                id: "photos",
                name: "Photos (${photos.length})",
                icon: Icons.photo,
                child: SingleChildScrollView(child: PhotoList(photos: photos)),
              ),
              AppTab(
                id: "owned_models",
                name: "Owned Models",
                icon: Icons.directions_bus,
                child: SingleChildScrollView(child: NotImplementedPage()),
              ),
              if (currentUser.user?.id == user.id || user.publicFavourites)
                AppTab(
                  id: "favourites",
                  name: "Favourites",
                  icon: Icons.favorite,
                  child: FavouritesPageNew(isNested: true, user: user),
                ),
            ],
          ),
        ),

        // Row(
        //   children: [
        //     Text("${photos.length} Photos...", textAlign: TextAlign.start),
        //     Spacer(),
        //     IconButton(
        //       onPressed: () {
        //         context.go("/photos?author=${widget.user.id}");
        //         // setAppPage(PhotoSearchPage(author: widget.user));
        //       },
        //       icon: const Icon(Icons.search),
        //     ),
        //   ],
        // ),

        // BusPhotoList(photos: photos),
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
    );
  }
}
