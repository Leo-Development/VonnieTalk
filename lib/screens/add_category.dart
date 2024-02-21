import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_access/providers/categories.dart';
import 'package:voice_access/providers/categories_provider.dart';
import 'package:voice_access/widgets/image_input.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});
  static const routeName = '/AddCategory';
  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  var enteredText = Categories(imagePath: '', title: '', id: '');
  final form = GlobalKey<FormState>();
  File? _pickedImage;
  final _isLoading = false;
  void selectedImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  Future<void> save() async {
    final validate = form.currentState!.validate();
    if (validate) {
      form.currentState!.save();
    } else {
      return;
    }
    setState(() {
      _isLoading == true;
    });
    await Provider.of<CategoriesProvider>(context, listen: false)
        .addCat(enteredText.title, _pickedImage as File);
    setState(() {
      _isLoading == false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add category'),
        actions: [IconButton(onPressed: () => save(), icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Form(
                  key: form,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Tile'),
                    textInputAction: TextInputAction.done,
                    onSaved: (newValue) {
                      enteredText = Categories(
                        imagePath: enteredText.imagePath,
                        title: newValue.toString(),
                        id: enteredText.id,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ImageInput(selectedImage)
              ],
            ),
    );
  }
}
