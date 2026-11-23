import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:transportia/api/tram_announcement_audios.dart';
import 'package:transportia/main.dart';
import 'package:transportia/widgets/util/seach_results_table.dart';

class TramAudioAnnouncementRow extends StatelessWidget {
  final List<ApiTramAnnouncementAudio> announcements;

  const TramAudioAnnouncementRow({super.key, required this.announcements});

  @override
  Widget build(BuildContext context) {
    return SearchResultsTable<ApiTramAnnouncementAudio>(
      columns: [
        ('Play', 70, null),
        ('Name', null, null),
        ('Audio Group', 200, null),
      ],
      builder: (ApiTramAnnouncementAudio announcement) {
        return (
          {
            'Play': AudioAnnouncementPlayer(announcement: announcement),
            'Name': Text(
              announcement.label ?? announcement.fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            'Audio Group': Text(announcement.audioGroup),
          },
          null,
        );
      },
      items: announcements,
    );
  }
}

class AudioAnnouncementPlayer extends StatefulWidget {
  final ApiTramAnnouncementAudio announcement;

  const AudioAnnouncementPlayer({super.key, required this.announcement});

  @override
  State<AudioAnnouncementPlayer> createState() =>
      _AudioAnnouncementPlayerState();
}

class _AudioAnnouncementPlayerState extends State<AudioAnnouncementPlayer> {
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
    return IconButton(
      tooltip: isPlaying ? 'Pause audio' : 'Play audio',
      onPressed: playAudio,
      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
    );
  }
}
