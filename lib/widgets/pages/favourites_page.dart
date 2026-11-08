import 'package:flutter/material.dart';
import 'package:transportia/api/bt_vehicle.dart';

import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/favourites_group.dart';
import 'package:transportia/api/filled_out_bus_photo.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/prompts/input.dart';
import 'package:transportia/widgets/lists/tram_list.dart';
import 'package:transportia/widgets/util/tab_bar.dart';
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
  List<ApiTram> trams = [];
  List<ApiFavourite> services = [];
  List<ApiFavourite> operators = [];
  List<ApiFilledOutPhotoBus> busPhotos = [];

  List<ApiFavouriteGroup> groups = [];

  bool loadingVehicles = false;
  bool loadingServices = false;
  bool loadingOperators = false;
  bool loadingPhotos = false;
  bool loadingTrams = false;

  bool loadedVehicles = false;
  bool loadedServices = false;
  bool loadedOperators = false;
  bool loadedPhotos = false;
  bool loadedTrams = false;

  @override
  void initState() {
    super.initState();

    _loadGroups();
    _loadPhotos();
  }

  Future<void> _loadGroups() async {
    final loaded = await ApiFavouriteGroup.getAll();

    setState(() {
      groups = loaded;
    });
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

  Future<void> _loadTrams() async {
    if (loadedVehicles || loadingVehicles) {
      return;
    }

    setState(() {
      loadingVehicles = true;
    });

    try {
      final loaded = await ApiFavourite.getByType(
        FavouriteType.tram,
        fillOut: true,
      );

      if (!mounted) return;

      setState(() {
        trams = loaded.map((f) => ApiTram.fromJson(f.object)).toList();
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
          child: FavouritesTab(
            type: FavouriteType.photo,
            groups: groups,
            reload: () {
              _loadGroups();
            },
            builder: (favourites) => BusPhotoList(
              photos: favourites
                  .map(
                    (favourite) =>
                        ApiFilledOutPhotoBus.fromJson(favourite.object),
                  )
                  .toList(),
            ),
          ),
        ),
        AppTab(
          name: 'Buses',
          icon: Icons.directions_bus_outlined,
          onSelected: _loadVehicles,
          child: FavouritesTab(
            type: FavouriteType.vehicle,
            groups: groups,
            reload: () {
              _loadGroups();
            },
            builder: (favourites) => VehicleList(
              vehicles: favourites
                  .map((f) => ApiBtVehicle.fromJson(f.object))
                  .toList(),
            ),
          ),
        ),
        AppTab(
          name: 'Trams',
          icon: Icons.tram_outlined,
          onSelected: _loadTrams,
          child: FavouritesTab(
            type: FavouriteType.tram,
            groups: groups,
            reload: () {
              _loadGroups();
            },
            builder: (favourites) => TramList(
              vehicles: favourites
                  .map((f) => ApiTram.fromJson(f.object))
                  .toList(),
            ),
          ),
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

class FavouritesTab extends StatefulWidget {
  final FavouriteType type;
  final List<ApiFavouriteGroup> groups;
  final Widget Function(List<ApiFavourite> favourites) builder;
  final VoidCallback reload;

  const FavouritesTab({
    super.key,
    required this.type,
    required this.groups,
    required this.builder,
    required this.reload,
  });

  @override
  State<FavouritesTab> createState() => _FavouritesTabState();
}

class _FavouritesTabState extends State<FavouritesTab> {
  int? currentGroup;
  List<ApiFavourite> loaded = [];

  Future<void> loadGroup(int? group) async {
    setState(() {
      loaded = [];
    });

    List<ApiFavourite> results;
    if (group == null) {
      results = await ApiFavourite.getByType(widget.type, fillOut: true);
    } else {
      results = await ApiFavourite.getByGroup(group, fillOut: true);
    }

    setState(() {
      loaded = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredGroups = widget.groups
        .where((x) => x.favouriteType == widget.type)
        .toList();

    if (currentGroup != null) {
      final groupName = currentGroup == -1
          ? "All (${loaded.length})"
          : "${widget.groups.firstWhere((x) => x.id == currentGroup).name} (${loaded.length})";

      return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentGroup = null;
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(groupName),
                SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 8),
            widget.builder(loaded),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: filteredGroups.length + 2,
      itemBuilder: (context, index) {
        late final Widget child;
        late final VoidCallback onTap;

        if (index == 0) {
          child = const Text("All", textAlign: TextAlign.center);
          onTap = () {
            loadGroup(null);
            setState(() {
              currentGroup = -1;
            });
          };
        } else if (index == filteredGroups.length + 1) {
          child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(Icons.add), Text("New Group")],
          );
          onTap = () async {
            final name = await showInputPrompt(
              context,
              const Text("Group Name"),
              null,
            );

            if (name == null) return;

            await ApiFavouriteGroup.create(widget.type, name);
            widget.reload();
          };
        } else {
          final group = filteredGroups[index - 1];
          child = Text(group.name, textAlign: TextAlign.center);
          onTap = () {
            loadGroup(group.id);
            setState(() {
              currentGroup = group.id;
            });
          };
        }

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Padding(padding: const EdgeInsets.all(8), child: child),
            ),
          ),
        );
      },
    );
  }
}
