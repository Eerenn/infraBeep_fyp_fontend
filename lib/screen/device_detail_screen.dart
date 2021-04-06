import 'dart:io';
import 'package:ee_fyp/screen/device_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:ee_fyp/modal/MQTTManager.dart';
import 'package:ee_fyp/providers/MQTTState.dart';
import 'package:ee_fyp/modal/device_action.dart';
import 'package:ee_fyp/providers/device_provider.dart';

import 'package:ee_fyp/constants.dart';

class DeviceDetailScreen extends StatefulWidget {
  static const routeName = '/device-detail';

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  String topic = '';
  MQTTManager manager;
  MQTTState currentState;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => _configureAndConnect(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MQTTState state = Provider.of<MQTTState>(context);
    final deviceId = ModalRoute.of(context).settings.arguments as String;
    final loadedDevice = Provider.of<Devices>(
      context,
      listen: false,
    ).findById(deviceId);
    if (loadedDevice != null) topic = loadedDevice.topic;
    currentState = state;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            manager.disconnect();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 26.0,
            ),
            onPressed: () {
              manager.disconnect();
              Navigator.of(context).pushReplacementNamed(
                CreateDeviceScreen.routeName,
                arguments: DeviceActions(
                  device: loadedDevice,
                  action: Method.EditExisting,
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: loadedDevice != null
                  ? loadedDevice.imageUrl != '' && loadedDevice.imageUrl != null
                      ? Image.network(
                          loadedDevice.imageUrl,
                          height: 180,
                        )
                      : Container(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('No image to display'),
                            ],
                          ),
                        )
                  : Container(),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Text(
              loadedDevice != null ? loadedDevice.name.toUpperCase() : '',
              style: TextStyle(
                color: fontColor,
                fontSize: 25,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Text(
              loadedDevice != null ? loadedDevice.topic.toUpperCase() : '',
              style: TextStyle(
                color: fontColor,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: loadedDevice != null
                ? ListView.separated(
                    padding: EdgeInsets.all(15),
                    itemCount: loadedDevice.payload.length,
                    itemBuilder: (BuildContext ctx, int i) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: defaultColor,
                          ),
                          child: ListTile(
                            title: Text(
                              loadedDevice.payload[i].hexVal,
                              style: TextStyle(color: fontColor),
                            ),
                            trailing: RaisedButton(
                              onPressed: () {
                                String payload = loadedDevice.id +
                                    '/payload/' +
                                    loadedDevice.payload[i].name;
                                manager.publish(payload);
                              },
                              child: Text(
                                loadedDevice.payload[i].name,
                                style: TextStyle(color: white),
                              ),
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  void _configureAndConnect() {
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
      host: 'broker.mqtt-dashboard.com',
      topic: topic,
      identifier: osPrefix,
      state: currentState,
      isUUID: false,
    );
    manager.initializeMQTTClient();
    manager.connect();
  }
}
