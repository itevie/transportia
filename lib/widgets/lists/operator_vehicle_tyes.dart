import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/api/bt_vehicle_type.dart';
import 'package:transportia/widgets/util/cm_base.dart';
import 'package:transportia/widgets/util/sub_text.dart';

class OperatorVehicleTypes extends StatefulWidget {
  final String operatorId;

  const OperatorVehicleTypes({super.key, required this.operatorId});

  @override
  State<OperatorVehicleTypes> createState() => _OperatorVehicleTypesState();
}

class _OperatorVehicleTypesState extends State<OperatorVehicleTypes> {
  List<ApiBtVehicleType> vehicleTypes = [];

  Map<int, List<ApiBtVehicle>> vehiclesByType = {};
  Set<int> loadedTypes = {};
  Set<int> loadingTypes = {};
  Set<int> failedTypes = {};

  bool isLoading = true;
  bool hasFailed = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      isLoading = true;
      hasFailed = false;
    });

    try {
      final loaded = await ApiBtVehicleType.search(
        operatorId: widget.operatorId,
      );

      if (!mounted) return;

      setState(() {
        vehicleTypes = loaded;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        hasFailed = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> loadVehicles(int vehicleTypeId) async {
    if (loadedTypes.contains(vehicleTypeId) ||
        loadingTypes.contains(vehicleTypeId)) {
      return;
    }

    setState(() {
      loadingTypes.add(vehicleTypeId);
      failedTypes.remove(vehicleTypeId);
    });

    try {
      final loaded = await ApiBtVehicle.search(
        operatorId: widget.operatorId,
        vehicleTypeId: vehicleTypeId,
        pageLength: 1000,
      );

      if (!mounted) return;

      setState(() {
        vehiclesByType[vehicleTypeId] = loaded;
        loadedTypes.add(vehicleTypeId);
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        failedTypes.add(vehicleTypeId);
      });
    } finally {
      if (mounted) {
        setState(() {
          loadingTypes.remove(vehicleTypeId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasFailed) {
      return Center(
        child: TextButton(
          onPressed: load,
          child: const Text("Failed to load vehicle types. Retry"),
        ),
      );
    }

    if (vehicleTypes.isEmpty) {
      return const Center(child: Text("No vehicle types found."));
    }

    return ListView(
      children: vehicleTypes.map((type) {
        final id = type.id;

        final vehicles = vehiclesByType[id] ?? [];
        final isLoading = loadingTypes.contains(id);
        final hasLoaded = loadedTypes.contains(id);
        final hasFailed = failedTypes.contains(id);

        final details = [
          type.style,
          type.fuel,
        ].where((value) => value.trim().isNotEmpty).join(" • ");

        return ExpansionTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(type.name),
                    if (details.isNotEmpty) ...[SubText(details)],
                  ],
                ),
              ),
              createCm(context, [
                CmContext.objBusType,
                CmContext.extSearch,
              ], type),
            ],
          ),
          onExpansionChanged: (expanded) {
            if (expanded) loadVehicles(id);
          },
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (hasFailed)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Failed to load vehicles. Collapse and expand to retry.",
                ),
              )
            else if (hasLoaded && vehicles.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text("No vehicles found."),
              )
            else if (hasLoaded)
              ...vehicles.map(
                (vehicle) => _OperatorVehicleTile(
                  vehicle: vehicle,
                  subtitle: vehicle.livery?.name,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}

class _OperatorVehicleTile extends StatelessWidget {
  final ApiBtVehicle vehicle;
  final String? subtitle;

  const _OperatorVehicleTile({required this.vehicle, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.go("/vehicle/${vehicle.id}");
      },
      trailing: const Icon(Icons.chevron_right),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("${vehicle.reg} - ${vehicle.fleet}"),
              if (vehicle.withdrawn) ...[
                const SizedBox(width: 8),
                const Text("Withdrawn", style: TextStyle(color: Colors.red)),
              ],
            ],
          ),
          if (subtitle != null) SubText(subtitle!),
        ],
      ),
    );
  }
}
