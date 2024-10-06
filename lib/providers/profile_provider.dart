import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isNew = true;
  bool get isNew => _isNew;

  set setNew(val) {
    _isNew = val;
    notifyListeners();
  }
}
