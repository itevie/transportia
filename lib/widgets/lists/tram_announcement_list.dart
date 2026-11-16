import 'package:flutter/material.dart';
import 'package:transportia/api/tram_announcement_audios.dart';
import 'package:transportia/widgets/object/tram_announcement_audio_card.dart';
import 'package:transportia/widgets/util/sub_text.dart';

class TramAudioAnnouncementList extends StatelessWidget {
  final List<ApiTramAnnouncementAudio> announcements;
  final VoidCallback? reload;

  const TramAudioAnnouncementList({
    super.key,
    required this.announcements,
    this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 3 / 5,
          ),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final model = announcements[index];

            return TramAnnouncementAudioCard(announcement: model);
          },
        ),

        SubText(
          "Audio files from https://www.whatdotheyknow.com/request/tfgm_announcements",
        ),
      ],
    );
  }
}
