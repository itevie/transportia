import 'package:flutter/material.dart';

import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tram_photo_details.dart';

import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';

import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/util/fully_search_page.dart';

class TramPhotoSearchPage extends StatelessWidget {
  final String? query;

  const TramPhotoSearchPage({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    return FullySearchPage<ApiPhoto>(
      searchHint: "Search",
      filters: [
        SearchFilter.tram,
        SearchFilter.tramType,
        SearchFilter.tramOperator,
        SearchFilter.vehicleMatched,
      ],
      initFilters: (filters) {
        filters.query = query;
      },
      orderByType: OrderByType.photo,
      query: (filters) async {
        final listings = await ApiTramPhotoDetails.fetchAll(
          search: filters.query == null || filters.query!.isEmpty
              ? null
              : filters.query,
          tdVehicleId: filters.tram?.id,
          tdOperatorId: filters.tramOperator?.id,
          tdVehicleTypeId: filters.tramType?.id,
          offset: filters.offset,
          orderBy: filters.orderBy,
          tdHasMatchedVehicle: filters.vehicleMatched,
        );

        return listings
            .skip(listings.length > 50 ? listings.length - 50 : 0)
            .toList();
      },
      results: (results) => Expanded(
        child: SingleChildScrollView(child: PhotoList(photos: results)),
      ),
    );
  }
}
