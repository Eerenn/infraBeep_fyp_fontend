import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:ee_fyp/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {
  List<AuthClass> _users = [];

  List<AuthClass> get users {
    return [..._users];
  }

  void getUsers(String userCode, String username) async {
    final url =
        'https://5v4wl41qb6.execute-api.ap-southeast-1.amazonaws.com/test/users/$userCode';

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List<AuthClass> myModels;
      myModels = (json as List).map((i) => AuthClass.fromJson(i)).toList();
      _users.clear();
      for (int i = 0; i < myModels.length; i++) {
        if (myModels[i].getUserName != username) _users.add(myModels[i]);
      }
      notifyListeners();
    }
  }

  void removeUser(AuthClass user) {
    _users.remove(user);
    notifyListeners();
  }
}
