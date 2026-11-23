import 'package:dawn_ui_flutter/prompts/confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/api/bus_photo_details.dart';
import 'package:transportia/api/favourites.dart';
import 'package:transportia/api/model_bus.dart';
import 'package:transportia/api/model_bus_ownership.dart';
import 'package:transportia/api/model_bus_photo_details.dart';
import 'package:transportia/api/photo.dart';
import 'package:transportia/api/checklist.dart';
import 'package:transportia/api/checklist_item.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_announcement_audios.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/api/tram_photo_details.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/api/tx_line.dart';
import 'package:transportia/api/tx_operator.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/widgets/prompts/favourites_group_search.dart';
import 'package:transportia/widgets/prompts/route_checklist_prompt.dart';
import 'package:transportia/widgets/prompts/route_checklist_selector.dart';
import 'package:transportia/stores/current_user_store.dart';
import 'package:transportia/util/checklist_manager.dart';
import 'package:transportia/widgets/util/drop_down.dart';
import 'package:transportia/widgets/util/toasts.dart';

enum CmContext {
  // Auto added based on obj type
  objBus,
  objBusType,
  objTram,
  objTramType,
  objModelBus,
  objService,
  objPhoto,
  objOperator,
  objLivery,

  /// Auth
  condTrustedUser,

  /// Wether or not to show search functions like photos / vehicles
  extSearch,

  /// Show only if the user is logged in (auto-added)
  condLoggedIn,

  condDebugMode,

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
      contexts: [
        CmContext.objBus,
        CmContext.condLoggedIn,
        CmContext.condTrustedUser,
      ],
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

    // Bus Type
    (
      contexts: [CmContext.objBusType],
      not: null,
      items: (context, o, r) async {
        final type = o as ApiBtVehicleType;
        return [
          TDropDownItem(
            icon: Icons.open_in_new,
            label: 'Vehicle Type Profile',
            callback: () {
              context.go("/vehicle-type/${type.id}");
            },
          ),
        ];
      },
    ),

    // Livery
    (
      contexts: [CmContext.objLivery],
      not: null,
      items: (context, o, r) async {
        final type = o as ApiBtLivery;
        return [
          TDropDownItem(
            icon: Icons.open_in_new,
            label: 'Livery Profile',
            callback: () {
              context.go("/livery/${type.id}");
            },
          ),
        ];
      },
    ),

    // Operator
    (
      contexts: [CmContext.objOperator],
      not: null,
      items: (context, o, r) async {
        final type = o as ApiTxOperator;
        return [
          TDropDownItem(
            icon: Icons.open_in_new,
            label: 'Operator Profile',
            callback: () {
              context.go("/operator/${type.id}");
            },
          ),
        ];
      },
    ),

    // Operator
    (
      contexts: [CmContext.objOperator, CmContext.condLoggedIn],
      not: null,
      items: (context, o, r) async {
        final type = o as ApiTxOperator;
        return [
          TDropDownItem(
            icon: Icons.checklist,
            label: 'Add to checklist',
            callback: () async {
              final checklist = await showRouteChecklistSelectorPrompt(
                context: context,
              );

              if (checklist == null) return;

              if (checklist.checklistType == ChecklistType.service) {
                await checklistAddServiceOperator(
                  // ignore: use_build_context_synchronously
                  context,
                  checklist,
                  foperator: type,
                );
              } else if (checklist.checklistType == ChecklistType.vehicle) {
                await checklistAddVehicleOperator(
                  // ignore: use_build_context_synchronously
                  context,
                  checklist,
                  foperator: type,
                );
              }
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
      contexts: [
        CmContext.objTram,
        CmContext.condLoggedIn,
        CmContext.condTrustedUser,
      ],
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
              // ignore: use_build_context_synchronously
              showSuccessToast(context, "Deleted tram ${tram.displayName}");
              if (r != null) r();
            },
            isDanger: true,
          ),
        ];
      },
    ),

