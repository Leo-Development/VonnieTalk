import 'package:flutter/material.dart';

class BlurValueNotifier with ChangeNotifier {
  double _blurValue = 3;

  double get blurValue => _blurValue;

  void update(double offset) {
    _blurValue = 3 - offset / 100;
    _blurValue = _blurValue.clamp(0, 10);
    notifyListeners();
  }
}
