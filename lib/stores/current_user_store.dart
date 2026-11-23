import 'package:flutter/material.dart';
import 'package:transportia/api/user.dart';
import 'package:transportia/util/prefs.dart';

class CurrentUserStore extends ChangeNotifier {
  ApiUser? _user;

  ApiUser? get user => _user;

  void set(ApiUser user) {
    _user = user;
    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await Preferences().remove("token");
    notifyListeners();
  }

  bool get loggedIn => _user != null;
}

final currentUserStore = CurrentUserStore();
