import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/bus_photo_details.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/user.dart';

import 'package:transportia/widgets/inputs/search_filtering/filter_type.dart';
import 'package:transportia/widgets/inputs/search_filtering/filter_widget.dart';
import 'package:transportia/widgets/inputs/search_filtering/main_obj.dart';

import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/util/search_page.dart';

class PhotoSearchPage extends StatefulWidget {
  final String? query;

  final ApiBtLivery? livery;
  final ApiBtVehicleType? vehicleType;
  final ApiBtVehicle? vehicle;
  final ApiUser? author;
  final ApiTxLine? route;

  const PhotoSearchPage({
    super.key,
    this.query,
    this.livery,
    this.vehicleType,
    this.vehicle,
    this.author,
    this.route,
  });

  @override
  State<PhotoSearchPage> createState() => _PhotoSearchPageState();
}

class _PhotoSearchPageState extends State<PhotoSearchPage> {
  List<ApiPhoto> photos = [];

  final filters = SearchFilters();

  String? query;
  int currentOffset = 0;

  @override
  void initState() {
    super.initState();

    query = widget.query;
    filters.livery = widget.livery;
    filters.vehicleType = widget.vehicleType;
    filters.vehicle = widget.vehicle;
    filters.author = widget.author;
    filters.route = widget.route;

    load();
  }

  void load() async {
    final photos = await ApiBusPhotoDetails.fetchAll(
      search: query == null || query!.isEmpty ? null : query,
      bdLiveryId: filters.livery?.id,
      bdVehicleTypeId: filters.vehicleType?.id,
      authorId: filters.author?.id,
      bdVehicleId: filters.vehicle?.id,
      bdHasMatchedVehicle: filters.vehicleMatched,
      bdRoute: filters.route?.txId.toString(),
      offset: currentOffset,
    );

    if (!mounted) return;

    setState(() {
      this.photos = photos
          .skip(photos.length > 50 ? photos.length - 50 : 0)
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
          filters.offset = 0;
        });

        addPostLoad();
      },

      currentOffset: currentOffset,
      offsetCallback: (offset) {
        setState(() {
          currentOffset = offset;
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
            SearchFilter.livery,
            SearchFilter.vehicleType,
            SearchFilter.vehicle,
            SearchFilter.route,
            SearchFilter.author,
            SearchFilter.vehicleMatched,
          ]),
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
