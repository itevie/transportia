import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/api/tram_photo_details.dart';
import 'package:transportia/api/tram_type.dart';

import 'package:transportia/widgets/inputs/obj_inputs.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_widget.dart';
import 'package:transportia/widgets/inputs/search_filtering/main_obj.dart';

import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/util/search_page.dart';

class TramPhotoSearchPage extends StatefulWidget {
  final String? query;

  const TramPhotoSearchPage({super.key, this.query});

  @override
  State<TramPhotoSearchPage> createState() => _TramPhotoSearchPageState();
}

class _TramPhotoSearchPageState extends State<TramPhotoSearchPage> {
  List<ApiPhoto> photos = [];

  final filters = SearchFilters();

  String? query;
  int offset = 0;

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    final listings = await ApiTramPhotoDetails.fetchAll(
      search: query == null || query?.isEmpty == null ? null : query,
      tdVehicleId: filters.tram?.id,
      tdOperatorId: filters.tramOperator?.id,
      tdVehicleTypeId: filters.tramType?.id,
      offset: offset,
      tdHasMatchedVehicle: filters.vehicleMatched,
    );

    if (!mounted) return;

    setState(() {
      photos = listings
          .skip(listings.length > 50 ? listings.length - 50 : 0)
          .toList();
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
      searchHint: 'Search',
      prefilledQuery: widget.query,
      onSearch: (value) {
        setState(() {
          query = value;
        });

        addPostLoad();
      },
      currentOffset: offset,
      offsetCallback: (offset) {
        setState(() {
          this.offset = offset;
        });

        addPostLoad();
      },
      filters:
          SearchFilterBuilder(
            context: context,
            filters: filters,
            onChanged: () {
              setState(() {
                filters.offset = 0;
              });

              load();
            },
          ).build([
            SearchFilter.tram,
            SearchFilter.tramType,
            SearchFilter.tramOperator,
            SearchFilter.vehicleMatched,
          ]),
      // [
      //   tramInputField(context, tram, (value) {
      //     setState(() {
      //       tram = value;
      //       offset = 0;
      //     });

      //     addPostLoad();
      //   }),

      //   tramTypeInputField(context, vehicleType, (value) {
      //     setState(() {
      //       vehicleType = value;
      //       offset = 0;
      //     });

      //     addPostLoad();
      //   }),

      //   tramOperatorInputField(context, operator, (value) {
      //     setState(() {
      //       operator = value;
      //       offset = 0;
      //     });

      //     addPostLoad();
      //   }),

      //   matchedVehicleInputField(context, vehicleMatched, (value) {
      //     setState(() {
      //       vehicleMatched = value;
      //       offset = 0;
      //     });

      //     addPostLoad();
      //   }),
      // ],
      onClear: () {
        setState(() {
          filters.clear();
        });
        addPostLoad();
      },
      results: () => Expanded(
        child: SingleChildScrollView(child: PhotoList(photos: photos)),
      ),
    );
  }
}
