import 'dart:convert';

import 'package:agent_app/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _LCSKey {
  static const String currentUser = 'currentUser';
}

class LocalStoreService {
  SharedPreferences? _sharedPrefer;
  Future<void> config() async {
    _sharedPrefer = await SharedPreferences.getInstance();
  }

  set currentUser(User? user) {
    final js = jsonEncode(user);
    if (js.isNotEmpty) {
      _sharedPrefer?.setString(_LCSKey.currentUser, js);
    }
  }

  User? get currentUser {
    final js = _sharedPrefer?.getString(_LCSKey.currentUser) ?? '';
    if (js.isEmpty) return null;

    final jsMap = jsonDecode(js) as Map<String, dynamic>;
    if (jsMap.isEmpty) return null;

    return User.fromJson(jsMap);
  }

  void removeAllCache() {
    _sharedPrefer?.clear();
  }

  void logout() {}
}
