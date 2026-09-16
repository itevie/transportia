import 'package:flutter/material.dart';
import 'package:transportia/util_widgets/page_container.dart';

class FilterResult {
  final String fleet;
  final String reg;
  final String livery;
  final String vehicleType;

  const FilterResult({
    required this.fleet,
    required this.reg,
    required this.livery,
    required this.vehicleType,
  });
}

class FilterSearch extends StatefulWidget {
  final void Function(FilterResult result) callback;

  const FilterSearch({super.key, required this.callback});

  @override
  State<FilterSearch> createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  late TextEditingController fleetController;
  late TextEditingController regController;
  late TextEditingController liveryController;
  late TextEditingController vehicleTypeController;

  @override
  void initState() {
    super.initState();

    fleetController = TextEditingController();
    regController = TextEditingController();
    liveryController = TextEditingController();
    vehicleTypeController = TextEditingController();
  }

  void returnResult() {
    FilterResult result = FilterResult(
      fleet: fleetController.text,
      reg: regController.text,
      livery: liveryController.text,
      vehicleType: vehicleTypeController.text,
    );

    Navigator.of(context).pop();
    widget.callback(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Advanced Filters...")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          returnResult();
        },
        child: const Icon(Icons.search),
      ),
      body: PageContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: fleetController,
                decoration: InputDecoration(hint: Text("Fleet Number")),
              ),
              TextField(
                controller: regController,
                decoration: InputDecoration(hint: Text("Registration")),
              ),
              TextField(
                controller: liveryController,
                decoration: InputDecoration(hint: Text("Livery")),
              ),
              TextField(
                controller: vehicleTypeController,
                decoration: InputDecoration(hint: Text("Vehicle Type")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
