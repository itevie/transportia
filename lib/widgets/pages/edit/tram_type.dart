import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/tram_type.dart';
import 'package:transportia/main.dart';
import 'package:transportia/widgets/inputs/search_field_text.dart';
import 'package:transportia/widgets/object/tram_type.dart';
import 'package:transportia/widgets/util/edit_object.dart';

class TramTypeEditPage extends StatefulWidget {
  final ApiTramType? tram;

  const TramTypeEditPage({super.key, this.tram});

  @override
  State<TramTypeEditPage> createState() => _TramTypeEditPageState();
}

class _TramTypeEditPageState extends State<TramTypeEditPage> {
  ApiTramType? tram;

  late TextEditingController tramType;

  @override
  void initState() {
    super.initState();

    tram = widget.tram;
    tramType = TextEditingController(text: tram?.name);
  }

  ApiTramType make() {
    if (tram == null) {
      return ApiTramType(id: 0, name: tramType.text);
    }
    return ApiTramType(id: tram!.id, name: tramType.text);
  }

  void save() async {
    if (tramType.text.isEmpty) {
      return showErrorPrompt(
        context,
        "You need to put something in the model name box!",
      );
    }

    if (tram == null) {
      await ApiTramType.create(name: tramType.text);
    } else {
      await tram!.updateType(name: tramType.text);
    }

    if (lastUri != null) context.go(lastUri!);
  }

  @override
  Widget build(BuildContext context) {
    return EditObjectPage(
      onSave: () async {
        save();
      },
      title: widget.tram == null ? "Create Tram Type" : "Edit Tram Type",
      options: [
        SizedBox(
          width: 250,
          child: InputTextField(
            label: "Model Name",
            controller: tramType,
            onChanged: (value) => {setState(() {})},
          ),
        ),
      ],
      child: TramTypeView(tramType: make()),
    );
  }
}
