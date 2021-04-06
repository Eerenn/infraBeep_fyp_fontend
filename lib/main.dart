import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ee_fyp/providers/device_provider.dart';
import 'package:ee_fyp/providers/auth_provider.dart';
import 'package:ee_fyp/providers/user_provider.dart';
import 'package:ee_fyp/providers/payload_provider.dart';
import 'package:ee_fyp/providers/MQTTState.dart';

import 'package:ee_fyp/screen/auth_screen.dart';
import 'package:ee_fyp/screen/profile_screen.dart';
import 'package:ee_fyp/screen/devices_overview_screen.dart';
import 'package:ee_fyp/screen/device_detail_screen.dart';
import 'package:ee_fyp/screen/group_overview_screen.dart';
import 'package:ee_fyp/screen/payload_overview_screen.dart';
import 'package:ee_fyp/screen/device_create_screen.dart';

// import 'package:ee_fyp/screen/test_add_image.dart';

void main() {
  runApp(MyApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(168, 192, 255, .1),
  100: Color.fromRGBO(168, 192, 255, .2),
  200: Color.fromRGBO(168, 192, 255, .3),
  300: Color.fromRGBO(168, 192, 255, .4),
  400: Color.fromRGBO(168, 192, 255, .5),
  500: Color.fromRGBO(168, 192, 255, .6),
  600: Color.fromRGBO(168, 192, 255, .7),
  700: Color.fromRGBO(168, 192, 255, .8),
  800: Color.fromRGBO(168, 192, 255, .9),
  900: Color.fromRGBO(168, 192, 255, 1),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor primaryColorCustom = MaterialColor(4288781556, color);
    MaterialColor accentColorCustom = MaterialColor(4293190899, color);
    MaterialColor errorColorCustom = MaterialColor(4289110659, color);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Devices(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthClass(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Users(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Payloads(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MQTTState(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter EE FYP',
        theme: ThemeData(
          primarySwatch: primaryColorCustom,
          accentColor: accentColorCustom,
          errorColor: errorColorCustom,
          fontFamily: 'Lato',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: AuthScreen(),
        routes: {
          DeviceDetailScreen.routeName: (ctx) => DeviceDetailScreen(),
          DevicesOverviewScreen.routeName: (ctx) => DevicesOverviewScreen(),
          GroupOverviewScreen.routeName: (ctx) => GroupOverviewScreen(),
          PayloadOverviewScreen.routeName: (ctx) => PayloadOverviewScreen(),
          CreateDeviceScreen.routeName: (ctx) => CreateDeviceScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
        },
      ),
    );
  }
}
