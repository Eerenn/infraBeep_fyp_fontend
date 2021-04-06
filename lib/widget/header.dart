import 'package:ee_fyp/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ee_fyp/providers/auth_provider.dart';

class Header extends StatelessWidget {
  const Header({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthClass>(context, listen: false);
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          height: size.height * 0.14,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          width: size.width,
          child: Text(
            'Welcome back, ${currentUser.getUserName}!',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: white, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
              color: defaultColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2.0,
                  offset: Offset(0, -4.0),
                  color: fontColor,
                ),
              ]),
          width: size.width,
          margin: EdgeInsets.only(
            top: 50,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            child: Text(
              "My Appliances",
              style: TextStyle(
                  fontSize: 17, color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
