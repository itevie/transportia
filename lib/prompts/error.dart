import 'package:dawn_ui_flutter/prompts/message.dart';
import 'package:flutter/widgets.dart';

Future<void> showErrorPrompt(BuildContext context, dynamic error) {
  return showMessagePrompt(
    context,
    const Text("Error"),
    Text(error.toString()),
  );
}
