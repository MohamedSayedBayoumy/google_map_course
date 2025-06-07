import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../common/services/location_services.dart';

class RouteTrackScreen extends StatefulWidget {
  const RouteTrackScreen({super.key});

  @override
  State<RouteTrackScreen> createState() => _RouteTrackScreenState();
}

class _RouteTrackScreenState extends State<RouteTrackScreen> {
  late GoogleMapController googleMapController;

  CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(0, 0));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      style: LocationServices.nightStyle,
      onMapCreated: (controller) async {
        LocationServices.initMapStyle();
        googleMapController = controller;
        setState(() {});
        await LocationServices.checkLocationServicesAndPermission();
        getUserLocationAndNavigate();
      },
      initialCameraPosition: initialCameraPosition,
    );
  }

  getUserLocationAndNavigate() async {
    final location = await LocationServices.getUserLocation();
    final cameraPosition = CameraPosition(
      target: LatLng(location.latitude!, location.longitude!),
      zoom: 16,
    );
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
