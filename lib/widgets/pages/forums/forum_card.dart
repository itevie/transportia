import 'package:flutter/material.dart';

class ForumCard extends StatelessWidget {
  const ForumCard({super.key});

  @override
  Widget build(BuildContext context) {
    final metadataStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: Colors.grey);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.push_pin_outlined, size: 16),
                        const SizedBox(width: 4),
                        const Text(
                          "Header",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    const Text("Forum Description"),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        _metadata(
                          Icons.people_outline,
                          "20 members",
                          metadataStyle,
                        ),
                        _metadata(
                          Icons.forum_outlined,
                          "2 posts",
                          metadataStyle,
                        ),
                        _metadata(Icons.schedule, "20 mins ago", metadataStyle),
                        _metadata(
                          Icons.person_outline,
                          "by Isabella",
                          metadataStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metadata(IconData icon, String text, TextStyle? style) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: style),
      ],
    );
  }
}
