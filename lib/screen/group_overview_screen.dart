import 'package:ee_fyp/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ee_fyp/providers/auth_provider.dart';
import 'package:ee_fyp/widget/app_drawer.dart';
import 'package:ee_fyp/widget/user_get_code.dart';
import 'package:ee_fyp/widget/user_grid.dart';

enum Actions { LeaveGroup }

// ignore: must_be_immutable
class GroupOverviewScreen extends StatefulWidget {
  static const routeName = '/group-overview';

  @override
  _GroupOverviewScreenState createState() => _GroupOverviewScreenState();
}

class _GroupOverviewScreenState extends State<GroupOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    Future<void> _removeCode(AuthClass user) async {
      final update = AuthClass(
        userId: user.getUserId,
        userEmail: user.getUserEmail,
        userName: user.getUserName,
        userPassword: user.getUserPassword,
        userCode: null,
        isAdmin: false,
      );
      await Provider.of<AuthClass>(context, listen: false)
          .update(update, UpdateType.LeaveGroup);
      print('updated');
    }

    final userData = Provider.of<AuthClass>(context);
    double appBarHeight = _appBar.preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Group',
          style: TextStyle(color: white),
        ),
        iconTheme: IconThemeData(color: white),
        actions: [
          userData.getUserCode != null
              ? PopupMenuButton(
                  onSelected: (Actions result) {
                    if (result == Actions.LeaveGroup) {
                      _removeCode(userData);
                      print(userData.getUserEmail);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<Actions>>[
                    const PopupMenuItem(
                      child: Text('Leave Group'),
                      value: Actions.LeaveGroup,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
      drawer: AppDrawer(),
      body: userData.getUserCode != '' && userData.getUserCode != null
          ? UserGrid()
          : UserGetCode(appBarHeight: appBarHeight),
    );
  }

  AppBar _appBar = AppBar();
}
