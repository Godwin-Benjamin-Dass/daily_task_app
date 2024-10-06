import 'dart:convert';

import 'package:daily_task_app/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static String key = '_user';
  static Future getProfileData() async {
    var pref = await SharedPreferences.getInstance();
    var data = pref.getString(key);
    if (data != null) {
      return ProfileModel.fromJson(jsonDecode(data));
    }
    return null;
  }

  static Future setProfileData({required ProfileModel profile}) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString(key, jsonEncode(profile.toJson()));
  }
}
