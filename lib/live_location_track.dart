import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'utils/location_services.dart';

class LiveLocationTrack extends StatefulWidget {
  const LiveLocationTrack({super.key});

  @override
  State<LiveLocationTrack> createState() => _LiveLocationTrackState();
}

class _LiveLocationTrackState extends State<LiveLocationTrack> {
  late GoogleMapController _googleMapController;

  Set<Marker> markers = {};

  Future<void> getCurrentUasrLocation() async {
    final request = await LocationServices.checkLocationServicesAndPermission();
    if (LocationServices.isGranted(request!)) {
      navigatToUserLocation();
    }
  }

  navigatToUserLocation() async {
    final locationData = await LocationServices.location.getLocation();

    _googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(locationData.latitude!, locationData.longitude!),
        12.0,
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId("1"),
        position: LatLng(locationData.latitude!, locationData.longitude!),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        markers: markers,
        onMapCreated: (controller) async {
          _googleMapController = controller;
          await getCurrentUasrLocation();
        },
        initialCameraPosition: const CameraPosition(
          zoom: 2.0,
          target: LatLng(30.16078301167607, 31.62501376459161),
        ),
      ),
    );
  }
}
