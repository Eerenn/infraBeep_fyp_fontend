import 'package:ee_fyp/providers/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:ee_fyp/widget/app_drawer.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  AuthClass _user;
  bool _updateName = false;
  bool _updatePassword = false;

  Future<void> _saveProfile(UpdateType updateType) async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      _updateProfile = AuthClass(
        userId: _updateProfile.getUserId,
        userName: _updateProfile.getUserName,
        userEmail: _updateProfile.getUserEmail,
        userPassword: _updateProfile.getUserPassword,
        userCode: _updateProfile.getUserCode,
        isAdmin: _updateProfile.getIsAdmin,
      );
      print(_updateProfile.getUserName);
      print(_updateProfile.getUserPassword);
      String callback = await _user.update(_updateProfile, updateType);

      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(callback),
          duration: Duration(
            seconds: 2,
          ),
        ),
      );
      setState(() {
        _updateName = false;
        _updatePassword = false;
      });
    } else {
      print('not validate');
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
              'Unable to update profile, please check your text field again'),
          duration: Duration(
            seconds: 2,
          ),
        ),
      );
    }
  }

  var _updateProfile = AuthClass(
    userId: '',
    userName: '',
    userEmail: '',
    userPassword: '',
    userCode: '',
    isAdmin: null,
  );

  void initProfile(AuthClass user) {
    _updateProfile = AuthClass(
      userId: user.getUserId,
      userName: user.getUserName,
      userEmail: user.getUserEmail,
      userPassword: user.getUserPassword,
      userCode: user.getUserCode,
      isAdmin: user.getIsAdmin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthClass>(context);
    initProfile(user);
    _user = user;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'User profile',
          style: TextStyle(color: white),
        ),
        iconTheme: IconThemeData(color: white),
        actions: [
          _updateName || _updatePassword
              ? IconButton(
                  icon: Icon(
                    Icons.save,
                    color: white,
                  ),
                  onPressed: () {
                    if (_updatePassword)
                      _saveProfile(UpdateType.EditPassword);
                    else
                      _saveProfile(UpdateType.EditProfile);
                  },
                )
              : Container(),
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Icon(
                    Icons.account_circle,
                    color: fontColor,
                    size: 80,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email'),
                    SizedBox(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
                  child: user.getUserEmail != null
                      ? Text(
                          user.getUserEmail,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: fontColor,
                          ),
                        )
                      : Text(''),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: fontColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Username'),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 15,
                        color: fontColor,
                      ),
                      onPressed: () {
                        nameController.text = user.getUserName;
                        setState(() {
                          if (_updateName)
                            _updateName = false;
                          else
                            _updateName = true;
                        });
                      },
                    )
                  ],
                ),
                _updateName
                    ? Container()
                    : user.getUserName != null
                        ? Text(
                            user.getUserName,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: fontColor,
                            ),
                          )
                        : Text(''),
                _updateName
                    ? TextFormField(
                        controller: nameController,
                        onSaved: (value) {
                          if (value.isNotEmpty)
                            _updateProfile = AuthClass(
                              userId: _updateProfile.getUserId,
                              userName: value,
                              userEmail: _updateProfile.getUserEmail,
                              userPassword: _updateProfile.getUserPassword,
                              userCode: _updateProfile.getUserCode,
                              isAdmin: _updateProfile.getIsAdmin,
                            );
                        },
                        validator: (value) {
                          return;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 5.0,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    : Text(''),
                !_updateName
                    ? Container()
                    : SizedBox(
                        height: 10,
                      ),
                Divider(
                  color: fontColor,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Group code'),
                    SizedBox(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
                  child: user.getUserCode != null
                      ? Text(
                          user.getUserCode,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: fontColor,
                          ),
                        )
                      : Text('You haven\'t got a code yet'),
                ),
                Divider(
                  color: fontColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Password'),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 15,
                        color: fontColor,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_updatePassword) {
                            _updatePassword = false;
                            oldPasswordController.text = '';
                            newPasswordController.text = '';
                          } else
                            _updatePassword = true;
                        });
                      },
                    )
                  ],
                ),
                _updatePassword
                    ? TextFormField(
                        obscureText: true,
                        controller: oldPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 5.0,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    : Text(''),
                !_updatePassword
                    ? Container()
                    : SizedBox(
                        height: 5,
                      ),
                _updatePassword
                    ? TextFormField(
                        obscureText: true,
                        onSaved: (value) {
                          if (value.isNotEmpty &&
                              oldPasswordController.text.isNotEmpty)
                            _updateProfile = AuthClass(
                              userId: _updateProfile.getUserId,
                              userName: _updateProfile.getUserName,
                              userEmail: _updateProfile.getUserEmail,
                              userPassword: value,
                              userCode: _updateProfile.getUserCode,
                              isAdmin: _updateProfile.getIsAdmin,
                            );
                        },
                        validator: (value) {
                          String val;
                          if (_updatePassword) {
                            if (oldPasswordController.text.isNotEmpty &&
                                newPasswordController.text.isNotEmpty) {
                              if (user.hash(oldPasswordController.text) !=
                                  user.getUserPassword) {
                                val = 'Old password does not match';
                              }
                            } else if (oldPasswordController.text.isEmpty ||
                                newPasswordController.text.isEmpty) {
                              val = 'Password field is empty';
                            }
                          }
                          return val;
                        },
                        controller: newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 5.0,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
