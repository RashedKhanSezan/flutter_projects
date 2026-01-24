import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:favorite_places/model/place.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onPickLocation});
  final void Function(PlaceLocation location) onPickLocation;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool _isLoading = false;
  double? _lat;
  double? _lng;
  String? _address;

  void _saveLocation(double latitude, double longitude) async {
    try {
      List<geo.Placemark> placemarks =
          await geo.placemarkFromCoordinates(latitude, longitude);
      geo.Placemark place = placemarks[0];

      setState(() {
        _lat = latitude;
        _lng = longitude;
        _address = '${place.street}, ${place.locality}, ${place.name}';
        _isLoading = false;
      });
      if (_lat == null || _lng == null) {
        return;
      }
      widget.onPickLocation(
        PlaceLocation(
            latitude: latitude, longitude: longitude, address: _address!),
      );
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error $e');
    }
  }

  void _getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isLoading = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude!;
    final lng = locationData.longitude!;

    _saveLocation(lat, lng);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );
    if (pickedLocation == null) {
      return;
    }
    _saveLocation(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget containerContent = Text(
      'Nothing to show on Map',
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: Theme.of(context).colorScheme.primary),
    );
    if (_isLoading) {
      containerContent = CircularProgressIndicator();
    } else if (_lat != null || _lng != null) {
      containerContent = FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(_lat!, _lng!),
          initialZoom: 18.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.your.app.id',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(_lat!, _lng!),
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              )
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withAlpha(200),
            ),
          ),
          child: containerContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getLocation,
              label: Text('Get your location'),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              label: Text('Select on Map'),
              icon: Icon(Icons.map),
            ),
          ],
        )
      ],
    );
  }
}
