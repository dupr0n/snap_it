import 'dart:io';

import 'package:flutter/foundation.dart';

import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items => [..._items];

  Place findById(String id) => _items.firstWhere((item) => item.id == id);

  Future<void> addPlace(String title, File image, PlaceLocation loc) async {
    final address =
        await LocationHelper.getPlaceAddress(loc.latitude, loc.longitude);
    final updatedLocation = PlaceLocation(
      latitude: loc.latitude,
      longitude: loc.longitude,
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toIso8601String(),
      title: title,
      location: updatedLocation,
      image: image,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert({
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> removePlace(String id) async {
    _items.removeAt(_items.indexWhere((item) => item.id == id));
    notifyListeners();
    DBHelper.delete(id);
  }

  Future<void> initialize() async {
    final dataList = await DBHelper.getData(DBHelper.tableName);
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_lng'],
                address: item['address'],
              ),
              image: File(item['image']),
            ))
        .toList();
    notifyListeners();
  }
}
