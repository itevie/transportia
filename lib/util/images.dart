import 'package:image_picker/image_picker.dart';

final ImagePicker picker = ImagePicker();

Future<List<XFile>> pickImages() async {
  return await picker.pickMultiImage();
}
