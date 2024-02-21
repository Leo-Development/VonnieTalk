import 'dart:io';

import 'package:flutter/material.dart';

class Data with ChangeNotifier {
  final String? id;
  final String title;
  final String image;
  final String? audioPath;
  final String categoryId;

  Data(
      {required this.id,
      required this.image,
      required this.title,
      required this.audioPath,
      required this.categoryId});

  @override
  String toString() {
    return 'Data{name:$title,audioPath:$audioPath}';
  }

  ImageProvider<Object> get imagepath {
    if (image.startsWith('assets/')) {
      return AssetImage(image);
    }
    return FileImage(File(image));
  }
}
