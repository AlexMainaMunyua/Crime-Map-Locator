import 'package:crime_map/screens/screens.dart';
import 'package:crime_map/shared_widgets/shared_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';

class ReportedCrime extends StatefulWidget {
  const ReportedCrime({Key? key}) : super(key: key);

  @override
  _ReportedCrimeState createState() => _ReportedCrimeState();
}

class _ReportedCrimeState extends State<ReportedCrime>
    with SingleTickerProviderStateMixin {
  // Location _location = Location();
  // String? _mapStyle;

  // LatLng _currentMapPosition;

  // void _onAddMarkerButtonPressed() {
  //   setState(() {
  //     _markers.add(Marker(
  //       markerId: MarkerId(_currentMapPosition.toString()),
  //       position: _currentMapPosition,
  //       infoWindow:
  //           InfoWindow(title: 'Nice Place', snippet: 'Welcome to Poland'),
  //       icon: BitmapDescriptor.defaultMarker,
  //     ));
  //   });
  // }

  // void _onCameraMove(CameraPosition position) {
  //   _currentMapPosition = position.target;
  // }

  // void _onCamereMoveToMyLocation(GoogleMapController controller) {
  //   mapController = controller;

  //   _location.onLocationChanged.listen((event) {
  //     mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //         target: LatLng(event.latitude!, event.longitude!), zoom: 15)));
  //   });
  // }

  AnimationController? _controller;
  BorderRadiusTween? borderRadius;
  Duration _duration = Duration(milliseconds: 500);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  double? _height, min = 0.1, initial = 0.3, max = 0.7;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    borderRadius = BorderRadiusTween(
      begin: BorderRadius.circular(75.0),
      end: BorderRadius.circular(0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Config().darkGradientShadecolor),
        centerTitle: true,
        title: Container(
          child: Text(
            'Narok',
            style: TextStyle(fontSize: 15),
          ),
          padding:
              EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Config().lightGradientShadecolor),
        ),
      ),
      drawer: DrawerWidget(),
      floatingActionButton: GestureDetector(
        child: FloatingActionButton(
          child: AnimatedIcon(
              icon: AnimatedIcons.menu_close, progress: _controller!),
          elevation: 5,
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          onPressed: () async {
            if (_controller!.isDismissed)
              _controller!.forward();
            else if (_controller!.isCompleted) _controller!.reverse();
          },
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            MyGoogleMap(),
            SizedBox.expand(
              child: SlideTransition(
                position: _tween.animate(_controller!),
                child: DraggableScrollableSheet(
                  minChildSize:
                      min!, // 0.1 times of available height, sheet can't go below this on dragging
                  maxChildSize:
                      max!, // 0.7 times of available height, sheet can't go above this on dragging
                  initialChildSize:
                      initial!, // 0.1 times of available height, sheet start at this size when opened for first time
                  builder: (BuildContext context, ScrollController controller) {
                    return AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: borderRadius!.evaluate(CurvedAnimation(
                              parent: _controller!, curve: Curves.bounceIn)),
                          child: Card(
                            color: Colors.white,
                            elevation: 12.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: CustomInnerContent(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );






















    
    // return Scaffold(
    //     extendBodyBehindAppBar: true,
    //     backgroundColor: Colors.white,
    //     appBar: AppBar(
    //       backgroundColor: Colors.transparent,
    //       elevation: 0,
    //       iconTheme: IconThemeData(color: Config().darkGradientShadecolor),
    //       centerTitle: true,
    //       title: Container(
    //         child: Text(
    //           'Narok',
    //           style: TextStyle(fontSize: 15),
    //         ),
    //         padding:
    //             EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(20),
    //             color: Config().lightGradientShadecolor),
    //       ),
    //     ),
    //     drawer: DrawerWidget(),
    //     body: SizedBox.expand(

    //         child: Stack(
    //         children: <Widget>[
    //           MyGoogleMap(),
    //           SizedBox.expand(
    //             child: SlideTransition(
    //               position: _tween.animate(_controller!),
    //               child: AddCrimePage()))

    //         ],
    //       ),
    //     )
    //     // floatingActionButton: FloatingActionButton(
    //     //   child: Icon(
    //     //     Icons.my_location_sharp,
    //     //     color: Config().darkGradientShadecolor,
    //     //   ),
    //     //   backgroundColor: Colors.white,
    //     //   onPressed: () {},
    //     // )
    //     // onPressed: () => _onAddMarkerButtonPressed),
    //     );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Drawer(),
    );
  }
}

class MyGoogleMap extends StatefulWidget {
  const MyGoogleMap({Key? key}) : super(key: key);

  @override
  _MyGoogleMapState createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-1.1, 35.135);
  final Set<Marker> _markers = Set();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
        });
      },
      markers: this.myMarker(),
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 10.0,
      ),
    );
  }

  Set<Marker> myMarker() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_center.toString()),
        draggable: true,
        position: _center,
        infoWindow: InfoWindow(
          title: 'Historical City',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    return _markers;
  }
}
