import 'package:flutter/widgets.dart';
import 'package:transportia/widgets/pages/forums/forum_card.dart';

class ForumsPage extends StatelessWidget {
  const ForumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ForumCard(),
          ForumCard(),
          ForumCard(),
          ForumCard(),
          ForumCard(),
        ],
      ),
    );
  }
}
