import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'route_track/route_track.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RouteTrackScreen(),
    );
  }
}


// LatLngBounds getLatLngBounds(List<LatLng> points) {
//     var southWestLatitude = points.first.latitude;
//     var southWestLongitude = points.first.longitude;
//     var northEastLatitude = points.first.latitude;
//     var northEastLongitude = points.first.longitude;

//     for (var point in points) {
//       southWestLatitude = min(southWestLatitude, point.latitude);
//       southWestLongitude = min(southWestLongitude, point.longitude);
//       northEastLatitude = max(northEastLatitude, point.latitude);
//       northEastLongitude = max(northEastLongitude, point.longitude);
//     }

//     return LatLngBounds(
//         southwest: LatLng(southWestLatitude, southWestLongitude),
//         northeast: LatLng(northEastLatitude, northEastLongitude));
//   }

