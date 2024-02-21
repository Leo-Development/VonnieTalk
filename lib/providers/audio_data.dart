import 'package:flutter/material.dart';

class AudioData with ChangeNotifier {
  String? _filePath;
  String? get filepath => _filePath;
  set filepath(String? value) {
    _filePath = value;
    print('in AudioData:$_filePath');

    notifyListeners();
  }

  void removeAudio() {
    _filePath = null;

    notifyListeners();
    print('this is the file path:$_filePath');
  }
}
