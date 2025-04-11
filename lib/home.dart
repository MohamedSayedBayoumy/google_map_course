import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late CameraPosition cameraPosition;

  late GoogleMapController googleMapController;

  CameraTargetBounds cameraTargetBounds = CameraTargetBounds(
    LatLngBounds(
      northeast: const LatLng(30.120558505675778, 31.31808364739569),
      southwest: const LatLng(30.107614649251147, 31.29316734517162),
    ),
  );

  newLocation() {
    googleMapController.animateCamera(
      CameraUpdate.newLatLng(
        const LatLng(30.116758354354467, 31.41720120394772),
      ),
      // CameraUpdate.newCameraPosition(cameraPosition),
      // CameraUpdate.newLatLngZoom(latLng, zoom),
      // CameraUpdate.zoomIn()
      // CameraUpdate.zoomOut()
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    cameraPosition = const CameraPosition(
      zoom: 15.0,
      target: LatLng(30.11409771124938, 31.308710840796778),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              googleMapController = controller;
              setState(() {});
            },
            // cameraTargetBounds: cameraTargetBounds,
            initialCameraPosition: cameraPosition,
          ),
          Positioned(
            bottom: 10.0,
            left: 20.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: () {
                newLocation();
              },
              child: const Text("New Location"),
            ),
          )
        ],
      ),
    );
  }
}
