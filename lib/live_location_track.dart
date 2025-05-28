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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await LocationServices.checkLocationServicesAndPermission();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        onMapCreated: (controller) {
          _googleMapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          zoom: 2.0,
          target: LatLng(30.16078301167607, 31.62501376459161),
        ),
      ),
    );
  }
}
