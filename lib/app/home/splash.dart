import 'package:bluetooth_control/app/home/home.dart';
import 'package:bluetooth_control/services/bluetooth.dart';
import 'package:bluetooth_control/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 1),(){
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>MultiProvider(
        providers: [
          Provider(
            create: (_) => BluetoothService(),
          ),
          Provider(
            create: (_) => SharedPrefService(),
          )
        ],
          child: HomePage()
      )));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.bluetooth,color: Colors.white,size: 200,),
          LinearProgressIndicator()
        ],
      ),
    );
  }
}
