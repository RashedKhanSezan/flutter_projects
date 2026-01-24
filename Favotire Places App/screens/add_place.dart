import 'dart:io';
import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/providers/user_places.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});
  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _myText = TextEditingController();
  File? _imageFile;
  PlaceLocation? _placeLocation;

  void _savePlace() {
    final enteredText = _myText.text;

    if (enteredText.isEmpty) {
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(Place(
          name: enteredText,
          file: _imageFile!,
          location: _placeLocation!,
        ));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _myText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new place'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _myText,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(
                  height: 16,
                ),
                ImageInput(
                  onPickImage: (pickedImage) {
                    _imageFile = pickedImage;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                LocationInput(
                  onPickLocation: (location) {
                    _placeLocation = location;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: _savePlace,
                  child: Text('Add Place'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
