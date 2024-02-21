import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_access/providers/audio_data.dart';
import 'package:voice_access/providers/data.dart';
import 'package:voice_access/providers/items.dart';
import 'package:voice_access/widgets/image_input.dart';
import 'package:voice_access/widgets/recording_screen.dart';

class AddData extends StatefulWidget {
  AddData(this.categoryId);
  final String categoryId;
  static const routeName = '/AddData';

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final form = GlobalKey<FormState>();
  var _isLoading = false;
  late File pickedImage;
  //Data? edittedProducts;

  void onselectedImage(File picked) {
    setState(() {
      pickedImage = picked;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pickedImage = File('');
    edittedProducts = Data(
        id: null,
        image: '',
        title: '',
        audioPath: null,
        categoryId: widget.categoryId);
    super.dispose();
  }

  // TODO: implement initState

  //final String audioData = '';

  var edittedProducts =
      Data(id: null, image: '', title: '', audioPath: '', categoryId: '');

  // String? audioData = Provider.of<AudioData>(context, listen: false).filepath;

  Future<void> save() async {
    final validate = form.currentState!.validate();
    if (validate) {
      form.currentState!.save();
    } else {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    String? audioData = Provider.of<AudioData>(context, listen: false).filepath;
    edittedProducts = Data(
        id: edittedProducts.id,
        image: edittedProducts.image,
        title: edittedProducts.title,
        audioPath: audioData,
        categoryId: edittedProducts.categoryId);
    print('Printing wont take a while2:$audioData');
    print(edittedProducts.audioPath);

    await Provider.of<Items>(context, listen: false).addItem(
        edittedProducts.title,
        pickedImage,
        edittedProducts.audioPath,
        widget.categoryId);
    setState(() {
      _isLoading = false;
    });
    // resetState();
    Navigator.of(context).pop();
    print('below is the picked image.......');
    print(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () => save(), icon: Icon(Icons.save))],
        title: const Text('Add item'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ImageInput(onselectedImage),
                  SizedBox(
                    height: 20,
                  ),
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
                      decoration:
                          const InputDecoration(labelText: 'Enter title'),
                      textInputAction: TextInputAction.done,
                      //onFieldSubmitted: (value) {},
                      onSaved: (newValue) {
                        edittedProducts = Data(
                            id: edittedProducts.id,
                            image: edittedProducts.image,
                            title: newValue.toString(),
                            audioPath: edittedProducts.audioPath,
                            categoryId: edittedProducts.categoryId);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RecordingScreen()
                ],
              ),
            ),
    );
  }
}
