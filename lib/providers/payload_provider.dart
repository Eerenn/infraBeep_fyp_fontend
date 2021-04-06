import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ee_fyp/modal/payload.dart';

class Payloads with ChangeNotifier {
  List<Payload> _payloads = [
    // Payload(
    //   name: 'off',
    //   hexVal: 'e617d32d',
    //   decodeType: -1,
    //   frequency: 32,
    //   rawlen:
    //       'unsigned int  rawData[115] = {3550,1650,500,400,500,1200,450,450,450,400,450,400,450,450,450,400,450,450,450,400,450,400,450,450,450,400,450,400,450,1300,450,450,450,400,450,400,450,450,450,400,450,400,450,1300,450,450,450,1250,450,1300,450,450,450,400,500,1250,450,400,500,400,450,400,450,400,450,1300,450,450,450,400,450,400,450,450,500,1200,500,1250,500,400,500,350,450,1300,550,300,500,400,500,350,500,350,550,1200,550,350,500,350,450,1300,450,400,450,1300,450,400,450,450,450,400,450,1300,450,400,450};',
    // ),
    // Payload(
    //   name: 'off',
    //   hexVal: 'e617d32d',
    //   decodeType: -1,
    //   frequency: 32,
    //   rawlen:
    //       'unsigned int  rawData[115] = {3550,1650,500,400,500,1200,450,450,450,400,450,400,450,450,450,400,450,450,450,400,450,400,450,450,450,400,450,400,450,1300,450,450,450,400,450,400,450,450,450,400,450,400,450,1300,450,450,450,1250,450,1300,450,450,450,400,500,1250,450,400,500,400,450,400,450,400,450,1300,450,450,450,400,450,400,450,450,500,1200,500,1250,500,400,500,350,450,1300,550,300,500,400,500,350,500,350,550,1200,550,350,500,350,450,1300,450,400,450,1300,450,400,450,450,450,400,450,1300,450,400,450};',
    // ),
  ];

  List<Payload> get payloads {
    return [..._payloads];
  }

  int get count {
    return _payloads.length;
  }

  // Payload findByhexVal(String hexVal) {
  //   return _payloads.firstWhere((item) => item.hexVal == hexVal);
  // }

  void addPayload(Payload payload) {
    final newPayload = Payload(
      decodeType: payload.decodeType,
      name: payload.name,
      hexVal: payload.hexVal,
      frequency: payload.frequency,
      rawlen: payload.rawlen,
    );
    _payloads.add(newPayload);
    notifyListeners();
  }

  Future<void> getUUID(String uuid) async {
    final url =
        'https://5v4wl41qb6.execute-api.ap-southeast-1.amazonaws.com/test/payload/$uuid';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(Payload.fromJson(jsonDecode(response.body)).hexVal);
      _payloads.add(Payload.fromJson(jsonDecode(response.body)));
      // _payloads.insert(0, Payload.fromJson(jsonDecode(response.body)));
      notifyListeners();
      return;
    } else {
      throw Exception('Failed to load payload');
    }
  }

  void clearLoadedPayload() {
    _payloads.clear();
    notifyListeners();
  }
}
