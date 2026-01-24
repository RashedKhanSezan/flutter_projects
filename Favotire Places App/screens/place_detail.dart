import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PlaceDetail extends ConsumerWidget {
  final Place place;

  const PlaceDetail({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Stack(
        children: [
          Image.file(
            place.file,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hero(
                //   tag: 'eeeee',
                //   flightShuttleBuilder: (flightContext, animation,
                //           flightDirection, fromHeroContext, toHeroContext) =>
                //       AnimatedBuilder(
                //           animation: animation,
                //           builder: (context, child) {
                //             return Container(
                //               decoration: BoxDecoration(
                //                   shape: BoxShape.circle, color: Colors.red),
                //             );
                //           }),
                //   child:
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          location: place.location,
                          isSelecting: false,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    child: ClipOval(
                      child: IgnorePointer(
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(place.location.latitude,
                                place.location.longitude),
                            initialZoom: 18.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.your.app.id',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(place.location.latitude,
                                      place.location.longitude),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 80),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.transparent,
                          const Color.fromARGB(186, 0, 0, 0)
                        ]),
                  ),
                  child: Text(
                    place.location.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