    // Tram Type
    (
      contexts: [
        CmContext.objTramType,
        CmContext.condLoggedIn,
        CmContext.condTrustedUser,
      ],
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
        final service = o as ApiTxLine;
        return [
          TDropDownItem(
            icon: Icons.checklist,
            label: "Add to service checklist",
            callback: () async {
              final checklist = await showRouteChecklistSelectorPrompt(
                context: context,
              );

              if (checklist == null) return;

              await checklist.addObj(service.lineId);

              showSuccessToast(
                // ignore: use_build_context_synchronously
                context,
                "Added ${service.name} to checklist ${checklist.title}",
              );
            },
          ),
        ];
      },
    ),

    // Model Bus
    (
      contexts: [
        CmContext.objModelBus,
        CmContext.condLoggedIn,
        CmContext.condTrustedUser,
      ],
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
              showSuccessToast(
                // ignore: use_build_context_synchronously
                context,
                "Deleted model bus ${modelBus.displayName}",
              );
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
      contexts: [CmContext.hasFavourite, CmContext.condLoggedIn],
      not: null,
      items: (context, o, r) async {
        (FavouriteType, int, String)? option = switch (o) {
          ApiBtVehicle o => (FavouriteType.vehicle, o.id, "Vehicle"),
          ApiTram o => (FavouriteType.tram, o.id, "Tram"),
          _ => null,
        };

        if (option == null) return [];

        final user = context.read<CurrentUserStore>().user;

        final favourite = await ApiFavourite.get(
          user!.id,
          option.$1,
          option.$2,
        );

        return [
          if (favourite == null)
            TDropDownItem(
              icon: Icons.favorite,
              label: "Favourite ${option.$3}",
              callback: () async {
                await ApiFavourite.create(
                  user.id,
                  option.$1,
                  option.$2.toString(),
                );
                // ignore: use_build_context_synchronously
                showSuccessToast(context, "Added ${option.$3} to favourites!");
              },
            ),
          if (favourite != null)
            TDropDownItem(
              icon: Icons.favorite_outline,
              label: "Unfavourite ${option.$3}",
              callback: () async {
                await ApiFavourite.delete(
                  user.id,
                  option.$1,
                  option.$2.toString(),
                );

                showSuccessToast(
                  // ignore: use_build_context_synchronously
                  context,
                  "Removed ${option.$3} from favourites!",
                );
              },
            ),
          if (favourite?.group != null)
            TDropDownItem(
              icon: Icons.remove_circle_outline,
              label: "Remove ${option.$3} Favourite Group",
              callback: () async {
                await favourite?.setGroup(user.id, null);

                showSuccessToast(
                  // ignore: use_build_context_synchronously
                  context,
                  "Removed ${option.$3} from favourite group!",
                );
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

                await favourite.setGroup(user.id, group.id);

                showSuccessToast(
                  // ignore: use_build_context_synchronously
                  context,
                  "Added ${option.$3} to the ${group.name} favourite group!",
                );
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

    // Debug Mode
    (
      contexts: [CmContext.condDebugMode],
      not: null,
      items: (context, o, r) async {
        final id = switch (o) {
          ApiBtVehicle v => v.id,
          ApiBtLivery v => v.id,
          ApiBtVehicleType v => v.id,
          ApiTram v => v.id,
          ApiTramType v => v.id,
          ApiTramOperator v => v.id,
          ApiTramAnnouncementAudio v => v.id,
          ApiPhoto v => v.id,
          ApiBusPhotoDetails v => v.id,
          ApiTramPhotoDetails v => v.id,
          ApiModelBusPhotoDetails v => v.id,
          ApiModelBus v => v.id,
          ApiModelBusOwnership v => v.id,
          _ => null,
        };

        if (id == null) return [];

        return [
          TDropDownItem(
            label: "Copy ID",
            icon: Icons.copy,
            callback: () {
              Clipboard.setData(ClipboardData(text: id.toString()));
              showSuccessToast(context, "Copied ID to clipboard!");
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
            ("Search Photos", "/photos?livery_id=${v.id}"),
            ("Search Vehicles", "/vehicles?livery_id=${v.id}"),
          ],
          ApiBtVehicleType v => [
            ("Search Photos", "/photos?vehicle_type_id=${v.id}"),
            ("Search Vehicles", "/vehicles?vehicle_type_id=${v.id}"),
          ],
          ApiTxOperator v => [
            ("Search Photos", "/photos?operator_id=${v.id}"),
            ("Search Vehicles", "/vehicles?operator_id=${v.id}"),
          ],
          ApiTxLine v => [
            ("Search Photos", "/photos?route_id=${v.txId}"),
            ("Search Vehicles", "/vehicles?route_id=${v.txId}"),
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
  final prefs = Preferences();
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
    ApiBtVehicleType _ => CmContext.objBusType,
    ApiTxOperator _ => CmContext.objOperator,
    ApiTxLine _ => CmContext.objService,
    ApiBtLivery _ => CmContext.objLivery,
    _ => null,
  };

  if (objContext != null) {
    contexts.add(objContext);
  }

  if (user.loggedIn) {
    contexts.add(CmContext.condLoggedIn);
  }

  if (user.user?.trustedUser == true) {
    contexts.add(CmContext.condTrustedUser);
  }

  if (prefs.getBool("developer_mode")) {
    contexts.add(CmContext.condDebugMode);
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
