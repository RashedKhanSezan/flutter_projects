import 'package:favorite_places/model/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: '',
    ),
    this.isSelecting = true,
  });
  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick Your Location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: Icon(
                Icons.save,
              ),
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
            onTap: !widget.isSelecting
                ? null
                : (tapPosition, point) {
                    setState(() {
                      _pickedLocation = point;
                    });
                  },
            initialZoom: 18,
            initialCenter:
                LatLng(widget.location.latitude, widget.location.longitude)),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.your.app.id',
          ),
          MarkerLayer(
            markers: (_pickedLocation == null && widget.isSelecting)
                ? []
                : [
                    Marker(
                      point: _pickedLocation ??
                          LatLng(widget.location.latitude,
                              widget.location.longitude),
                      child: Icon(
                        Icons.location_on_sharp,
                        color: Colors.redAccent,
                        size: 40,
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}
