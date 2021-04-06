import 'package:ee_fyp/constants.dart';
import 'package:ee_fyp/modal/MQTTManager.dart';
import 'package:ee_fyp/providers/MQTTState.dart';
import 'package:ee_fyp/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:ee_fyp/screen/devices_overview_screen.dart';
import 'package:ee_fyp/screen/payload_overview_screen.dart';
import 'package:ee_fyp/widget/device_form.dart';

import 'package:ee_fyp/modal/device_action.dart';
import 'package:ee_fyp/modal/device.dart';
import 'package:ee_fyp/providers/auth_provider.dart';

enum ActionMode { DiscardChanges, Delete }

// ignore: must_be_immutable
class CreateDeviceScreen extends StatelessWidget {
  static const routeName = '/device-create';
  final _form = GlobalKey<FormState>();
  MQTTManager manager;
  MQTTState currentState;
  Device _device;

  final nameController = TextEditingController();
  final topicController = TextEditingController();

  var _editedDevice = Device(
    id: '',
    name: '',
    topic: '',
    payload: null,
    imageUrl: '',
    userCode: '',
  );
  String base64Image;
  void _uploadImage(String base64String) async {
    String url = await _device.addImage(base64String);
    _editedDevice = Device(
      id: _editedDevice.id,
      name: _editedDevice.name,
      topic: _editedDevice.topic,
      payload: _editedDevice.payload,
      imageUrl: url,
      userCode: _editedDevice.userCode,
    );
  }

  void _saveForm(Method method, BuildContext context) {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      _editedDevice = Device(
        id: _editedDevice.id,
        name: _editedDevice.name,
        topic: _editedDevice.topic,
        payload: _editedDevice.payload,
        imageUrl: _editedDevice.imageUrl,
        userCode: _editedDevice.userCode,
      );
      final devAction = DeviceActions(device: _editedDevice, action: method);
      print(devAction.device.topic);
      print(devAction.device.name);
      print(devAction.device.imageUrl);
      Navigator.of(context)
          .pushNamed(PayloadOverviewScreen.routeName, arguments: devAction);
    }
  }

  void setName(String name) {
    _editedDevice = Device(
      id: _editedDevice.id,
      name: name,
      topic: _editedDevice.topic,
      payload: _editedDevice.payload,
      imageUrl: _editedDevice.imageUrl,
      userCode: _editedDevice.userCode,
    );
  }

  void setTopic(String topic) {
    _editedDevice = Device(
      id: _editedDevice.id,
      name: _editedDevice.name,
      topic: topic,
      payload: _editedDevice.payload,
      imageUrl: _editedDevice.imageUrl,
      userCode: _editedDevice.userCode,
    );
  }

  void setUserCode(String code) {
    _editedDevice = Device(
      id: _editedDevice.id,
      name: _editedDevice.name,
      topic: _editedDevice.topic,
      payload: _editedDevice.payload,
      imageUrl: _editedDevice.imageUrl,
      userCode: code,
    );
  }

  void setPayload(Device device) {
    _editedDevice = Device(
      id: device.id,
      name: _editedDevice.name,
      topic: _editedDevice.topic,
      payload: device.payload,
      imageUrl: _editedDevice.imageUrl,
      userCode: _editedDevice.userCode,
    );
  }

  void setImageUrl(Device device) {
    _editedDevice = Device(
      id: device.id,
      name: _editedDevice.name,
      topic: _editedDevice.topic,
      payload: _editedDevice.payload,
      imageUrl: device.imageUrl,
      userCode: _editedDevice.userCode,
    );
  }

  // void setImg(String url) {
  //   _editedDevice = Device(
  //     id: _editedDevice.id,
  //     name: _editedDevice.name,
  //     topic: _editedDevice.topic,
  //     payload: _editedDevice.payload,
  //     imageUrl: url,
  //     userCode: _editedDevice.userCode,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final MQTTState state = Provider.of<MQTTState>(context);
    final args = ModalRoute.of(context).settings.arguments as DeviceActions;
    currentState = state;

    if (args != null) {
      nameController.text = args.device.name;
      topicController.text = args.device.topic;

      _device = args.device;
      setPayload(args.device);
      if (args.device.imageUrl != null) setImageUrl(args.device);
    }
    final user = Provider.of<AuthClass>(context);
    setUserCode(user.getUserCode);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        title: Text(
          '${args.action == Method.CreateNew ? 'Create New' : 'Edit'} Device',
          style: TextStyle(color: white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildPopupDialog(
                context,
                ActionMode.DiscardChanges,
                args.device,
              ),
            );
          },
        ),
        actions: [
          args.action == Method.EditExisting
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildPopupDialog(
                        context,
                        ActionMode.Delete,
                        args.device,
                      ),
                    );
                  })
              : Container(),
        ],
      ),
      body: DeviceForm(
        form: _form,
        nameController: nameController,
        topicController: topicController,
        args: args,
        saveForm: _saveForm,
        saveName: setName,
        saveTopic: setTopic,
        uploadImage: _uploadImage,
        base64Image: base64Image,
      ),
    );
  }

  Widget _buildPopupDialog(
      BuildContext context, ActionMode action, Device device) {
    return action == ActionMode.DiscardChanges
        ? AlertDialog(
            title: const Text('Discard Changes?'),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Are you sure you want to quit? \n Filled form won\'t be saved',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.8,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(DevicesOverviewScreen.routeName);
                },
                textColor: Theme.of(context).primaryColor,
                child: const Text('Yes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Theme.of(context).primaryColor,
                child: const Text('No'),
              ),
            ],
          )
        : AlertDialog(
            title: const Text('Delete Device?'),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Are you sure you want to delete this device?',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.8,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  await Provider.of<Devices>(context, listen: false)
                      .deleteDevice(device)
                      .then(
                        (_) => Navigator.of(context).pushReplacementNamed(
                            DevicesOverviewScreen.routeName),
                      );
                },
                textColor: Theme.of(context).primaryColor,
                child: const Text('Confirm delete'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Theme.of(context).primaryColor,
                child: const Text('No'),
              ),
            ],
          );
  }
}
