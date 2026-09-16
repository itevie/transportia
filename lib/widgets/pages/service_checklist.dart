import 'package:flutter/material.dart';
import 'package:transportia/widgets/service_number.dart';

class ServiceChecklist extends StatefulWidget {
  const ServiceChecklist({super.key});

  @override
  State<ServiceChecklist> createState() => _ServiceChecklistState();
}

class _ServiceChecklistState extends State<ServiceChecklist> {
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
                  child: SearchBar(hintText: "Search in this checklist..."),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Row(
                    children: [
                      ServiceNumber(lineName: "201", operator: "BNML"),
                      SizedBox(width: 8),
                      Text("Manchester Piccadilly - Hattersley"),
                      Spacer(),
                      Checkbox(value: true, onChanged: (v) {}),
                    ],
                  ),
                ),
                Card(
                  child: Row(
                    children: [
                      ServiceNumber(lineName: "202", operator: "BNML"),
                      SizedBox(width: 8),
                      Text("Manchester Piccadilly - Gee Cross"),
                      Spacer(),
                      Checkbox(value: false, onChanged: (v) {}),
                    ],
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
