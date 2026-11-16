import 'package:flutter/material.dart';

import 'package:transportia/api/model_bus_photo_details.dart';
import 'package:transportia/api/photo.dart';

import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/util/fully_search_page.dart';

class ModelBusPhotoSearchPage extends StatelessWidget {
  final String? query;

  const ModelBusPhotoSearchPage({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    return FullySearchPage<ApiPhoto>(
      searchHint: "Search",
      filters: [],
      initFilters: (filters) {
        filters.query = query;
      },
      query: (filters) async {
        final listings = await ApiModelBusPhotoDetails.fetchAll(
          search: filters.query == null || filters.query!.isEmpty
              ? null
              : filters.query,
          offset: filters.offset,
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
