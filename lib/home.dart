import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'model/place_model.dart';

import 'dart:ui' as ui;

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late CameraPosition cameraPosition;

  late GoogleMapController _googleMapController;
  String? nightStyle;

  Set<Marker> markers = {};

  Set<Polyline> lines = {};

  Set<Polygon> polygons = {};

  Set<Circle> circles = {};

  CameraTargetBounds cameraTargetBounds = CameraTargetBounds(
    LatLngBounds(
      northeast: const LatLng(30.120558505675778, 31.31808364739569),
      southwest: const LatLng(30.107614649251147, 31.29316734517162),
    ),
  );

  List<PlaceModel> places = [
    PlaceModel(
      id: "1",
      name: "Alphabet arabic academy",
      postion: const LatLng(30.162044459866223, 31.62450563927859),
    ),
    PlaceModel(
      id: "2",
      name: "syana tech",
      postion: const LatLng(30.16078301167607, 31.62501376459161),
    ),
    PlaceModel(
      id: "3",
      name: "أخصائي تخاطب",
      postion: const LatLng(30.160591618126784, 31.622176312348625),
    ),
    PlaceModel(
      id: "4",
      name: "الجامعة العربية المفتوحة",
      postion: const LatLng(30.155635964340465, 31.61306319566857),
    ),
  ];

  @override
  void initState() {
    super.initState();
    cameraPosition = const CameraPosition(
      zoom: 2.0,
      target: LatLng(30.11409771124938, 31.308710840796778),
    );
    initMapStyle();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initMarks();
      setState(() {});
      Future.delayed(
        const Duration(seconds: 2),
        () {
          newLocation();
          initLines();
          initPolygon();
          initCircles();
          setState(() {});
        },
      );
    });
  }

  newLocation() {
    _googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(places.first.postion, 13.0),
      // CameraUpdate.newLatLng(
      //   const LatLng(30.116758354354467, 31.41720120394772),
      // ),
      // CameraUpdate.newCameraPosition(cameraPosition),
      // CameraUpdate.zoomIn()
      // CameraUpdate.zoomOut()
    );
    setState(() {});
  }

  initMapStyle() async {
    nightStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    // ignore: deprecated_member_use
    // _googleMapController.setMapStyle(nightStyle); // controller لل init لانك كدا استخدمت و لازم نعمل onMapCreate اذا استخدمت الطريقة دي لازم تنده النافنكش كلها في ال

    setState(() {});
  }

  Future<Uint8List> getImage() async {
    final image = await rootBundle.load("assets/pin.png");
    final newImage = await ui.instantiateImageCodec(
      image.buffer.asUint8List(),
      targetHeight: 40,
      // targetWidth: 40
    );

    final newImageDataAfterEdit = await newImage.getNextFrame();

    final converNewImageDataAfterToDataByte = await newImageDataAfterEdit.image
        .toByteData(format: ui.ImageByteFormat.png);

    final unit8listOfNewImage =
        converNewImageDataAfterToDataByte!.buffer.asUint8List();

    return unit8listOfNewImage;
  }

  void initMarks() async {
    // final icon = BitmapDescriptor.asset(ImageConfiguration(), "assets/pin.png"); //و تعدل عليها من اي موقع عشان تناسب التطبيق assets هتسخدم دي في حالة ان الصورة موجوده عندك في ال
    final icon = BitmapDescriptor.bytes(
        await getImage()); // في حال الصورة جايه من الباك انيد
    for (var i = 0; i < places.length; i++) {
      markers.add(
        Marker(
            markerId: MarkerId("$i"),
            icon: icon,
            infoWindow:
                InfoWindow(title: places[i].name, snippet: places[i].id),
            position: places[i].postion),
      );
    }
  }

  void initLines() {
    final list = places.map((e) => e.postion).toList();
    list.removeLast();
    lines.add(
      Polyline(
        polylineId: const PolylineId("1"),
        startCap: Cap.roundCap,
        width: 5,
        points: list,
      ),
    );
  }

  void initPolygon() {
    polygons.add(
      Polygon(
        polygonId: const PolygonId("1"),
        points: const [
          LatLng(30.17564569397183, 31.638605921133408),
          LatLng(30.166540261753887, 31.614734923473776),
          LatLng(30.15285084473665, 31.626496446620752),
        ],
        fillColor: Colors.blue.withOpacity(.2),
        strokeColor: Colors.white,
        strokeWidth: 2,
        holes: const [
          [
            LatLng(30.168239898126295, 31.63204275272459),
            LatLng(30.166998016332194, 31.62576051790542),
            LatLng(30.162688714799767, 31.62970638440341),
          ],
        ],
      ),
    );
  }

  void initCircles() {
    circles.add(
      Circle(
        circleId: const CircleId("1"),
        center: const LatLng(30.155230988122717, 31.612877687767547),
        fillColor: Colors.green.withOpacity(.2),
        radius: 800,
        strokeColor: Colors.white,
        strokeWidth: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        polylines: lines,
        markers: markers,
        style: nightStyle,
        polygons: polygons,
        circles: circles,
        onMapCreated: (controller) {
          _googleMapController = controller;
        },
        // cameraTargetBounds: cameraTargetBounds,
        initialCameraPosition: cameraPosition,
      ),
    );
  }
}
