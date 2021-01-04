import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) onPickedImage;

  const UserImagePicker({Key key, @required this.onPickedImage})
      : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedFile != null) {
      final nextImage = File(pickedFile.path);

      setState(() => _image = nextImage);
      widget.onPickedImage(nextImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          textColor: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
