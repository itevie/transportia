import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:transportia/api/tram_announcement_audios.dart';
import 'package:transportia/main.dart';
import 'package:transportia/theme.dart';
import 'package:transportia/widgets/util/sub_text.dart';

class TramAnnouncementAudioCard extends StatefulWidget {
  final ApiTramAnnouncementAudio announcement;

  const TramAnnouncementAudioCard({super.key, required this.announcement});

  @override
  State<TramAnnouncementAudioCard> createState() =>
      _TramAnnouncementAudioCardState();
}

class _TramAnnouncementAudioCardState extends State<TramAnnouncementAudioCard> {
  final AudioPlayer player = AudioPlayer();

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  Future<void> playAudio() async {
    if (isPlaying) {
      await player.pause();
      return;
    }

    try {
      await player.play(UrlSource(widget.announcement.audioUrl));
    } catch (e) {
      showError(e.toString());
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: playAudio,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              color: cardBgColor(context),
              child: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.volume_up,
                size: 64,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.announcement.label ?? widget.announcement.fileName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SubText(widget.announcement.audioGroup),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
