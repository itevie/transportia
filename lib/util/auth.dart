import 'package:transportia/api/user.dart';
import 'package:transportia/stores/current_user_store.dart';

void checkLogin() async {
  try {
    final user = await ApiUser.me();
    currentUserStore.set(user);
  } catch (_) {}
}
