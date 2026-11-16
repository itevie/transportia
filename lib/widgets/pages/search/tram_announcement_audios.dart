import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_announcement_audios.dart';
import 'package:transportia/widgets/lists/tram_announcement_list.dart';
import 'package:transportia/widgets/lists/tram_list_rows.dart';
import 'package:transportia/widgets/util/search_page.dart';

class TramAnnouncementAudios extends StatefulWidget {
  const TramAnnouncementAudios({super.key});

  @override
  State<TramAnnouncementAudios> createState() => _TramAnnouncementAudiosState();
}

class _TramAnnouncementAudiosState extends State<TramAnnouncementAudios> {
  List<ApiTram> trams = [];
  List<String> groups = [];
  List<ApiTramAnnouncementAudio> announcements = [];

  String? query;

  String? group;

  int offset = 0;

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    final groups = await ApiTramAnnouncementAudio.getGroups();
    final audios = await ApiTramAnnouncementAudio.search(
      audioGroup: group,
      offset: offset,
      search: query?.isEmpty == null ? null : query,
    );

    setState(() {
      this.groups = groups;
      announcements = audios;
    });
  }

  void addPostLoad() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchPage(
      searchHint: "Search tram audio announcements..",
      onSearch: (v) {
        setState(() {
          query = v;
        });

        addPostLoad();
      },
      currentOffset: offset,
      offsetCallback: (v) {
        setState(() {
          offset = v;
        });

        addPostLoad();
      },
      filters: [
        ExpansionTile(
          title: Text("Group"),
          initiallyExpanded: false,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          children: groups
              .map(
                (option) => CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(option),
                  value: group == option,
                  onChanged: (_) {
                    setState(() {
                      group = group == option ? null : option;
                      offset = 0;
                    });
                    addPostLoad();
                  },
                ),
              )
              .toList(),
        ),
      ],
      onClear: () {},
      results: () => Expanded(
        child: SingleChildScrollView(
          child: TramAudioAnnouncementList(
            announcements: announcements,
            reload: load,
          ),
        ),
      ),
      resultsTable: () => Expanded(
        child: TramListRow(vehicles: trams, reload: load),
      ),
    );
  }
}
