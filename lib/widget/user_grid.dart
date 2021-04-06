import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:ee_fyp/constants.dart';

import 'package:ee_fyp/providers/auth_provider.dart';
import 'package:ee_fyp/providers/user_provider.dart';

class UserGrid extends StatefulWidget {
  @override
  _UserGridState createState() => _UserGridState();
}

enum Option { Remove }

class _UserGridState extends State<UserGrid> {
  Users _users;
  AuthClass _user;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => {
        _users.getUsers(_user.getUserCode, _user.getUserName),
        _isLoading = false,
      },
    );
  }

  void setProvider(Users users, AuthClass auth) {
    _user = auth;
    _users = users;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthClass>(context, listen: false);
    final users = Provider.of<Users>(context);
    final listUsers = users.users;
    setProvider(users, user);
    Future<void> _removeCode(AuthClass user) async {
      setState(() {
        _isLoading = true;
      });
      final update = AuthClass(
        userId: user.getUserId,
        userEmail: user.getUserEmail,
        userName: user.getUserName,
        userPassword: user.getUserPassword,
        userCode: null,
        isAdmin: false,
      );
      String callback = await Provider.of<AuthClass>(context, listen: false)
          .update(update, UpdateType.KickUser);
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(callback),
          duration: Duration(
            seconds: 2,
          ),
        ),
      );
      users.removeUser(user);
      setState(() {
        _isLoading = false;
      });
      print('updated');
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 23.0,
            bottom: 10.0,
          ),
          child: Text(
            user.getUserCode,
            style: TextStyle(
              fontSize: 27,
              color: fontColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            'Group Members',
            style: TextStyle(
              color: fontColor,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listUsers.length,
            itemBuilder: (BuildContext context, int index) {
              return _isLoading
                  ? index != 0
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                backgroundColor: fontColor,
                              ),
                            ),
                          ],
                        )
                  : ListTile(
                      leading: Icon(Icons.account_circle, size: 38),
                      title: Text(
                        listUsers[index].getUserName +
                            (listUsers[index].getIsAdmin ? ' (admin)' : ''),
                        style: TextStyle(
                          fontSize: 20,
                          color: fontColor,
                        ),
                      ),
                      subtitle: Text(
                        listUsers[index].getUserEmail,
                        style: TextStyle(
                          color: fontColor,
                        ),
                      ),
                      trailing: user.getIsAdmin
                          ? PopupMenuButton(
                              onSelected: (Option result) {
                                if (result == Option.Remove) {
                                  _removeCode(listUsers[index]);
                                  print(listUsers[index].getUserEmail);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<Option>>[
                                const PopupMenuItem(
                                  child: Text('Remove'),
                                  value: Option.Remove,
                                ),
                              ],
                            )
                          : Text(''),
                    );
            },
          ),
        ),
      ],
    );
  }
}
