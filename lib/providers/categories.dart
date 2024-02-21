import 'dart:io';

import 'package:flutter/material.dart';

class Categories {
  final String title;
  final String imagePath;
  final String id;
  Categories({required this.imagePath, required this.title, required this.id});

  ImageProvider<Object>? get image {
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    }
    return FileImage(File(imagePath));
  }
}
