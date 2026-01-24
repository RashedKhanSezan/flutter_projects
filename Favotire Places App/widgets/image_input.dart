import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ImageInput extends StatefulWidget {
  final void Function(File pickedImage) onPickImage;

  const ImageInput({
    super.key,
    required this.onPickImage
  });

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  final imagePicker = ImagePicker();
  void _takeImage() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takeImage,
      label: Text('Capture Now'),
      icon: Icon(Icons.camera),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takeImage,
        child: Image.file(
          _selectedImage!,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withAlpha(200),
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
