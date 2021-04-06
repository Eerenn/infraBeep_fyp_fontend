import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

import './device.dart';
import '../constants.dart';
import '../providers/device_provider.dart';
import '../providers/auth_provider.dart';

class DeviceGrid extends StatefulWidget {
  @override
  _DeviceGridState createState() => _DeviceGridState();
}

class _DeviceGridState extends State<DeviceGrid> {
  Devices _devices;
  AuthClass _authClass;

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => {
        _devices.getDevices(_authClass.getUserCode),
        _isLoading = false,
      },
    );
  }

  void setProvider(Devices devs, AuthClass auth) {
    _authClass = auth;
    _devices = devs;
  }

  @override
  Widget build(BuildContext context) {
    final devicesData = Provider.of<Devices>(context);
    final user = Provider.of<AuthClass>(context, listen: false);
    final devices = devicesData.devices;
    setProvider(devicesData, user);
    return user.getUserCode == null
        ? Center(
            child: Text('you need to join group with a code first'),
          )
        : _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: fontColor,
                ),
              )
            : Flexible(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10,
                  ),
                  itemCount: devices.length,
                  itemBuilder: (ctx, i) => DeviceWidget(
                    devices[i].id,
                    devices[i].name,
                    devices[i].imageUrl,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                  ),
                ),
              );
  }
}
