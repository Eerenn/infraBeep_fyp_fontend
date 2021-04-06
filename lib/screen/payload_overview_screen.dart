import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

import 'package:ee_fyp/modal/device.dart';
import 'package:ee_fyp/modal/device_action.dart';
import 'package:ee_fyp/modal/MQTTManager.dart';
import 'package:ee_fyp/modal/payload.dart';
import 'package:ee_fyp/providers/device_provider.dart';
import 'package:ee_fyp/providers/payload_provider.dart';
import 'package:ee_fyp/providers/MQTTState.dart';

import 'package:ee_fyp/screen/devices_overview_screen.dart';
import 'package:ee_fyp/widget/payload_realtime.dart';

import '../constants.dart';

class PayloadOverviewScreen extends StatefulWidget {
  static const routeName = '/payload-overview';

  @override
  _PayloadOverviewScreenState createState() => _PayloadOverviewScreenState();
}

class _PayloadOverviewScreenState extends State<PayloadOverviewScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MQTTState currentState;
  Payloads getPayload;
  MQTTManager manager;
  DeviceActions args;
  String topic = 'getUUID';

  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => {
        _configureAndConnect(),
        addExistingPayload(),
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  var _deviceData = Device(
    id: '',
    name: '',
    topic: '',
    payload: null,
    imageUrl: '',
    userCode: '',
  );

  var _payloadData = Payload(
    name: '',
    hexVal: '',
    decodeType: 0,
    frequency: 0,
    rawlen: '',
  );

  bool _isButtonList = false;

  // ignore: deprecated_member_use
  List<Payload> newPayloads = List<Payload>();

  void _saveForm() {
    _deviceData = Device(
      id: args.device.id,
      name: args.device.name,
      topic: args.device.topic,
      payload: newPayloads,
      imageUrl: args.device.imageUrl,
      userCode: args.device.userCode,
    );
    if (_deviceData.payload.length > 0) {
      if (args.action == Method.CreateNew)
        Provider.of<Devices>(context, listen: false).addDevice(_deviceData);
      else
        Provider.of<Devices>(context, listen: false).editDevice(_deviceData);
      getPayload.clearLoadedPayload();
      manager.disconnect();
      Navigator.of(context)
          .pushReplacementNamed(DevicesOverviewScreen.routeName);
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(args.action == Method.CreateNew
              ? 'New device created'
              : 'Device edit successful'),
        ),
      );
    } else {
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('You need to atleast add one button'),
        ),
      );
    }
  }

  void addExistingPayload() {
    if (args.device.payload != null) {
      for (int i = 0; i < args.device.payload.length; i++) {
        newPayloads.add(args.device.payload[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final MQTTState state = Provider.of<MQTTState>(context);
    final getArgument =
        ModalRoute.of(context).settings.arguments as DeviceActions;
    final Payloads payloadData = Provider.of<Payloads>(context);
    topic = getArgument.device.topic;
    currentState = state;
    getPayload = payloadData;
    args = getArgument;

    void _addPayload(Payload payload) {
      newPayloads.add(payload);
      // args.device.payload.add(payload);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        title: Text(
          _isButtonList ? 'Added Button' : 'Add Button',
          style: TextStyle(
            color: white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (state.getConnectionState == MQTTConnectionState.connected)
              manager.disconnect();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                if (state.getConnectionState ==
                    MQTTConnectionState.disconnected) {
                  _configureAndConnect();
                } else if (state.getConnectionState ==
                    MQTTConnectionState.connected) {
                  manager.disconnect();
                  _configureAndConnect();
                }
              })
        ],
      ),
      body: _isButtonList
          ? newPayloads.length > 0
              ? ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  itemCount: newPayloads.length,
                  itemBuilder: (BuildContext ctx, int i) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (_) {
                        newPayloads.remove(newPayloads[i]);
                        // ignore: deprecated_member_use
                        Scaffold.of(ctx).showSnackBar(
                          SnackBar(
                            content: Text('Button Dismissed'),
                          ),
                        );
                      },
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.redAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.delete, color: white),
                            ],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.smart_button),
                        title: Text(newPayloads[i].name),
                        subtitle: Text(newPayloads[i].hexVal),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext ctx, int i) =>
                      const Divider(),
                )
              : Text('')
          : DisplayPayload(
              payloadsData: payloadData,
              nameController: nameController,
              payloadData: _payloadData,
              deviceData: _deviceData,
              addPayload: _addPayload,
            ),
      floatingActionButton: _getFAB(context),
    );
  }

  Future<void> _configureAndConnect() {
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
      host: 'broker.mqtt-dashboard.com',
      topic: topic,
      identifier: osPrefix,
      state: currentState,
      payloads: getPayload,
      isUUID: true,
    );
    manager.initializeMQTTClient();
    manager.connect();
    return Future.delayed(Duration(seconds: 2), () => manager.publish("1"));
  }

  //widget
  Widget _getFAB(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Theme.of(context).accentColor,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          backgroundColor: Theme.of(context).accentColor,
          onTap: _saveForm,
          child: const Icon(
            Icons.save_outlined,
            color: fontColor,
          ),
          label: 'Save',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, color: fontColor, fontSize: 16.0),
          labelBackgroundColor: Theme.of(context).accentColor,
        ),
        _isButtonList
            ? SpeedDialChild(
                child: Icon(
                  Icons.new_releases,
                  color: fontColor,
                ),
                backgroundColor: Theme.of(context).accentColor,
                onTap: () {
                  setState(() {
                    _isButtonList = false;
                  });
                },
                label: 'Config List',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: fontColor,
                    fontSize: 16.0),
                labelBackgroundColor: Theme.of(context).accentColor,
              )
            : SpeedDialChild(
                child: Icon(
                  Icons.list,
                  color: fontColor,
                ),
                backgroundColor: Theme.of(context).accentColor,
                onTap: () {
                  setState(() {
                    _isButtonList = true;
                  });
                },
                label: 'Button List',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: fontColor,
                    fontSize: 16.0),
                labelBackgroundColor: Theme.of(context).accentColor,
              ),
      ],
    );
  }
}
