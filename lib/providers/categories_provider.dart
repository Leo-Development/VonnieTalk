import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voice_access/db/db_helper.dart';
import 'package:voice_access/providers/categories.dart';

class CategoriesProvider with ChangeNotifier {
  List<Categories> _catData = [
    Categories(imagePath: 'assets/animals.jfif', title: 'Animals', id: '1'),
    Categories(imagePath: 'assets/vehicles.jfif', title: 'Vehicles', id: '2'),
    Categories(imagePath: 'assets/fruits.jfif', title: 'Fruits', id: '3'),
    Categories(imagePath: 'assets/shapes.jfif', title: 'Shapes', id: '4'),
    Categories(imagePath: 'assets/colors.jfif', title: 'Colors', id: '5'),
    Categories(imagePath: 'assets/alphabet.jfif', title: 'Alphabets', id: '6')
  ];

  List<Categories> get catData {
    return _catData;
  }

  addCat(String title, File images) {
    final newCat = Categories(
        imagePath: images.path, title: title, id: DateTime.now().toString());
    _catData.add(newCat);
    notifyListeners();
    DBHelper.insertData('category', {
      'categoryId': newCat.id,
      'title': newCat.title,
      'image': newCat.imagePath
    });
  }

  Future<void> fetchAndSet() async {
    final dataList = await DBHelper.getData('category');
    if (dataList.isNotEmpty) {
      _catData.addAll(dataList.map((cat) {
        return Categories(
            imagePath: cat['image'],
            title: cat['title'],
            id: cat['categoryId']);
      }).toList());
      notifyListeners();
    }
  }

  Categories findById(String catId) {
    return _catData.firstWhere((element) => element.id == catId);
  }
}
