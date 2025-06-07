import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map/common/errors/google_map_exception.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

import '../../main.dart';

abstract class LocationServices {
  static Location location = Location();

  static String myLocationKey = "my_location_maraker";

  static String? nightStyle;

  static Uint8List? unit8listOfNewImage;

  static isDenied(PermissionStatus permissionStatus) =>
      permissionStatus == PermissionStatus.denied ||
      permissionStatus == PermissionStatus.deniedForever;

  static isGranted(PermissionStatus permissionStatus) =>
      permissionStatus == PermissionStatus.granted ||
      permissionStatus == PermissionStatus.grantedLimited;

  static Future<void> checkLocationServicesAndPermission() async {
    try {
      await checkLocationServerEnabled();
      await checkLocationPermission();
    } on GoogleMapServicesException catch (e) {
      log("GoogleMap Services Exception");
    } on GoogleMapPermissionException catch (e) {
      log("GoogleMap Permission Exception");
    } catch (e) {
      log("Exception while checkLocationServicesAndPermission");
    }
  }

  static Future<void> checkLocationServerEnabled() async {
    var currentServicesStatus = await location.serviceEnabled();
    if (currentServicesStatus == false) {
      currentServicesStatus = await location.requestService();

      if (currentServicesStatus == false) {
        throw GoogleMapServicesException();
      }
    }
  }

  static Future<void> checkLocationPermission() async {
    var currentLocationPermission = await location.hasPermission();
    if (isDenied(currentLocationPermission)) {
      currentLocationPermission = await location.requestPermission();
      if (isDenied(currentLocationPermission)) {
        throw GoogleMapPermissionException();
      }
    }
  }

  static initMapStyle() async {
    nightStyle = await DefaultAssetBundle.of(navigatorKey.currentContext!)
        .loadString('assets/map_style.json');
    // _googleMapController.setMapStyle(nightStyle); // controller لل init لانك كدا استخدمت و لازم نعمل onMapCreate اذا استخدمت الطريقة دي لازم تنده النافنكش كلها في ال
  }

  static locationSetting() {
    location.changeSettings(distanceFilter: 4);
  }

  static Future<BytesMapBitmap> iconMap() async {
    return BitmapDescriptor.bytes(
      unit8listOfNewImage == null ? await getImage() : unit8listOfNewImage!,
    );
  }

  static Future<Uint8List> getImage() async {
    // we use this way if icon map come from backend .. .
    log("Get Image");
    final image = await rootBundle.load("assets/pin.png");
    final newImage = await ui.instantiateImageCodec(
      image.buffer.asUint8List(),
      targetHeight: 40,
      // targetWidth: 40
    );

    final newImageDataAfterEdit = await newImage.getNextFrame();

    final converNewImageDataAfterToDataByte = await newImageDataAfterEdit.image
        .toByteData(format: ui.ImageByteFormat.png);

    unit8listOfNewImage =
        converNewImageDataAfterToDataByte!.buffer.asUint8List();

    return unit8listOfNewImage!;
  }

  static Future<LocationData> getUserLocation() async {
    return await location.getLocation();
  }
}
