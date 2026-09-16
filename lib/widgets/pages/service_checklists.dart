import 'package:flutter/material.dart';
import 'package:transportia/main.dart';
import 'package:transportia/widgets/pages/service_checklist.dart';

class ServiceChecklists extends StatefulWidget {
  const ServiceChecklists({super.key});

  @override
  State<ServiceChecklists> createState() => _ServiceChecklistsState();
}

class _ServiceChecklistsState extends State<ServiceChecklists> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: SearchBar(hintText: "Search your checklists..."),
                ),
                const SizedBox(height: 8),

                Card(
                  child: ListTile(
                    onTap: () => setAppPage(ServiceChecklist()),
                    title: const Text("Bee Network"),
                    subtitle: const Text("22/289 routes completed"),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: () => setAppPage(ServiceChecklist()),
                    title: const Text("London"),
                    subtitle: const Text("38/857 routes completed"),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
