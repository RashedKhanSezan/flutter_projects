import 'package:favorite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/model/place.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.favPlaces});
  final List<Place> favPlaces;
  @override
  Widget build(BuildContext context) {
    if (favPlaces.isEmpty) {
      return Center(
        child: Text(
          'No places to show',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: favPlaces.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlaceDetail(
                  place: favPlaces[index],
                ),
              ),
            );
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: FileImage(favPlaces[index].file),
            ),
            title: Text(
              favPlaces[index].name,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSecondary.withAlpha(120)),
            ),
            subtitle: Text(
              favPlaces[index].location.address,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSecondary.withAlpha(120)),
            ),
          ),
        ),
      );
    }
  }
}
