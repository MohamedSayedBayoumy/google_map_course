import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'common/services/location_services.dart';

class LiveLocationTrack extends StatefulWidget {
  const LiveLocationTrack({super.key});

  @override
  State<LiveLocationTrack> createState() => _LiveLocationTrackState();
}

class _LiveLocationTrackState extends State<LiveLocationTrack> {
  late GoogleMapController _googleMapController;

  LatLng? currentLatLong;

  Set<Marker> markers = {};

  Future<void> getCurrentUasrLocation() async {
    await LocationServices.checkLocationServicesAndPermission();
    // await navigatToUserLocation();
    addListenToLiveUserLocation();
  }

  navigatToUserLocation() async {
    final locationData = await LocationServices.location.getLocation();

    _googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(locationData.latitude!, locationData.longitude!),
        12.0,
      ),
    );
    var icon = await LocationServices.iconMap();
    markers.add(
      Marker(
        markerId: MarkerId(LocationServices.myLocationKey),
        position: LatLng(locationData.latitude!, locationData.longitude!),
        icon: icon,
      ),
    );
    setState(() {});
  }

  addListenToLiveUserLocation() {
    LocationServices.location.onLocationChanged.listen((locationData) async {
      log("New Location");

      currentLatLong = LatLng(locationData.latitude!, locationData.longitude!);

      _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLong!, 20.0),
      );
      var icon = await LocationServices.iconMap();

      markers.add(
        Marker(
          markerId: MarkerId(LocationServices.myLocationKey),
          position: currentLatLong!,
          icon: icon,
        ),
      );
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    LocationServices.initMapStyle();
    LocationServices.locationSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            markers: markers,
            style: LocationServices.nightStyle,
            onMapCreated: (controller) async {
              _googleMapController = controller;

              await getCurrentUasrLocation();
            },
            initialCameraPosition: const CameraPosition(
              zoom: 2.0,
              target: LatLng(30.16078301167607, 31.62501376459161),
            ),
          ),
          if (currentLatLong != null) ...[
            latLongTextWidget(),
          ]
        ],
      ),
    );
  }

  Positioned latLongTextWidget() {
    return Positioned(
      top: 10.0,
      left: 10.0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          child: Text(
            "Lat is :${currentLatLong!.latitude}\nLong is :${currentLatLong!.longitude}",
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
