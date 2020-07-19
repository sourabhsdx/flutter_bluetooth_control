import 'package:bluetooth_control/services/bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluetooth_control/services/shared_pref.dart';

import 'app/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiProvider(
        providers: [
          Provider(
            create: (_)=>BluetoothService(),
          ),
          Provider(
            create: (_)=>SharedPrefService(),
          )

        ],

          child: HomePage()
      ),
    );
  }
}

