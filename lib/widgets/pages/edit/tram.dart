import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/tram.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/main.dart';
import 'package:transportia/prompts/tram_operator.dart';
import 'package:transportia/prompts/tram_type.dart';
import 'package:transportia/widgets/inputs/search_field.dart';
import 'package:transportia/widgets/inputs/search_field_bool.dart';
import 'package:transportia/widgets/inputs/search_field_text.dart';
import 'package:transportia/widgets/util/edit_object.dart';
import 'package:transportia/widgets/object/tram_card.dart';

class TramEditPage extends StatefulWidget {
  final ApiTram? tram;

  const TramEditPage({super.key, this.tram});

  @override
  State<TramEditPage> createState() => _TramEditPageState();
}

class _TramEditPageState extends State<TramEditPage> {
  ApiTram? tram;

  late TextEditingController fleet;
  late TextEditingController garage;
  late TextEditingController branding;
  late TextEditingController name;
  bool withdrawn = false;
  ApiTramOperator? operator;
  ApiTramType? tramType;

  @override
  void initState() {
    super.initState();

    tram = widget.tram;
    fleet = TextEditingController(text: tram?.fleet);
    garage = TextEditingController(text: tram?.garage);
    branding = TextEditingController(text: tram?.branding);
    name = TextEditingController(text: tram?.name);
    withdrawn = widget.tram?.withdrawn ?? false;
    operator = widget.tram?.operator;
    tramType = widget.tram?.tramType;
  }

  ApiTram make() {
    return (tram ?? ApiTram(id: 0, fleet: '')).copyWith(
      withdrawn: withdrawn,
      fleet: fleet.text,
      garage: garage.text.isEmpty ? null : garage.text,
      name: name.text.isEmpty ? null : name.text,
      branding: branding.text.isEmpty ? null : branding.text,
      operatorId: operator?.id,
      operator: operator,
      tramType: tramType,
      tramTypeId: tramType?.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditObjectPage(
      onSave: () async {
        if (tram == null) {
          await ApiTram.create(
            fleet: fleet.text,
            withdrawn: withdrawn,
            garage: garage.text.isEmpty ? null : garage.text,
            name: name.text.isEmpty ? null : name.text,
            branding: branding.text.isEmpty ? null : branding.text,
            operatorId: operator?.id,
            tramTypeId: tramType?.id,
          );
        } else {
          await tram!.updateTram(
            fleet: fleet.text,
            withdrawn: withdrawn,
            garage: garage.text.isEmpty ? null : garage.text,
            name: name.text.isEmpty ? null : name.text,
            branding: branding.text.isEmpty ? null : branding.text,
            operatorId: operator?.id,
            tramTypeId: tramType?.id,
          );
        }

        if (lastUri != null) context.go(lastUri!);
      },
      title: widget.tram == null ? "Create Tram" : "Edit Tram",
      options: [
        SizedBox(
          width: 250,
          child: InputTextField(
            label: "Fleet",
            controller: fleet,
            onChanged: (value) => {setState(() {})},
          ),
        ),

        SizedBox(
          width: 250,
          child: InputSelectionField<ApiTramType>(
            label: "Type",
            value: tramType,
            onSearch: showTramTypeSearchPrompt,
            displayValue: (v) => v.name,
            onChanged: (v) {
              setState(() {
                tramType = v;
              });
            },
          ),
        ),

        SizedBox(
          width: 250,
          child: InputSelectionField(
            label: "Operator",
            value: operator,
            onSearch: showTramOperatorSearchPrompt,
            displayValue: (v) => v.name,
            onChanged: (v) {
              setState(() {
                operator = v;
              });
            },
          ),
        ),

        SizedBox(
          width: 250,
          child: InputTextField(
            label: "Garage",
            controller: garage,
            onChanged: (value) => {setState(() {})},
          ),
        ),

        SizedBox(
          width: 250,
          child: InputTextField(
            label: "Branding",
            controller: branding,
            onChanged: (value) => {setState(() {})},
          ),
        ),

        SizedBox(
          width: 250,
          child: InputTextField(
            label: "Special Name",
            controller: name,
            onChanged: (value) => {setState(() {})},
          ),
        ),

        InputBoolField(
          label: "Withdrawn?",
          value: withdrawn,
          onChanged: (v) {
            setState(() {
              withdrawn = v ?? false;
            });
          },
        ),
      ],
      child: TramCard(vehicle: make()),
    );
  }
}
