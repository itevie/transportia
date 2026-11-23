import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/bt_livery.dart';
import 'package:transportia/api/bt_vehicle.dart';
import 'package:transportia/util/util.dart';
import 'package:transportia/widgets/util/cm_base.dart';
import 'package:transportia/widgets/util/sub_text.dart';

import '../livery/livery.dart';

class OperatorLiveries extends StatefulWidget {
  final String operatorId;

  const OperatorLiveries({super.key, required this.operatorId});

  @override
  State<OperatorLiveries> createState() => _OperatorLiveriesState();
}

class _OperatorLiveriesState extends State<OperatorLiveries> {
  List<ApiBtLivery> liveries = [];

  Map<int, List<ApiBtVehicle>> vehiclesByLivery = {};
  Set<int> loadedLiveries = {};
  Set<int> loadingLiveries = {};
  Set<int> failedLiveries = {};

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
      final loaded = await ApiBtLivery.search(
        operatorId: widget.operatorId,
        pageLength: 1000,
      );

      if (!mounted) return;

      setState(() {
        liveries = loaded;
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

  Future<void> loadVehicles(int liveryId) async {
    if (loadedLiveries.contains(liveryId) ||
        loadingLiveries.contains(liveryId)) {
      return;
    }

    setState(() {
      loadingLiveries.add(liveryId);
      failedLiveries.remove(liveryId);
    });

    try {
      final loaded = await ApiBtVehicle.search(
        operatorId: widget.operatorId,
        liveryId: liveryId,
        pageLength: 1000,
      );

      if (!mounted) return;

      setState(() {
        vehiclesByLivery[liveryId] = loaded;
        loadedLiveries.add(liveryId);
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        failedLiveries.add(liveryId);
      });
    } finally {
      if (mounted) {
        setState(() {
          loadingLiveries.remove(liveryId);
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
          child: const Text("Failed to load liveries. Retry"),
        ),
      );
    }

    if (liveries.isEmpty) {
      return const Center(child: Text("No liveries found."));
    }

    return ListView(
      children: liveries.map((livery) {
        final id = livery.id;

        final vehicles = vehiclesByLivery[id] ?? [];
        final isLoading = loadingLiveries.contains(id);
        final hasLoaded = loadedLiveries.contains(id);
        final hasFailed = failedLiveries.contains(id);

        return ExpansionTile(
          leading: isLinux()
              ? null
              : LiveryView(livery: livery, key: Key(livery.id.toString())),
          title: Row(
            children: [
              Expanded(child: Text(livery.name)),
              createCm(context, [
                CmContext.objLivery,
                CmContext.extSearch,
              ], livery),
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
                (vehicle) => ListTile(
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
                            const Text(
                              "Withdrawn",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ],
                      ),
                      if (vehicle.vehicleType != null)
                        SubText(vehicle.vehicleType!.name),
                    ],
                  ),
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}
