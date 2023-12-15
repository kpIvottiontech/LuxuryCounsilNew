import 'package:shared_preferences/shared_preferences.dart';

SetData(String dataKey, String data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(dataKey, data);
}

GetData(String Key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(Key);
}

RemoveData(String Key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove(Key);
}

SetIntData(String dataKey, int data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setInt(dataKey, data);
}

GetIntData(String Key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getInt(Key);
}

SetBool(String key, bool data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool(key, data);
}

GetBool(String key) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool(key);
}

Cleardata() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.clear();
}