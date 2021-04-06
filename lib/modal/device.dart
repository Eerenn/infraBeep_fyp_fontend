import 'dart:async';
import 'dart:convert';

import 'package:ee_fyp/modal/payload.dart';
import 'package:http/http.dart' as http;

class Device {
  final String id;
  final String name;
  final String topic;
  final List<Payload> payload;
  final String imageUrl;
  final String userCode;

  Device({
    this.id,
    this.name,
    this.topic,
    this.payload,
    this.imageUrl,
    this.userCode,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    List<Payload> myModels;
    myModels = (json['payload'] as List)
        .map((i) => Payload.fromJsonString(i))
        .toList();

    return Device(
        id: json['id'],
        name: json['name'],
        topic: json['topic'],
        payload: myModels,
        imageUrl: json['imageUrl'],
        userCode: json['userCode']);
  }

  Future<String> addImage(String base64String) async {
    const url =
        'https://5v4wl41qb6.execute-api.ap-southeast-1.amazonaws.com/test/image-upload';

    String imageUrl;
    await http
        .post(
      url,
      body: jsonEncode(
        {
          'image': base64String,
        },
      ),
    )
        .then(
      (res) {
        print(res.body);
        imageUrl = jsonDecode(res.body)['imageURL'];
        print(imageUrl);
      },
    );

    return imageUrl;
  }
}
