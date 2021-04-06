import 'package:ee_fyp/modal/device.dart';

enum Method { EditExisting, CreateNew }

class DeviceActions {
  final Device device;
  final Method action;

  DeviceActions({
    this.device,
    this.action,
  });
}
