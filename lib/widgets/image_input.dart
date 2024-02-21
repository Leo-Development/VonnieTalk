import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:permission_handler/permission_handler.dart';

class ImageInput extends StatefulWidget {
  final Function onselectedImage;
  const ImageInput(this.onselectedImage);
  // File? onselectedImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  Future<void> _takePicture() async {
    final picker = ImagePicker();
    PermissionStatus status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    } else if (status.isDenied) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission was denied'),
            content: Text('Please go to settings to give access to permission'),
            actions: [
              TextButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'))
            ],
          );
        },
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }

    final imageFile =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspath.getApplicationDocumentsDirectory();
    //this will get for us the file location which we are allowed to access and store our apps data
    final fileName = path.basename(imageFile.path);
    //we are now storing the name of the image which was generated automatically from where it was temporally stored
    final savedImage = File('${appDir.path}/$fileName');
    await imageFile.saveTo(savedImage.path);
    //In this code, savedImage is a File that points to the new location of the image. You’re then saving the image to this location with imageFile.saveTo(savedImage.path).

    widget.onselectedImage(savedImage);

    //we are calling the function in addplaces and passing the image with the path
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    PermissionStatus status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request();
    } else if (status.isRestricted) {
      return;
    }
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _storedImage = File(pickedImage.path);
    });
    final xToFile = File(pickedImage.path);
    print('xToFile:$xToFile');
    print('pickedImage:$pickedImage');
    widget.onselectedImage(xToFile);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(width: 1),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage as File,
                  fit: BoxFit.cover,
                )
              : Text(
                  'image preview',
                  textAlign: TextAlign.center,
                ),
        ),
        Expanded(
          child: Column(
            children: [
              TextButton.icon(
                onPressed: () {
                  _takePicture();
                },
                icon: Icon(Icons.camera),
                label: Text('Take picture'),
              ),
              TextButton.icon(
                onPressed: () {
                  getImage();
                },
                icon: Icon(Icons.insert_photo_rounded),
                label: Text('Choose from gallery'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
