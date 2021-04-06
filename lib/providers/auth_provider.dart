import 'package:flutter/widgets.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:crypto/crypto.dart';

enum UpdateType {
  KickUser,
  JoinExistingCode,
  CreateUserCode,
  LeaveGroup,
  EditProfile,
  EditPassword,
}

class AuthClass with ChangeNotifier {
  String _userId;
  String _userEmail;
  String _userPassword;
  String _userName;
  String _userCode;
  bool _isAdmin;

  AuthClass(
      {String userId,
      String userEmail,
      String userPassword,
      String userName,
      String userCode,
      bool isAdmin})
      : _userId = userId,
        _userEmail = userEmail,
        _userPassword = userPassword,
        _userName = userName,
        _userCode = userCode,
        _isAdmin = isAdmin;

  String get getUserId => _userId;
  String get getUserEmail => _userEmail;
  String get getUserCode => _userCode;
  String get getUserName => _userName;
  String get getUserPassword => _userPassword;
  bool get getIsAdmin => _isAdmin;

  factory AuthClass.fromJson(Map<String, dynamic> json) {
    return AuthClass(
      userId: json['id'],
      userEmail: json['email'],
      userName: json['name'],
      userPassword: json['password'],
      userCode: json['userCode'],
      isAdmin: json['isAdmin'],
    );
  }

  Future<String> authenticate(String email, String password) async {
    String credential = hash(password);
    final url =
        'https://5v4wl41qb6.execute-api.ap-southeast-1.amazonaws.com/test/user/login/$email/$credential';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      final user = AuthClass.fromJson(jsonDecode(response.body));
      setUser(user);
      notifyListeners();
      return 'Login Successful';
    } else if (response.statusCode == 404) {
      print(response.body);
      return jsonDecode(response.body)['error'];
    }
    return '';
  }

  Future<String> signup(
      String email, String name, String password, String code) async {
    const url =
        'https://5v4wl41qb6.execute-api.ap-southeast-1.amazonaws.com/test/user/register';

    String credential = hash(password);

    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'name': name,
          'password': credential,
          'userCode': code,
        },
      ),
    );
    var callback = jsonDecode(response.body);
    switch (response.statusCode) {
      case 201:
        return 'Register successfully';
        break;

      case 404:
        return callback['error'];
        break;

      case 409:
        return callback['error'];
        break;

      default:
        return 'something went wrong';
        break;
    }
  }

  Future<String> update(AuthClass user, UpdateType type) async {
    var url =
        'https://5v4wl41qb6.execute-api.ap-southeast-1.amazonaws.com/test/user/${user._userId}';
    if (type == UpdateType.CreateUserCode)
      url =
          'https://5v4wl41qb6.execute-api.ap-southeast-1.amazonaws.com/test/user/code/${user._userId}';

    String credential = user._userPassword;
    if (type == UpdateType.EditPassword) credential = hash(user._userPassword);

    final response = await http.put(
      url,
      body: json.encode(
        {
          'id': user._userId,
          'email': user._userEmail,
          'name': user._userName,
          'password': credential,
          'userCode': user._userCode,
          'isAdmin': user._isAdmin
        },
      ),
    );
    var callback = jsonDecode(response.body);
    String callbackValue = '';
    print(response.body);
    switch (response.statusCode) {
      case 200:
        final updatedUser = AuthClass.fromJson(callback);
        switch (type) {
          case UpdateType.CreateUserCode:
            setUser(updatedUser);
            callbackValue = 'New code created successfully';
            print('create user code');
            break;
          case UpdateType.JoinExistingCode:
            setUser(updatedUser);
            callbackValue = 'Successfully joined group';
            print('join existing code');
            break;
          case UpdateType.KickUser:
            callbackValue = 'User removed';
            print('kick user');
            break;
          case UpdateType.LeaveGroup:
            setUser(updatedUser);
            callbackValue = 'You left the group';
            print('leave group');
            break;
          case UpdateType.EditProfile:
            setUser(updatedUser);
            callbackValue = 'Update Successful';
            print('edited profile');
            break;
          case UpdateType.EditPassword:
            setUser(updatedUser);
            callbackValue = 'Update Successful';
            print('edited profile');
            break;
        }
        return callbackValue;
        break;
      case 404:
        return callback['error'];
        break;
    }
    return '';
  }

  void logout() {
    _userId = null;
    _userEmail = null;
    _userName = null;
    _userPassword = null;
    _userCode = null;
    notifyListeners();
  }

  void setUser(AuthClass user) {
    _userId = user._userId;
    _userEmail = user._userEmail;
    _userName = user._userName;
    _userPassword = user._userPassword;
    _userCode = user._userCode;
    _isAdmin = user._isAdmin;
    notifyListeners();
  }

  String getRandString(int len) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random.secure();
    var values = String.fromCharCodes(
      Iterable.generate(
        len,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );
    return values;
  }

  String hash(String credential) {
    var bytes = utf8.encode(credential);
    var saltBytes = utf8.encode("pug");

    var hmacSha256 = new Hmac(sha256, saltBytes);
    Digest value = hmacSha256.convert(bytes);
    print(value);
    return value.toString();
  }
}
