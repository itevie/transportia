import 'package:flutter/material.dart';
import 'package:transportia/api/comment.dart';
import 'package:transportia/widgets/comment.dart';
import 'package:transportia/widgets/profile_picture.dart';

class CommentThread extends StatefulWidget {
  final int threadId;
  final List<ApiComment> comments;
  final VoidCallback onChange;

  const CommentThread({
    super.key,
    required this.threadId,
    required this.comments,
    required this.onChange,
  });

  @override
  State<CommentThread> createState() => _CommentThreadState();
}

class _CommentThreadState extends State<CommentThread> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  Future<void> _sendComment() async {
    final body = _controller.text.trim();

    if (body.isEmpty || _sending) return;

    setState(() => _sending = true);

    try {
      await ApiComment.create(thread: widget.threadId, body: body);

      if (!mounted) return;

      _controller.clear();

      widget.onChange();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send comment: $e')));
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePicture(usage: ProfilePictureUsage.nextToName),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Write a comment...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                onSubmitted: (_) => _sendComment(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _sending ? null : _sendComment,
              tooltip: 'Send comment',
              icon: _sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...widget.comments.map(
          (comment) => CommentWidget(
            comment: comment,
            onNeedUpdate: () {
              widget.onChange();
            },
            onDelete: () async {
              await comment.delete();
              widget.onChange();
            },
          ),
        ),
      ],
    );
  }
}
