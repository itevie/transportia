import 'package:flutter/material.dart';
import 'package:transportia/api/user.dart';

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

  bool get loggedIn => _user != null;
}

final currentUserStore = CurrentUserStore();
