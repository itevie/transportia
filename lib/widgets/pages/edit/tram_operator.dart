import 'package:dawn_ui_flutter/prompts/prompts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transportia/api/tram_operator.dart';
import 'package:transportia/main.dart';
import 'package:transportia/widgets/inputs/search_field_text.dart';
import 'package:transportia/widgets/object/tram_operator.dart';
import 'package:transportia/widgets/util/edit_object.dart';

class TramOperatorEditPage extends StatefulWidget {
  final ApiTramOperator? operator;

  const TramOperatorEditPage({super.key, this.operator});

  @override
  State<TramOperatorEditPage> createState() => _TramOperatorEditPageState();
}

class _TramOperatorEditPageState extends State<TramOperatorEditPage> {
  ApiTramOperator? tram;

  late TextEditingController operatorName;

  @override
  void initState() {
    super.initState();

    tram = widget.operator;
    operatorName = TextEditingController(text: tram?.name);
  }

  ApiTramOperator make() {
    if (tram == null) {
      return ApiTramOperator(id: 0, name: operatorName.text);
    }
    return ApiTramOperator(id: tram!.id, name: operatorName.text);
  }

  void save() async {
    if (operatorName.text.isEmpty) {
      return showErrorPrompt(
        context,
        "You need to put something in the model name box!",
      );
    }

    if (tram == null) {
      await ApiTramOperator.create(name: operatorName.text);
    } else {
      await tram!.updateOperator(name: operatorName.text);
    }

    if (lastUri != null) context.go(lastUri!);
  }

  @override
  Widget build(BuildContext context) {
    return EditObjectPage(
      onSave: () async {
        save();
      },
      title: widget.operator == null ? "Create Operator" : "Edit Operator",
      options: [
        SizedBox(
          width: 250,
          child: InputTextField(
            label: "Name",
            controller: operatorName,
            onChanged: (value) => {setState(() {})},
          ),
        ),
      ],
      child: TramOperatorView(operator: make()),
    );
  }
}
