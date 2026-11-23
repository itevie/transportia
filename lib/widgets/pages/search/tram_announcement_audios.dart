import 'package:flutter/material.dart';
import 'package:transportia/api/tram_announcement_audios.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';
import 'package:transportia/widgets/lists/tram_announcement_list.dart';
import 'package:transportia/widgets/lists/tram_anouncement_rows.dart';
import 'package:transportia/widgets/util/fully_search_page.dart';

class TramAnnouncementAudios extends StatelessWidget {
  const TramAnnouncementAudios({super.key});

  @override
  Widget build(BuildContext context) {
    return FullySearchPage<ApiTramAnnouncementAudio>(
      searchHint: "Search tram audio announcements...",
      filters: [SearchFilter.tramAnnouncementGroup],
      query: (filters) async {
        return await ApiTramAnnouncementAudio.search(
          audioGroup: filters.tramAnnouncementGroup,
          offset: filters.offset,
          search: filters.query == null || filters.query!.isEmpty
              ? null
              : filters.query,
        );
      },
      initFilters: (filters) {
        filters.offset = 0;
      },
      results: (results) => Expanded(
        child: SingleChildScrollView(
          child: TramAudioAnnouncementList(
            announcements: results,
            reload: () {},
          ),
        ),
      ),
      resultsTable: (results) =>
          Expanded(child: TramAudioAnnouncementRow(announcements: results)),
    );
  }
}
