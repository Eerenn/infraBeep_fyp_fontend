import 'package:flutter/material.dart';

import 'package:ee_fyp/constants.dart';
import 'package:ee_fyp/screen/device_detail_screen.dart';

class DeviceWidget extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;

  DeviceWidget(this.id, this.name, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                DeviceDetailScreen.routeName,
                arguments: id,
              );
            },
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: imageUrl != '' && imageUrl != null
                    ? Image.network(
                        imageUrl,
                        height: size.height * 0.18,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: size.height * 0.18,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No image to display'),
                          ],
                        ),
                      )),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 50,
                  color: Theme.of(context).primaryColor.withOpacity(0.23),
                )
              ],
            ),
            child: Row(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: fontColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
