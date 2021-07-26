// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MyGoogleMap extends StatefulWidget {
//   const MyGoogleMap({Key? key}) : super(key: key);

//   @override
//   _MyGoogleMapState createState() => _MyGoogleMapState();
// }

// class _MyGoogleMapState extends State<MyGoogleMap> {
//   late GoogleMapController mapController;

//   final LatLng _center = const LatLng(-1.1, 35.135);
//   final Set<Marker> _markers = Set();

//   @override
//   Widget build(BuildContext context) {

//     return GoogleMap(
//       onMapCreated: (controller) {
//         setState(() {
//           mapController = controller;
//         });
//       },
//       // markers: this.myMarker(),
//       zoomControlsEnabled: false,
//       initialCameraPosition: CameraPosition(
//         target: _center,
//         zoom: 10.0,
//       ),
//     );
//   }

//   Set<Marker> myMarker() {
//     setState(() {
//       _markers.add(Marker(
//         // This marker id can be anything that uniquely identifies each marker.
//         markerId: MarkerId(_center.toString()),
//         draggable: true,
//         position: _center,
//         infoWindow: InfoWindow(
//           title: 'Historical City',
//           snippet: '5 Star Rating',
//         ),
//         icon: BitmapDescriptor.defaultMarker,
//       ));
//     });

//     return _markers;
//   }
// }
