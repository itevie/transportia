import 'package:dawn_ui_flutter/prompts/confirm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/bus_photo_details.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/prompts/favourites_group_search.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/widgets/util/drop_down.dart';

enum CmContext {
  // Auto added based on obj type
  objBus,
  objTram,
  objTramType,
  objModelBus,
  objService,
  objPhoto,

  /// Wether or not to show search functions like photos / vehicles
  extSearch,

  /// Show only if the user is logged in (auto-added)
  condLoggedIn,

  // Show the View Photo item
  hasPhoto,

  // Show the favourites items (auto added)
  hasFavourite,
}

typedef CmItem = ({
  List<CmContext> contexts,
  List<CmContext>? not,
  Future<List<TDropDownItem>> Function(
    BuildContext context,
    dynamic obj,
    VoidCallback? reload,
  )
  items,
});

List<CmItem> getCmItems() {
  return [
    // Buses
    (
      contexts: [CmContext.objBus],
      not: null,
      items: (context, o, r) async {
        final bus = o as ApiBtVehicle;
        return [
          TDropDownItem(
            icon: Icons.open_in_new,
            label: 'Vehicle Profile',
            callback: () {
              context.go("/vehicle/${bus.id}");
            },
          ),
        ];
      },
    ),
    (
      contexts: [CmContext.objBus, CmContext.condLoggedIn],
      not: null,
      items: (context, o, r) async {
        final bus = o as ApiBtVehicle;
        return [
          TDropDownItem(
            icon: Icons.edit,
            label: 'Edit Vehicle',
            callback: () {
              context.go("/vehicle/${bus.id}/edit");
            },
          ),
        ];
      },
    ),

    // Trams
    (
      contexts: [CmContext.objTram],
      not: null,
      items: (context, o, r) async {
        final bus = o as ApiTram;
        return [
          TDropDownItem(
            icon: Icons.open_in_new,
            label: 'Tram Profile',
            callback: () {
              context.go("/tram/${bus.id}");
            },
          ),
        ];
      },
    ),
    (
      contexts: [CmContext.objTram, CmContext.condLoggedIn],
      not: null,
      items: (context, o, r) async {
        final tram = o as ApiTram;
        return [
          TDropDownItem(
            icon: Icons.edit,
            label: "Edit Tram",
            callback: () {
              context.go("/trams/${tram.id}/edit");
            },
          ),
          TDropDownItem(
            icon: Icons.delete,
            label: "Delete Tram",
            callback: () async {
              final confirm = await showConfirmPrompt(
                context,
                Text("Delete ${tram.fleet}?"),
                Text("Are you sure you want to delete this tram?"),
              );

              if (!confirm) return;

              await ApiTram.delete(tram.id);
              if (r != null) r();
            },
            isDanger: true,
          ),
        ];
      },
    ),

    // Tram Type
    (
      contexts: [CmContext.objTramType, CmContext.condLoggedIn],
      not: null,
      items: (context, o, r) async {
        final tram = o as ApiTramType;
        return [
          TDropDownItem(
            icon: Icons.edit,
            label: "Edit Tram Type",
            callback: () {},
          ),
          TDropDownItem(
            icon: Icons.delete,
            label: "Delete Tram Type",
            callback: () {},
            isDanger: true,
          ),
        ];
      },
    ),

    // Service
    (
      contexts: [CmContext.objService, CmContext.condLoggedIn],
      not: null,
      items: (context, o, r) async {
        return [
          TDropDownItem(label: "Add to service checklist", callback: () {}),
        ];
      },
    ),

    // Model Bus
    (
      contexts: [CmContext.objModelBus, CmContext.condLoggedIn],
      not: null,
      items: (context, o, r) async {
        final modelBus = o as ApiModelBus;
        return [
          TDropDownItem(
            icon: Icons.edit,
            label: "Edit Model Bus",
            callback: () {
              context.go("/model-bus/${modelBus.id}/edit");
            },
          ),
          TDropDownItem(
            icon: Icons.delete,
            label: "Delete Model Bus",
            callback: () async {
              final confirm = await showConfirmPrompt(
                context,
                Text("Delete ${modelBus.productCode}?"),
                Text("Are you sure you want to delete this model bus?"),
              );

              if (!confirm) return;

              await ApiModelBus.delete(modelBus.id);
              if (r != null) r();
            },
            isDanger: true,
          ),
          TDropDownItem(
            icon: Icons.add_box_outlined,
            label: "Add to ownerships",
            callback: () {},
          ),
        ];
      },
    ),

    // Favourites
    (
      contexts: [CmContext.hasFavourite],
      not: null,
      items: (context, o, r) async {
        (FavouriteType, int, String)? option = switch (o) {
          ApiBtVehicle o => (FavouriteType.vehicle, o.id, "Vehicle"),
          ApiTram o => (FavouriteType.tram, o.id, "Tram"),
          _ => null,
        };

        if (option == null) return [];

        final favourite = await ApiFavourite.get(option.$1, option.$2);

        return [
          if (favourite == null)
            TDropDownItem(
              icon: Icons.favorite,
              label: "Favourite ${option.$3}",
              callback: () async {
                await ApiFavourite.create(option.$1, option.$2.toString());
              },
            ),
          if (favourite != null)
            TDropDownItem(
              icon: Icons.favorite_outline,
              label: "Unfavourite ${option.$3}",
              callback: () async {
                await ApiFavourite.delete(option.$1, option.$2.toString());
              },
            ),
          if (favourite?.group != null)
            TDropDownItem(
              icon: Icons.remove_circle_outline,
              label: "Remove ${option.$3} Favourite Group",
              callback: () async {
                await favourite?.setGroup(null);
              },
            ),
          if (favourite != null)
            TDropDownItem(
              icon: Icons.create_new_folder_outlined,
              label:
                  "${favourite.group == null ? "Set" : "Change"} ${option.$3} Favourite Group",
              callback: () async {
                final group = await showFavouritesGroupSearch(
                  context: context,
                  t: FavouriteType.vehicle,
                );

                if (group == null) return;

                await favourite.setGroup(group.id);
              },
            ),
        ];
      },
    ),

    // Extra photo
    (
      contexts: [CmContext.hasPhoto],
      not: [CmContext.objPhoto],
      items: (context, o, r) async {
        ApiPhoto? photo;

        photo = switch (o) {
          ApiBtVehicle v => v.photo,
          ApiTram t => t.photo,
          ApiModelBus m => m.photo,
          _ => null,
        };

        if (photo == null) return [];

        return [
          TDropDownItem(
            icon: Icons.open_in_new,
            label: 'View Photo',
            callback: () {
              context.go("/photo/${photo!.id}");
            },
          ),
        ];
      },
    ),

    // External Search
    (
      contexts: [CmContext.extSearch],
      not: null,
      items: (context, o, r) async {
        List<(String, String)> parts = switch (o) {
          ApiBusPhotoDetails v => [
            ("Search Photos", "/photos?query=${v.dFleet}"),
            ("Search Vehicles", "/vehicles?query=${v.dFleet}"),
            ("Vehicle Profile", "/vehicle/${v.matchedVehicle?.id}"),
          ],
          ApiBtLivery v => [
            ("Search Photos", "/photos?livery=${v.id}"),
            ("Search Vehicles", "/vehicles?livery=${v.id}"),
          ],
          ApiBtVehicleType v => [
            ("Search Photos", "/photos?vt=${v.id}"),
            ("Search Vehicles", "/vehicles?vt=${v.id}"),
          ],
          _ => [],
        };

        return parts
            .map(
              (x) => TDropDownItem(
                icon: Icons.open_in_new,
                label: x.$1,
                callback: () {
                  context.go(x.$2);
                },
              ),
            )
            .toList();
      },
    ),
  ];
}

