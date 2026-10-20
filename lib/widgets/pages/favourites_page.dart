import 'package:flutter/material.dart';
import 'package:transportia/api/bt_vehicle.dart';

import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/util_widgets/tab_bar.dart';
import 'package:transportia/widgets/lists/bus_photos_list.dart';
import 'package:transportia/widgets/lists/vehicle_list.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage>
    with SingleTickerProviderStateMixin {
  List<ApiBtVehicle> vehicles = [];
  List<ApiFavourite> services = [];
  List<ApiFavourite> operators = [];
  List<ApiFilledOutPhotoBus> busPhotos = [];

  bool loadingVehicles = false;
  bool loadingServices = false;
  bool loadingOperators = false;
  bool loadingPhotos = false;

  bool loadedVehicles = false;
  bool loadedServices = false;
  bool loadedOperators = false;
  bool loadedPhotos = false;

  @override
  void initState() {
    super.initState();

    _loadPhotos();
  }

  Future<void> _loadVehicles() async {
    if (loadedVehicles || loadingVehicles) {
      return;
    }

    setState(() {
      loadingVehicles = true;
    });

    try {
      final loaded = await ApiFavourite.getByType(
        FavouriteType.vehicle,
        fillOut: true,
      );

      if (!mounted) return;

      setState(() {
        vehicles = loaded.map((f) => ApiBtVehicle.fromJson(f.object)).toList();
        loadedVehicles = true;
        loadingVehicles = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingVehicles = false;
      });

      print(e);
    }
  }

  Future<void> _loadServices() async {
    if (loadedServices || loadingServices) {
      return;
    }

    setState(() {
      loadingServices = true;
    });

    try {
      final loaded = await ApiFavourite.getByType(
        FavouriteType.service,
        fillOut: true,
      );

      if (!mounted) return;

      setState(() {
        services = loaded;
        loadedServices = true;
        loadingServices = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingServices = false;
      });

      print(e);
    }
  }

  Future<void> _loadOperators() async {
    if (loadedOperators || loadingOperators) {
      return;
    }

    setState(() {
      loadingOperators = true;
    });

    try {
      final loaded = await ApiFavourite.getByType(
        FavouriteType.operator_,
        fillOut: true,
      );

      if (!mounted) return;

      setState(() {
        operators = loaded;
        loadedOperators = true;
        loadingOperators = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingOperators = false;
      });

      print(e);
    }
  }

  Future<void> _loadPhotos() async {
    if (loadedPhotos || loadingPhotos) {
      return;
    }

    setState(() {
      loadingPhotos = true;
    });

    try {
      final loaded = await ApiFavourite.getByType(
        FavouriteType.photo,
        fillOut: true,
      );

      if (!mounted) return;

      setState(() {
        busPhotos = loaded
            .map((favourite) => ApiFilledOutPhotoBus.fromJson(favourite.object))
            .toList();

        loadedPhotos = true;
        loadingPhotos = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingPhotos = false;
      });

      print(e);
    }
  }

  Widget _buildVehicles() {
    if (loadingVehicles) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(child: VehicleList(vehicles: vehicles));
  }

  Widget _buildServices() {
    if (loadingServices) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox();
    // return ServiceFavouriteList(favourites: services);
  }

  Widget _buildOperators() {
    if (loadingOperators) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox();
    // return OperatorFavouriteList(favourites: operators);
  }

  Widget _buildPhotos() {
    if (loadingPhotos) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(child: BusPhotoList(photos: busPhotos));
  }

  @override
  Widget build(BuildContext context) {
    return AppTabController(
      tabs: [
        AppTab(
          name: 'Photos',
          icon: Icons.photo_outlined,
          onSelected: _loadPhotos,
          child: _buildPhotos(),
        ),
        AppTab(
          name: 'Vehicles',
          icon: Icons.directions_bus_outlined,
          onSelected: _loadVehicles,
          child: _buildVehicles(),
        ),
        AppTab(
          name: 'Services',
          icon: Icons.route_outlined,
          onSelected: _loadServices,
          child: _buildServices(),
        ),
        AppTab(
          name: 'Operators',
          icon: Icons.business_outlined,
          onSelected: _loadOperators,
          child: _buildOperators(),
        ),
      ],
    );
  }
}
