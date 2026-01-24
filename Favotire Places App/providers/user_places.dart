import 'dart:io';
import 'package:favorite_places/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as systemPath;
import 'package:path/path.dart' as filePath;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    filePath.join(dbPath, 'places.db'),
    onCreate: (dataBase, version) {
      return dataBase.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super([]);

  Future<void> loadPlaceDb() async {
    final db = await _getDataBase();
    final data = await db.query('user_places');
    final listPlaces = data.map((databaseRow) {
      return Place(
        id: databaseRow['id'] as String,
        name: databaseRow['title'] as String,
        file: File(databaseRow['image'] as String),
        location: PlaceLocation(
          latitude: databaseRow['lat'] as double,
          longitude: databaseRow['lng'] as double,
          address: databaseRow['address'] as String,
        ),
      );
    }).toList();

    state = listPlaces;
  }

  void addPlace(Place myPlace) async {
    final appDirectory = await systemPath.getApplicationDocumentsDirectory();

    final fileName = filePath.basename(myPlace.file.path);

    final copiedFile =
        await myPlace.file.copy('${appDirectory.path}/$fileName');

    final newPlace =
        Place(name: myPlace.name, file: copiedFile, location: myPlace.location);

    final db = await _getDataBase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': myPlace.name,
      'image': myPlace.file.path,
      'lat': myPlace.location.latitude,
      'lng': myPlace.location.longitude,
      'address': myPlace.location.address,
    });

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