Widget createCm(
  BuildContext context,
  List<CmContext> contexts,
  dynamic obj, {
  Widget? child,
  VoidCallback? reload,
  bool secondaryClick = false,
}) {
  final user = context.read<CurrentUserStore>();
  dynamic actualObj = obj;

  if (obj is ApiPhoto) {
    contexts.add(CmContext.objPhoto);

    if (obj.bus != null && obj.bus?.matchedVehicle != null) {
      actualObj = obj.bus!.matchedVehicle;
      contexts.add(CmContext.hasPhoto);
    } else if (obj.tram != null && obj.tram?.matchedVehicle != null) {
      actualObj = obj.tram!.matchedVehicle;
      contexts.add(CmContext.hasPhoto);
    } else if (obj.modelBus != null && obj.modelBus?.matchedModel != null) {
      actualObj = obj.modelBus!.matchedModel;
      contexts.add(CmContext.hasPhoto);
    }
  }

  final objContext = switch (actualObj) {
    ApiBtVehicle _ => CmContext.objBus,
    ApiTram _ => CmContext.objTram,
    ApiTramType _ => CmContext.objTramType,
    ApiModelBus _ => CmContext.objModelBus,
    _ => null,
  };

  if (objContext != null) {
    contexts.add(objContext);
  }

  if (user.loggedIn) {
    contexts.add(CmContext.condLoggedIn);
  }

  if (actualObj is ApiBtVehicle ||
      actualObj is ApiPhoto ||
      actualObj is ApiTram) {
    contexts.add(CmContext.hasFavourite);
  }

  return TDropDownMenu(
    showOnSecondaryClick: secondaryClick,
    options: [],
    loadOptions: () async {
      List<CmItem> found = [];

      for (var item in getCmItems()) {
        if (item.contexts.every((x) => contexts.contains(x)) &&
            !(item.not ?? []).any((x) => contexts.contains(x))) {
          found.add(item);
        }
      }

      List<TDropDownItem> collected = [];

      for (var item in found) {
        collected.addAll(await item.items(context, actualObj, reload));
      }

      return collected;
    },
    child:
        child ??
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
  );
}
