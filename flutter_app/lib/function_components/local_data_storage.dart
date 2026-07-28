import 'package:shared_preferences/shared_preferences.dart';

class LocalDataStorage {

  final String key;

  const LocalDataStorage(this.key);

  void setData(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getData(String emptyValue) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? emptyValue;
  }
}