import 'dart:developer';

import 'package:location/location.dart';

abstract class LocationServices {
  static Location location = Location();

  static isDenied(PermissionStatus permissionStatus) =>
      permissionStatus == PermissionStatus.denied ||
      permissionStatus == PermissionStatus.deniedForever;

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
}
