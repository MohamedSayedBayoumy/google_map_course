import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  String id;
  String name;
  LatLng postion;

  PlaceModel({
    required this.id,
    required this.name,
    required this.postion,
  });
}
