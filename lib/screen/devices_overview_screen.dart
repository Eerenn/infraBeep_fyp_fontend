import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ee_fyp/constants.dart';

import 'package:ee_fyp/modal/device.dart';
import 'package:ee_fyp/modal/device_action.dart';

import 'package:ee_fyp/providers/auth_provider.dart';
import 'package:ee_fyp/widget/device_grid.dart';
import 'package:ee_fyp/widget/app_drawer.dart';
import 'package:ee_fyp/widget/header.dart';
import 'package:ee_fyp/screen/device_create_screen.dart';

class DevicesOverviewScreen extends StatelessWidget {
  static const routeName = '/device-overview';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthClass>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        elevation: 0,
      ),
      floatingActionButton: user.getUserCode != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: fontColor,
                  size: 26.0,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CreateDeviceScreen.routeName,
                    arguments: DeviceActions(
                        device: Device(), action: Method.CreateNew),
                  );
                },
              ),
            )
          : Container(),
      drawer: AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(size: size),
          DeviceGrid(),
        ],
      ),
    );
  }
}
