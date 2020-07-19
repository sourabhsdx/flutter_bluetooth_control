import 'package:bluetooth_control/services/bluetooth.dart';
import 'package:bluetooth_control/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _value;
  bool _connected = false;

  @override
  Widget build(BuildContext context) {
    final Bluetooth bluetooth = Provider.of<BluetoothService>(context);
    final SharedPref sharedPref = Provider.of<SharedPrefService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(Icons.bluetooth),
        title: Text("Bluetooth Control"),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
          color: Colors.white
        ),
        child: Column(
          children: <Widget>[
            FutureBuilder<List<BluetoothDevice>>(
              future: bluetooth.getDevices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          DropdownButtonFormField(
                            items: snapshot.data
                                .map((e) => DropdownMenuItem(
                                      child: Text(e.name),
                                      value: e.address,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                                print(_value);
                              });
                            },
                            value: _value,
                          ),
                          RaisedButton(
                            child: Text(_connected ? "Disconnect" : "Connect"),
                            onPressed: _connected
                                ? () => _disconnect(context)
                                : () => _connect(context),
                          )
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Turn on bluetooth"),
                  );
                }
                return CircularProgressIndicator();
              },
            ),
            Text("Status:"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.lightbulb_outline),
                title: FutureBuilder<bool>(
                  future: sharedPref.getStatus('light'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return snapshot.data ? Text('Status : On ') : Text('Status : Off ');
                      }
                      return Text('Off ');
                    }
                    return Text('unknown');
                  },
                ),
                subtitle: FutureBuilder<String>(
                  future: sharedPref.getTurnOnLight(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.done){
                      if(snapshot.hasData){
                        return Text("Last turned on: ${snapshot.data}");
                      }
                      return Text('unknown');
                    }
                    return Text('unknown');
                  },
                ),
                trailing: FutureBuilder<String>(
                  future: sharedPref.getTurnOffLight(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.done){
                      if(snapshot.hasData){
                        return Text("Last turned off: ${snapshot.data}");
                      }
                      return Text('unknown');
                    }
                    return Text('unknown');
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.ac_unit),
              title: FutureBuilder<bool>(
                future: sharedPref.getStatus('fan'),
                builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return snapshot.data ? Text('Status : On ') : Text('Status : Off ');
                }
                return Text('Off ');
              }
              return Text('unknown ');
                },
              ),
                subtitle: FutureBuilder<String>(
                  future: sharedPref.getTurnOnFan(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.done){
                      if(snapshot.hasData){
                        return Text("Last turned on: ${snapshot.data}");
                      }
                      return Text('unknown');
                    }
                    return Text('unknown');
                  },
                ),
                trailing:   FutureBuilder<String>(
                  future: sharedPref.getTurnOffFan(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.done){
                      if(snapshot.hasData){
                        return Text("Last turned off: ${snapshot.data}");
                      }
                      return Text('unknown');
                    }
                    return Text('unknown');
                  },
                ),
              ),
            ),
            Material(
              elevation: 0,
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Light"),
                  FlatButton(
                    child: Text("On"),
                    onPressed: !_connected
                        ? null
                        : () {
                            bluetooth.write("L");
                            sharedPref.setStatus('light', true);
                            sharedPref.setTurnOnLight();
                            setState(() {});
                          },
                  ),
                  FlatButton(
                    child: Text("OFF"),
                    onPressed: !_connected
                        ? null
                        : () {
                            bluetooth.write("7");
                            sharedPref.setStatus('light', false);
                            sharedPref.setTurnOffLight();
                            setState(() {});
                          },
                  ),
                ],
              ),
            ),
            Material(
              elevation: 1,
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Fan"),
                  FlatButton(
                    child: Text("On"),
                    onPressed: !_connected
                        ? null
                        : () {
                            bluetooth.write("F");
                            sharedPref.setStatus('fan', true);
                            sharedPref.setTurnOnFan();
                            setState(() {});
                          },
                  ),
                  FlatButton(
                    child: Text("OFF"),
                    onPressed: !_connected
                        ? null
                        : () {
                            bluetooth.write("3");
                            sharedPref.setStatus('fan', false);
                            sharedPref.setTurnOffFan();
                            setState(() {});
                          },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _connect(BuildContext context) async {
    final Bluetooth bluetooth =
        Provider.of<BluetoothService>(context, listen: false);
    final SharedPref sharedPref =
        Provider.of<SharedPrefService>(context, listen: false);
    bool status = await bluetooth.connectTo(_value);
    if (status) {
      sharedPref.getStatus('light').then((value) {
        value ? bluetooth.write('L') : bluetooth.write('7');
      });
      sharedPref.getStatus('fan').then((value) {
        value ? bluetooth.write('F') : bluetooth.write('3');
      });
    }
    setState(() {
      _connected = status;
    });
  }

  _disconnect(BuildContext context) async {
    final Bluetooth bluetooth =
        Provider.of<BluetoothService>(context, listen: false);
    bool status = await bluetooth.disconnect();
    setState(() {
      _connected = status;
    });
  }
}
