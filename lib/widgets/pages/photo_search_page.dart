import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/user.dart';

import 'package:transportia/prompts/livery_search.dart';
import 'package:transportia/prompts/route_search.dart';
import 'package:transportia/prompts/user_search.dart';
import 'package:transportia/prompts/vehicle_search.dart';
import 'package:transportia/prompts/vehicle_type_search.dart';

import 'package:transportia/widgets/lists/bus_photos_list.dart';
import 'package:transportia/widgets/search_field.dart';
import 'package:transportia/widgets/search_field_bool.dart';
import 'package:transportia/widgets/search_page.dart';

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
  List<ApiFilledOutPhotoBus> photos = [];

  ApiBtLivery? livery;
  ApiBtVehicleType? vehicleType;
  ApiBtVehicle? vehicle;
  ApiUser? user;
  ApiTxLine? route;

  bool? vehicleMatched;

  @override
  void initState() {
    super.initState();

    livery = widget.livery;
    vehicleType = widget.vehicleType;
    vehicle = widget.vehicle;
    user = widget.author;
    route = widget.route;

    load(query: widget.query);
  }

  void load({String? query}) async {
    final listings = await ApiFilledOutPhotoBus.fetchAll(
      search: query == null || query.isEmpty ? null : query,
      bdLiveryId: livery?.id,
      bdVehicleTypeId: vehicleType?.id,
      authorId: user?.id,
      bdVehicleId: vehicle?.id,
      bdHasMatchedVehicle: vehicleMatched,
      bdRoute: route?.txId.toString(),
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
      onSearch: (value) => load(query: value),
      filters: [
        SearchSelectionField<ApiBtLivery>(
          label: 'Livery',
          value: livery,
          onSearch: showLiverySearchPrompt,
          displayValue: (value) => value.name,
          onChanged: (value) {
            setState(() {
              livery = value;
            });
            addPostLoad();
          },
        ),
        SearchSelectionField<ApiBtVehicleType>(
          label: 'Vehicle Type',
          value: vehicleType,
          onSearch: showVehicleTypeSearchPrompt,
          displayValue: (value) => value.name,
          onChanged: (value) {
            setState(() {
              vehicleType = value;
            });
            addPostLoad();
          },
        ),
        SearchSelectionField<ApiBtVehicle>(
          label: 'Vehicle',
          value: vehicle,
          onSearch: showvehicleSearchPrompt,
          displayValue: (value) => '${value.reg} (${value.fleet})',
          onChanged: (value) {
            setState(() {
              vehicle = value;
            });
            addPostLoad();
          },
        ),
        SearchSelectionField<ApiTxLine>(
          label: 'Route',
          value: route,
          onSearch: showLinePrompt,
          displayValue: (value) => '${value.name} ${value.outboundDescription}',
          onChanged: (value) {
            setState(() {
              route = value;
            });
            addPostLoad();
          },
        ),
        SearchSelectionField<ApiUser>(
          label: 'Author',
          value: user,
          onSearch: showUserSearchPrompt,
          displayValue: (value) => value.username,
          onChanged: (value) {
            setState(() {
              user = value;
            });
            addPostLoad();
          },
        ),
        SearchCheckboxSelector(
          label: 'Vehicle matched?',
          value: vehicleMatched,
          tristate: true,
          onChanged: (value) {
            setState(() {
              vehicleMatched = value;
            });
            addPostLoad();
          },
        ),
      ],
      onClear: () {
        setState(() {
          livery = null;
          vehicleType = null;
          vehicle = null;
          user = null;
          route = null;
          vehicleMatched = null;
        });
        addPostLoad();
      },
      results: Expanded(
        child: SingleChildScrollView(child: BusPhotoList(photos: photos)),
      ),
    );
  }
}
