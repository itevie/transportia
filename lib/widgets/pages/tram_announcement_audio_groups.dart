import 'package:flutter/material.dart';
import 'package:transportia/api/tram_announcement_audios.dart';

class TramAnnouncementAudioGroups extends StatefulWidget {
  const TramAnnouncementAudioGroups({super.key});

  @override
  State<TramAnnouncementAudioGroups> createState() =>
      _TramAnnouncementAudioGroupsState();
}

class _TramAnnouncementAudioGroupsState
    extends State<TramAnnouncementAudioGroups> {
  List<String> groups = [];

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    final groups = await ApiTramAnnouncementAudio.getGroups();

    setState(() {
      this.groups = groups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];

        return ListTile(
          leading: const Icon(Icons.folder_outlined),
          title: Text(group),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // widget.onTap?.call(group);
          },
        );
      },
    );
  }
}
