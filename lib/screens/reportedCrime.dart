import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  AnimationController? _controller;
  AnimationController? _addCrimeController;

  Duration _duration = Duration(seconds: 2);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  double? min = 0.0, initial = 0.13, max = 0.13;
  File? file;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _addCrimeController = AnimationController(vsync: this, duration: _duration);
    _addCrimeController!.reverse();
    _controller!.forward();
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
      // floatingActionButton: GestureDetector(
      //   child: FloatingActionButton(
      //     child: AnimatedIcon(
      //         icon: AnimatedIcons.menu_close, progress: _controller!),
      //     elevation: 5,
      //     backgroundColor: Colors.deepOrange,
      //     foregroundColor: Colors.white,
      //     onPressed: () async {
      //       if (_controller!.isDismissed)
      //         _controller!.forward();
      //       else if (_controller!.isCompleted) _controller!.reverse();
      //     },
      //   ),
      // ),
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
                        return Card(
                          color: Colors.white,
                          elevation: 12.0,
                          margin: const EdgeInsets.all(0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 12),
                                Container(
                                  height: 5,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                ),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () async {
                                    _controller!.reverse();
                                    takeImage(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    margin: EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          child: Icon(Icons.add_outlined,
                                              size: 30, color: Colors.black54),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                        ),
                                        SizedBox(width: 8),
                                        Text("Add a place of crime",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87)),
                                      ],
                                    ),
                                  ),
                                ),
                                // SizedBox(height: 10),
                              ],
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

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Crime Image",
              style: TextStyle(
                  color: Config().darkGradientShadecolor,
                  fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  pickPhotofromGallary();
                },
                child: Row(
                  children: [
                    Icon(Icons.photo_album, color: Colors.black26),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Select from Gallery",
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _controller!.forward();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      " Cancel",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  pickPhotofromGallary() async {
    Navigator.pop(context);

    final picker = ImagePicker();

    final imageFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (imageFile != null) {
        file = File(imageFile.path);
        _controller!.forward();
      } else {
        print('No image selected.');
        _controller!.forward();
      }
    });
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
