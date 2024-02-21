import 'package:flutter/material.dart';
import 'package:voice_access/db/db_helper.dart';
import 'package:voice_access/providers/langauge_data.dart';

class LanguageNot with ChangeNotifier {
  String? language;

  // String get language {
  //   return _language.toString();
  // }

  void addLan(String audioPath) {
    language = audioPath;
    final newLan = LanguageData(audioPath);
    DBHelper.insertData(
        'language_translate', {'id': '1', 'audio_path': newLan.audioPath});
  }

  void fetch() async {
    final database = await DBHelper.getData('language_translate');
    if (database.isNotEmpty) {
      language = database.first['audio_path'] as String;
    } else {
      language = null;
    }
  }

  void delete() {
    language = null;
    DBHelper.delete('language_translate', '1');
    notifyListeners();
  }
}
