import 'dart:convert';

import 'package:flutter/material.dart';

import '../modal/device.dart';
import 'package:http/http.dart' as http;

class Devices with ChangeNotifier {
  List<Device> _devices = [];

  List<Device> get devices {
    return [..._devices];
  }

  Device findById(String id) {
    return _devices.firstWhere((item) => item.id == id, orElse: () => null);
  }

  void getDevices(String userCode) async {
    final url =
        'https://5v4wl41qb6.execute-api.ap-southeast-1.amazonaws.com/test/devices/$userCode';

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // print(response.body);
      var json = jsonDecode(response.body);
      List<Device> myModels;
      myModels = (json as List).map((i) => Device.fromJson(i)).toList();
      _devices.clear();
      for (int i = 0; i < myModels.length; i++) {
        _devices.add(myModels[i]);
      }
      notifyListeners();
    }
  }

  Future<void> editDevice(Device device) async {
    final url =
        'https://5v4wl41qb6.execute-api.ap-southeast-1.amazonaws.com/test/device/${device.id}';

    final List<Map<String, dynamic>> jsonPayload = device.payload
        .map((values) => ({
              'decodeType': values.decodeType,
              'hexVal': values.hexVal,
              'name': values.name,
              'frequency': values.frequency,
              'rawlen': values.rawlen,
            }))
        .toList();

    await http
        .put(
      url,
      body: jsonEncode(
        {
          'name': device.name,
          'topic': device.topic,
          'payload': jsonPayload,
          'imageUrl': device.imageUrl,
          'userCode': device.userCode,
        },
      ),
    )
        .then(
      (res) {
        print(res.body);
        print(res.statusCode);
        Device newDevice = Device.fromJson(jsonDecode(res.body));
        Device oldDevice = this.findById(newDevice.id);
        _devices.remove(oldDevice);
        _devices.add(newDevice);
        notifyListeners();
      },
    );
  }

  Future<void> addDevice(Device device) async {
    const url =
        'https://5v4wl41qb6.execute-api.ap-southeast-1.amazonaws.com/test/device';

    final List<Map<String, dynamic>> jsonPayload = device.payload
        .map((values) => ({
              'decodeType': values.decodeType,
              'hexVal': values.hexVal,
              'name': values.name,
              'frequency': values.frequency,
              'rawlen': values.rawlen,
            }))
        .toList();

    await http
        .post(url,
            body: jsonEncode({
              'name': device.name,
              'topic': device.topic,
              'payload': jsonPayload,
              'imageUrl': device.imageUrl,
              'userCode': device.userCode,
            }))
        .then(
      (res) {
        print(res.body);
        Device device = Device.fromJson(jsonDecode(res.body));

        print(device.id);
        final newDevice = Device(
          id: device.id,
          name: device.name,
          topic: device.topic,
          payload: device.payload,
          imageUrl: device.imageUrl,
          userCode: device.userCode,
        );
        _devices.add(newDevice);
        // devices.insert(0, newDevice);
        notifyListeners();
      },
    );
  }

  Future<void> deleteDevice(Device device) async {
    final url =
        'https://5v4wl41qb6.execute-api.ap-southeast-1.amazonaws.com/test/device/${device.id}';

    await http.delete(url).then(
      (res) {
        if (res.statusCode == 200) {
          _devices.remove(device);
          notifyListeners();
        }
      },
    );
  }
}
