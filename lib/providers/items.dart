import 'dart:io';

import 'package:flutter/material.dart';
import 'package:voice_access/db/db_helper.dart';
import 'package:voice_access/providers/data.dart';

class Items with ChangeNotifier {
  final List<Data> _defaultValues = [
    Data(
        id: '1',
        image: 'assets/dog.jfif',
        title: 'Dog',
        audioPath: null,
        categoryId: '1'),
    Data(
        id: '2',
        image: 'assets/cat.jfif',
        title: 'Cat',
        audioPath: null,
        categoryId: '1'),
    Data(
        id: '3',
        image: 'assets/lion.jfif',
        title: 'Lion',
        audioPath: null,
        categoryId: '1'),
    Data(
        id: '4',
        image: 'assets/monkey.jfif',
        title: 'Monkey',
        audioPath: null,
        categoryId: '1'),
    Data(
        id: '5',
        image: 'assets/orange.jfif',
        title: 'Orange',
        audioPath: null,
        categoryId: '3'),
    Data(
        id: '6',
        image: 'assets/strawbelly.jfif',
        title: 'Strawbelly',
        audioPath: null,
        categoryId: '3'),
    Data(
        id: '7',
        image: 'assets/banana.jfif',
        title: 'Banana',
        audioPath: null,
        categoryId: '3'),
    Data(
        id: '8',
        image: 'assets/apple.jfif',
        title: 'Apple',
        audioPath: null,
        categoryId: '3'),
    Data(
        id: '9',
        image: 'assets/yellow.jfif',
        title: 'Yellow',
        audioPath: null,
        categoryId: '5'),
    Data(
        id: '10',
        image: 'assets/pink.jfif',
        title: 'Pink',
        audioPath: null,
        categoryId: '5'),
    Data(
        id: '11',
        image: 'assets/blue.jfif',
        title: 'Blue',
        audioPath: null,
        categoryId: '5'),
    Data(
        id: '12',
        image: 'assets/red.jfif',
        title: 'Red',
        audioPath: null,
        categoryId: '5'),
    Data(
        id: '13',
        image: 'assets/motorbike.jfif',
        title: 'Motorbike',
        audioPath: null,
        categoryId: '2'),
    Data(
        id: '14',
        image: 'assets/bicycle.jfif',
        title: 'Bicycle',
        audioPath: null,
        categoryId: '2'),
    Data(
        id: '15',
        image: 'assets/truck.jfif',
        title: 'Truck',
        audioPath: null,
        categoryId: '2'),
    Data(
        id: '16',
        image: 'assets/car.jfif',
        title: 'Car',
        audioPath: null,
        categoryId: '2'),
    Data(
        id: '17',
        image: 'assets/circle.jfif',
        title: 'Circle',
        audioPath: null,
        categoryId: '4'),
    Data(
        id: '18',
        image: 'assets/square.jfif',
        title: 'Square',
        audioPath: null,
        categoryId: '4'),
    Data(
        id: '19',
        image: 'assets/triangle.jfif',
        title: 'Triangle',
        audioPath: null,
        categoryId: '4'),
    Data(
        id: '20',
        image: 'assets/star.jfif',
        title: 'Star',
        audioPath: null,
        categoryId: '4'),
    Data(
        id: '21',
        image: 'assets/A.jfif',
        title: 'A',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '21',
        image: 'assets/B.jfif',
        title: 'B',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '22',
        image: 'assets/C.jfif',
        title: 'C',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '23',
        image: 'assets/D.jfif',
        title: 'D',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '24',
        image: 'assets/E.jfif',
        title: 'E',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '25',
        image: 'assets/F.jfif',
        title: 'F',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '26',
        image: 'assets/G.jfif',
        title: 'G',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '27',
        image: 'assets/H.jfif',
        title: 'H',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '28',
        image: 'assets/I.jfif',
        title: 'I',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '29',
        image: 'assets/J.jfif',
        title: 'J',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '30',
        image: 'assets/K.jfif',
        title: 'K',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '31',
        image: 'assets/L.jfif',
        title: 'L',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '32',
        image: 'assets/M.jfif',
        title: 'M',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '33',
        image: 'assets/N.jfif',
        title: 'N',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '34',
        image: 'assets/O.jfif',
        title: 'O',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '35',
        image: 'assets/P.jfif',
        title: 'P',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '36',
        image: 'assets/Q.jfif',
        title: 'Q',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '37',
        image: 'assets/R.jfif',
        title: 'R',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '38',
        image: 'assets/S.jfif',
        title: 'S',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '39',
        image: 'assets/T.jfif',
        title: 'T',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '40',
        image: 'assets/U.jfif',
        title: 'U',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '41',
        image: 'assets/V.jfif',
        title: 'V',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '42',
        image: 'assets/W.jfif',
        title: 'W',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '43',
        image: 'assets/X.jfif',
        title: 'X',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '44',
        image: 'assets/Y.jfif',
        title: 'Y',
        audioPath: null,
        categoryId: '6'),
    Data(
        id: '45',
        image: 'assets/Z.jfif',
        title: 'Z',
        audioPath: null,
        categoryId: '6'),
  ];
  List<Data> _items = [];

  List<Data> get items {
    return [..._items, ..._defaultValues];
  }

  Future<void> addItem(String? title, File selectedImage, String? audio,
      String categoryId) async {
    final newProduct = Data(
        id: DateTime.now().toString(),
        image: selectedImage.path,
        title: title.toString(),
        audioPath: audio,
        categoryId: categoryId);
    _items.add(newProduct);
    for (var item in _items) {
      print('this is what is inside the item:$item');
    }
    print('printing the audio:$audio');
    notifyListeners();
    DBHelper.insertData('user_images', {
      'id': newProduct.id as Object,
      'title': newProduct.title,
      'image': newProduct.image,
      'audioPath': newProduct.audioPath.toString(),
      'categoryId': newProduct.categoryId
    });
  }

  void clearItems() {
    _items.clear();
    Future.microtask(() {
      notifyListeners();
    });
  }

  void counting() {
    print(_items.length);
  }

  Future<void> fecthAndSetPlace() async {
    final datalist = await DBHelper.getData('user_images');

    _items = datalist.map((item) {
      return Data(
          id: item['id'],
          image: item['image'],
          title: item['title'],
          audioPath: item['audioPath'],
          categoryId: item['categoryId']);
    }).toList();
    print('fetching');
    notifyListeners();
  }

  List<Data> fetchItemsByCategory(String categoryId) {
    return items.where((element) => element.categoryId == categoryId).toList();
  }

  Future<void> delete(String id) async {
    final wantedItem = _items.firstWhere((element) => element.id == id);
    _items.remove(wantedItem);
    DBHelper.delete('user_images', id);
    notifyListeners();
  }
}
