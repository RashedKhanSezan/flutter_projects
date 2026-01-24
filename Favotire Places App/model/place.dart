import 'dart:io';

import 'package:uuid/uuid.dart';

final myUuid = Uuid();

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class Place {
  String? id;
  String name;
  File file;
  PlaceLocation location;
  Place({
    required this.name,
    required this.file,
    required this.location,
    id
  }) : id = myUuid.v4();
}
