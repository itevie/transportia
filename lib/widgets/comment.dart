import 'package:flutter/material.dart';
import 'package:transportia/api/comment.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/util_widgets/drop_down.dart';
import 'package:transportia/util_widgets/sub_text.dart';
import 'package:transportia/widgets/favourite_icon.dart';
import 'package:transportia/widgets/profile_picture.dart';

class CommentWidget extends StatefulWidget {
  final ApiComment comment;
  final bool subComment;
  final VoidCallback? onReply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onNeedUpdate;

  const CommentWidget({
    super.key,
    required this.comment,
    this.subComment = false,
    this.onReply,
    this.onEdit,
    this.onDelete,
    this.onNeedUpdate,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _showReplies = false;

  String _formatDate(String date) {
    final parsed = DateTime.tryParse(date)?.toLocal();

    if (parsed == null) return date;

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final year = parsed.year.toString();

    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfilePicture(usage: ProfilePictureUsage.nextToName),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.author.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      SubText(_formatDate(comment.createdAt)),
                      if (comment.edited) ...[
                        const SizedBox(width: 4),
                        const SubText('Edited'),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.body,
                    style: widget.subComment
                        ? const TextStyle(fontSize: 12)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            FavouriteButton(
                              type: FavouriteType.comment,
                              id: comment.id.toString(),
                              isFavourited: comment.isFavourited,
                              onChanged: () async {
                                widget.onNeedUpdate?.call();
                              },
                            ),
                            TextButton.icon(
                              onPressed: widget.onReply,
                              icon: const Icon(Icons.reply),
                              label: const Text('Reply'),
                            ),
                            if (widget.onEdit != null)
                              TextButton.icon(
                                onPressed: widget.onEdit,
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Edit'),
                              ),
                          ],
                        ),
                      ),
                      TDropDownMenu(
                        options: {
                          "Edit": () {},
                          "Delete": () {
                            if (widget.onDelete != null) widget.onDelete!();
                          },
                        },
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
