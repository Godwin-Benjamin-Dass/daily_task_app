import 'package:daily_task_app/models/profile_model.dart';
import 'package:daily_task_app/services/profile_service.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? _profileData;
  ProfileModel? get profileData => _profileData;

  bool _isNew = true;
  bool get isNew => _isNew;

  set setNew(val) {
    _isNew = val;
    notifyListeners();
  }

  getProfileDate() async {
    _profileData = await ProfileService.getProfileData();
    notifyListeners();
    return _profileData;
  }
}
