import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ee_fyp/providers/auth_provider.dart';

import 'package:ee_fyp/screen/auth_screen.dart';
import 'package:ee_fyp/screen/profile_screen.dart';
import 'package:ee_fyp/screen/devices_overview_screen.dart';
import 'package:ee_fyp/screen/group_overview_screen.dart';

import 'package:ee_fyp/constants.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          AppBar(
            title: Text(
              'Menu',
              style: TextStyle(
                color: white,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(
              Icons.lightbulb,
            ),
            title: Text('My Devices'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(DevicesOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.family_restroom_rounded),
            title: Text('Group'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(GroupOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProfileScreen.routeName);
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AuthScreen.routeName);
                  Provider.of<AuthClass>(context, listen: false).logout();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
