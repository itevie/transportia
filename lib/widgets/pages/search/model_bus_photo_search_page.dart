import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:transportia/api/model_bus_photo_details.dart';

import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tram_photo_details.dart';

import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/util/search_page.dart';

class ModelBusPhotoSearchPage extends StatefulWidget {
  final String? query;

  const ModelBusPhotoSearchPage({super.key, this.query});

  @override
  State<ModelBusPhotoSearchPage> createState() =>
      _ModelBusPhotoSearchPageState();
}

class _ModelBusPhotoSearchPageState extends State<ModelBusPhotoSearchPage> {
  List<ApiPhoto> photos = [];

  String? query;

  int offset = 0;

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    final listings = await ApiModelBusPhotoDetails.fetchAll(
      search: query == null || query?.isEmpty == null ? null : query,
      offset: offset,
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
      filters: [],
      onClear: () {
        setState(() {
          offset = 0;
        });
        addPostLoad();
      },
      results: () => Expanded(
        child: SingleChildScrollView(child: PhotoList(photos: photos)),
      ),
    );
  }
}
