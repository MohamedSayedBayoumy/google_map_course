import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

abstract class LocationServices {
  static Location location = Location();

  static String myLocationKey = "my_location_maraker";

  static String? nightStyle;

  static isDenied(PermissionStatus permissionStatus) =>
      permissionStatus == PermissionStatus.denied ||
      permissionStatus == PermissionStatus.deniedForever;

  static isGranted(PermissionStatus permissionStatus) =>
      permissionStatus == PermissionStatus.granted ||
      permissionStatus == PermissionStatus.grantedLimited;

  static Future<PermissionStatus?> checkLocationServicesAndPermission() async {
    final locationServicesStatus = await checkLocationServerEnabled();
    if (locationServicesStatus == true) {
      return checkLocationPermission();
    }
    return null;
  }

  static Future<bool> checkLocationServerEnabled() async {
    var currentServicesStatus = await location.serviceEnabled();
    if (currentServicesStatus == false) {
      currentServicesStatus = await location.requestService();

      if (currentServicesStatus == true) {
        log("Location Server become enabled");
        return true;
      } else {
        log("Location Server become disabled");
        return false;
      }
    } else {
      log("Location Server was enabled");

      return true;
    }
  }

  static Future<PermissionStatus> checkLocationPermission() async {
    var currentLocationPermission = await location.hasPermission();
    if (isDenied(currentLocationPermission)) {
      currentLocationPermission = await location.requestPermission();
      if (!isDenied(currentLocationPermission)) {
        log("Location Permission become granted");
        return currentLocationPermission;
      } else {
        log("Location Permission become $currentLocationPermission");
        return currentLocationPermission;
      }
    } else {
      log("Location Permission was granted");
      return currentLocationPermission;
    }
  }

  static initMapStyle(BuildContext context) async {
    nightStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    // _googleMapController.setMapStyle(nightStyle); // controller لل init لانك كدا استخدمت و لازم نعمل onMapCreate اذا استخدمت الطريقة دي لازم تنده النافنكش كلها في ال
  }
}
