import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPref {
  Future<bool> setStatus(String key, bool value);
  Future<bool> getStatus(String key);
  Future<bool> setTurnOnLight();
  Future<bool> setTurnOnFan();
  Future<bool> setTurnOffLight();
  Future<bool> setTurnOffFan();
  Future<String> getTurnOnLight();
  Future<String> getTurnOnFan();
  Future<String> getTurnOffLight();
  Future<String> getTurnOffFan();
  Future<bool> setAddress(String address);
  Future<String> getAddress();
}

class SharedPrefService implements SharedPref {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<bool> setAddress(String address) async {
    return await _prefs.then((pref) => pref.setString('address', address));
  }

  @override
  Future<String> getAddress() async {
    return await _prefs.then((pref) => pref.getString('address')??"nothing");
  }
  //save light/ fan status
  @override
  Future<bool> setStatus(String key, bool value) async {
    try {
      return await _prefs.then(
          (pref) => pref.setBool(key, value).then((bool success) => value));
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //read light fan status
  @override
  Future<bool> getStatus(String key) async {
    try {
      return await _prefs.then((pref) => pref.getBool(key) ?? false);
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> setTurnOnLight() async {
    return await _prefs.then((pref) => pref
        .setString(
            'turnOnLight',
            DateTime.now().hour.toString() +
                ':' +
                DateTime.now().minute.toString() +
                ':' +
                DateTime.now().second.toString())
        .then((value) => value));
  }

  @override
  Future<String> getTurnOnLight() async {
    return await _prefs.then((pref) => pref.getString('turnOnLight'));
  }

  @override
  Future<bool> setTurnOnFan() async {
    return await _prefs.then((pref) => pref
        .setString(
            'turnOnFan',
            DateTime.now().hour.toString() +
                ':' +
                DateTime.now().minute.toString() +
                ':' +
                DateTime.now().second.toString())
        .then((value) => value));
  }

  @override
  Future<String> getTurnOnFan() async {
    return await _prefs.then((pref) => pref.getString('turnOnFan'));
  }

  @override
  Future<bool> setTurnOffLight() async {
    return await _prefs.then((pref) => pref
        .setString(
            'turnOffLight',
            DateTime.now().hour.toString() +
                ':' +
                DateTime.now().minute.toString() +
                ':' +
                DateTime.now().second.toString())
        .then((value) => value));
  }

  @override
  Future<String> getTurnOffLight() async {
    return await _prefs.then((pref) => pref.getString('turnOffLight'));
  }

  @override
  Future<bool> setTurnOffFan() async {
    return await _prefs.then((pref) => pref
        .setString(
            'turnOffFan',
            DateTime.now().hour.toString() +
                ':' +
                DateTime.now().minute.toString() +
                ':' +
                DateTime.now().second.toString())
        .then((value) => value));
  }

  @override
  Future<String> getTurnOffFan() async {
    return await _prefs.then((pref) => pref.getString('turnOffFan'));
  }
}
