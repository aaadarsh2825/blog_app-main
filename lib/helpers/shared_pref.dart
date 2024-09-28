import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String token = "token";
  static const String category = "category";
  static const String profile = "profile";

  static Future<bool> setData({required String key, required String value}) async {
    SharedPreferences shp = await SharedPreferences.getInstance();
    return shp.setString(key, value);
  }

  static Future<String?> getData({required String key}) async {
    SharedPreferences shp = await SharedPreferences.getInstance();
    return shp.getString(key); // Return type is now String?
  }

  static Future<void> clear() async {
    SharedPreferences shp = await SharedPreferences.getInstance();
    await shp.clear(); // Added await for the clear operation
  }
}
