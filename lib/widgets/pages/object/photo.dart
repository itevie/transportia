import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/comment.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/photo_rating_response.dart';
import 'package:transportia/main.dart';
import 'package:transportia/prompts/todo.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/theme.dart';
import 'package:transportia/util/date.dart';
import 'package:transportia/widgets/pages/object/photo_details/bus.dart';
import 'package:transportia/widgets/pages/object/photo_details/model_bus.dart';
import 'package:transportia/widgets/pages/object/photo_details/tram.dart';
import 'package:transportia/widgets/util/panel.dart';
import 'package:transportia/widgets/comment_thread.dart';
import 'package:transportia/widgets/favourite_icon.dart';
import 'package:transportia/widgets/profile_picture.dart';
import 'package:transportia/widgets/util/photo_type_badge.dart';
import 'package:transportia/widgets/util/progressive_photo.dart';
import 'package:transportia/widgets/star_rating.dart';

class BusPhotoViewer extends StatefulWidget {
  final ApiPhoto photo;
  const BusPhotoViewer({super.key, required this.photo});

  @override
  State<BusPhotoViewer> createState() => _BusPhotoViewerState();
}

class _BusPhotoViewerState extends State<BusPhotoViewer> {
  late ApiPhoto photo;
  ApiPhotoRatingResponse? photoRating;

  final busPhotoBit = GlobalKey<BusPhotoDetailsBitState>();
  final tramPhotoBit = GlobalKey<TramPhotoDetailsBitState>();
  final modelBusPhotoBit = GlobalKey<ModelBusPhotoDetailsBitState>();

  List<ApiComment> comments = [];

  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    photo = widget.photo;

    load(fetchPhoto: true);
  }

  void load({bool fetchPhoto = false}) async {
    ApiPhotoRatingResponse? rating;
    if (context.read<CurrentUserStore>().loggedIn) {
      rating = await widget.photo.getRating();
    }

    final comments = widget.photo.commentThread == null
        ? null
        : await ApiComment.fetchByThread(widget.photo.commentThread!);

    if (fetchPhoto) {
      loadPhoto();
    }

    setState(() {
      if (rating != null) photoRating = rating;
      if (comments != null) this.comments = comments;
    });
  }

  void loadPhoto() async {
    final photo = await ApiPhoto.fetch(widget.photo.id);

    setState(() {
      this.photo = photo;
    });
  }

  void save() {
    if (photo.photoType == PhotoType.bus) {
      busPhotoBit.currentState?.save();
    } else if (photo.photoType == PhotoType.tram) {
      tramPhotoBit.currentState?.save();
    } else if (photo.photoType == PhotoType.modelBus) {
      modelBusPhotoBit.currentState?.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<CurrentUserStore>();
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
                      child: ProgressivePhotoImage(
                        thumbnailWidth: 200,
                        imageUrl: (width) => photo.withSize(width),
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
                                  context.go("/user/${photo.author!.id}");
                                  // setAppPage(UserViewer(user: photo.author));
                                },
                                child: Row(
                                  children: [
                                    ProfilePicture(
                                      usage: ProfilePictureUsage.nextToName,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        photo.author!.displayName ??
                                            photo.author!.username,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (user.loggedIn &&
                                        user.user!.id == photo.author!.id)
                                      isEditing
                                          ? Row(
                                              children: [
                                                IconButton(
                                                  key: Key("delete"),
                                                  onPressed: () async {
                                                    final confirmation =
                                                        await showConfirmPrompt(
                                                          context,
                                                          const Text(
                                                            "Confirm Deletion",
                                                          ),
                                                          Text(
                                                            "Are you sure you want to delete this photo? The photo and all it's details will be deleted and unrecoverable.",
                                                          ),
                                                        );

                                                    if (!confirmation) return;

                                                    await photo.delete();

                                                    if (lastUri != null) {
                                                      context.go(lastUri!);
                                                    } else {
                                                      context.go("/photos");
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                IconButton(
                                                  key: Key("cancel"),
                                                  onPressed: () {
                                                    setState(() {
                                                      isEditing = false;
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: save,
                                                  icon: const Icon(Icons.save),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                IconButton(
                                                  key: Key("edit"),
                                                  onPressed: () {
                                                    setState(() {
                                                      isEditing = true;
                                                    });
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                ),
                                              ],
                                            ),
                                  ],
                                ),
                              ),
                            ),

                            const Divider(),

                            if (photo.photoType == PhotoType.bus)
                              BusPhotoDetailsBit(
                                key: busPhotoBit,
                                photo: photo,
                                isEditing: isEditing,
                                cancelEdit: () {
                                  setState(() {
                                    isEditing = false;
                                  });
                                  loadPhoto();
                                },
                              ),
                            if (photo.photoType == PhotoType.tram)
                              TramPhotoDetailsBit(
                                key: tramPhotoBit,
                                photo: photo,
                                isEditing: isEditing,
                                cancelEdit: () {
                                  setState(() {
                                    isEditing = false;
                                  });
                                  loadPhoto();
                                },
                              ),
                            if (photo.photoType == PhotoType.modelBus)
                              ModelBusPhotoDetailsBit(
                                key: modelBusPhotoBit,
                                photo: photo,
                                isEditing: isEditing,
                                cancelEdit: () {
                                  setState(() {
                                    isEditing = false;
                                  });
                                  loadPhoto();
                                },
                              ),

                            Spacer(),
                            Row(
                              children: [
                                Text(formatIsoDate(photo.createdAt)),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    todo(context);
                                  },
                                  icon: const Icon(Icons.info_outline),
                                ),
                                IconButton(
                                  onPressed: () {
                                    todo(context);
                                  },
                                  icon: const Icon(Icons.share),
                                ),
                              ],
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
                            photo.title.isEmpty ? photo.fileName : photo.title,
                          ),
                          Text("©️ Your Mom"),
                        ],
                      ),
                      if (photo.description != null) Text(photo.title),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    PhotoTypeBadge(photoType: photo.photoType),

                    const SizedBox(width: 8),

                    photoRating == null
                        ? StarRating(
                            averageRating: 0,
                            userRating: 0,
                            removeRating: () {},
                            setRating: (_) {},
                          )
                        : StarRating(
                            averageRating: photoRating!.averageRating,
                            userRating: photoRating!.rating,
                            removeRating: () async {
                              final response = await widget.photo
                                  .deleteRating();

                              setState(() {
                                photoRating = response;
                              });
                            },
                            setRating: (int rating) async {
                              final response = await widget.photo.setRating(
                                rating,
                              );

                              setState(() {
                                photoRating = response;
                              });
                            },
                          ),

                    const SizedBox(width: 8),

                    FavouriteButton(
                      type: FavouriteType.photo,
                      id: photo.id.toString(),
                      isFavourited: photo.isFavourited,
                      onChanged: () async => load(fetchPhoto: true),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.photo.commentThread != null) ...[
              const SizedBox(height: 8),
              CommentThread(
                threadId: widget.photo.commentThread!,
                comments: comments,
                onChange: () => load(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
