import 'package:dawn_ui_flutter/prompts/input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/favourites_group.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/user.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/theme.dart';
import 'package:transportia/widgets/inputs/search_dropdown.dart';
import 'package:transportia/widgets/lists/photo_list.dart';
import 'package:transportia/widgets/lists/tram_list.dart';
import 'package:transportia/widgets/lists/vehicle_list.dart';

class FavouritesPageNew extends StatefulWidget {
  final ApiUser? user;
  final bool isNested;

  const FavouritesPageNew({super.key, this.isNested = false, this.user});

  @override
  State<FavouritesPageNew> createState() => _FavouritesPageNewState();
}

class _FavouritesPageNewState extends State<FavouritesPageNew> {
  FavouriteType selected = FavouriteType.vehicle;

  // FavouriteType -> Group ID -> Favourites
  // -1 represents all favourites.
  final Map<FavouriteType, Map<int, List<ApiFavourite>>> loaded = {};

  bool isLoading = false;

  List<ApiFavouriteGroup> groups = [];

  // null = group selection screen
  // -1 = all favourites
  // Any other value = selected group ID
  int? currentGroup;

  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    load(full: true);
  }

  int getUser() {
    if (widget.user != null) return widget.user!.id;
    final user = context.read<CurrentUserStore>().user!.id;

    return user;
  }

  int getCurrentUser() {
    final user = context.read<CurrentUserStore>().user!.id;

    return user;
  }

  Future<void> load({bool full = false}) async {
    final requestId = ++_requestId;

    setState(() {
      isLoading = true;
    });

    try {
      List<ApiFavouriteGroup>? results;

      if (full) {
        results = await ApiFavouriteGroup.getAll(getUser());
      }

      if (!mounted || requestId != _requestId) return;

      setState(() {
        if (results != null) {
          groups = results;
        }

        isLoading = false;
      });
    } catch (e) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        isLoading = false;
      });

      debugPrint('Failed to load favourite groups: $e');
    }
  }

  Future<void> loadGroup(int? group, {bool force = false}) async {
    final favouriteType = selected;
    final groupId = group ?? -1;

    // Use cached results if available.
    if (!force && loaded[favouriteType]?.containsKey(groupId) == true) {
      setState(() {
        currentGroup = groupId;
      });
      return;
    }

    final requestId = ++_requestId;

    setState(() {
      currentGroup = groupId;
      isLoading = true;
    });

    try {
      final List<ApiFavourite> results;

      if (group == null) {
        results = await ApiFavourite.getByType(
          getUser(),
          favouriteType,
          fillOut: true,
        );
      } else {
        results = await ApiFavourite.getByGroup(
          getUser(),
          group,
          fillOut: true,
        );
      }

      if (!mounted || requestId != _requestId) return;

      setState(() {
        loaded.putIfAbsent(favouriteType, () => {})[groupId] = results;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        isLoading = false;
      });

      debugPrint('Failed to load favourites: $e');
    }
  }

  Future<void> changeType(FavouriteType value) async {
    if (value == selected) return;

    ++_requestId;

    setState(() {
      selected = value;
      currentGroup = null;
      isLoading = false;
    });
  }

  Future<void> createGroup() async {
    final name = await showInputPrompt(context, const Text('Group Name'), null);

    if (name == null || name.trim().isEmpty) return;

    try {
      await ApiFavouriteGroup.create(getCurrentUser(), selected, name.trim());

      if (!mounted) return;

      await load(full: true);
    } catch (e) {
      debugPrint('Failed to create favourite group: $e');
    }
  }

  Widget buildFavourites(List<ApiFavourite> favourites) {
    return switch (selected) {
      FavouriteType.photo => PhotoList(
        photos: favourites
            .map((favourite) => ApiPhoto.fromJson(favourite.object))
            .toList(),
      ),
      FavouriteType.vehicle => VehicleList(
        vehicles: favourites
            .map((favourite) => ApiBtVehicle.fromJson(favourite.object))
            .toList(),
      ),
      FavouriteType.tram => TramList(
        vehicles: favourites
            .map((favourite) => ApiTram.fromJson(favourite.object))
            .toList(),
      ),
      _ => Center(child: Text('$selected not implemented yet')),
    };
  }

  Widget buildGroups(List<ApiFavouriteGroup> filteredGroups) {
    final showNewGroup = !widget.isNested;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: responsiveGridDelegate(
        context,
        minCardHeight: 150,
        minCardWidth: 150,
      ),
      itemCount: filteredGroups.length + (showNewGroup ? 2 : 1),
      itemBuilder: (context, index) {
        late final Widget child;
        late final VoidCallback onTap;

        if (index == 0) {
          child = const Text('All', textAlign: TextAlign.center);

          onTap = () => loadGroup(null);
        } else if (showNewGroup && index == filteredGroups.length + 1) {
          child = const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.add), Text('New Group')],
          );

          onTap = createGroup;
        } else {
          final group = filteredGroups[index - 1];

          child = Text(group.name, textAlign: TextAlign.center);

          onTap = () => loadGroup(group.id);
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

  @override
  Widget build(BuildContext context) {
    final filteredGroups = groups
        .where((group) => group.favouriteType == selected)
        .toList();

    final favourites = currentGroup == null
        ? null
        : loaded[selected]?[currentGroup!];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              if (currentGroup != null)
                IconButton(
                  onPressed: () {
                    ++_requestId;

                    setState(() {
                      currentGroup = null;
                      isLoading = false;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              Expanded(
                child: Text(
                  '${widget.user != null ? "${widget.user!.username}'s" : "Your"} ${selected.apiValue} Favourites',
                ),
              ),
              SizedBox(
                width: 250,
                child: InputDropdownField<FavouriteType>(
                  label: 'Type',
                  onChanged: changeType,
                  items: FavouriteType.values,
                  displayName: (type) => type.apiValue,
                  selected: selected,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: currentGroup == null
              ? isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : buildGroups(filteredGroups)
              : isLoading
              ? const Center(child: CircularProgressIndicator())
              : favourites != null
              ? SingleChildScrollView(child: buildFavourites(favourites))
              : const Center(child: Text('No favourites found')),
        ),
      ],
    );
  }
}
