import 'dart:io';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crime_map/shared_widgets/shared_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';

class ReportedCrime extends StatefulWidget {
  const ReportedCrime({Key? key}) : super(key: key);

  @override
  _ReportedCrimeState createState() => _ReportedCrimeState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _ReportedCrimeState extends State<ReportedCrime>
    with TickerProviderStateMixin {
  
  final crimeRef = FirebaseFirestore.instance.collection('crime');
  AnimationController? _controller;
  AnimationController? _addCrimeController;
  Duration? _duration = Duration(seconds: 2);
  File? file;
  Location location = Location();
  LocationData? _currentPosition;
  String? _address;
  int reportNumber = 1;
  LatLng _initialcameraposition = LatLng(-1.1, 35.135);
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String? downloadUrlLink;
  int _current = 0;
  final CarouselController _carouselController = CarouselController();

  List<Marker> allMarker = [];

  String crimeId = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    myMarker();
    _controller = AnimationController(vsync: this, duration: _duration!);
    _addCrimeController =
        AnimationController(vsync: this, duration: _duration!);
    _addCrimeController!.reverse();
    _controller!.forward();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: myAppBar(),
      drawer: DrawerWidget(),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            myMap(),
            getAddCrimeDraggableWidget(),
            getAddCrimeLocationWidget()
          ],
        ),
      ),
    );
  }

  // My appBar widget
  myAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Config().darkGradientShadecolor),
      centerTitle: true,
      title: Container(
        child: Text(
          '$_address',
          style: TextStyle(fontSize: 15),
        ),
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Config().lightGradientShadecolor),
      ),
    );
  }

  // My map
  Widget myMap() {
    return GoogleMap(
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
        });
      },
      markers: Set<Marker>.of(markers.values),
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(
        target: _initialcameraposition,
        zoom: 10.0,
      ),
    );
  }

 //identify each marker id and data 
  myMarker() {
    FirebaseFirestore.instance.collection('crime').get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; i++) {
          initMarker(docs.docs[i].data(), docs.docs[i].id);
        }
      }
    });
  }

  // initialize each marker
  void initMarker(mData, mId) {
    var markerIdVal = mId;
    var markerData = mData;
    print(markerIdVal);
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
        markerId: markerId,
        draggable: false,
        onTap: () => fetchMarkerImages(markerData),
        icon: selectIcon(mData['reportNumber']),
        position: LatLng(mData['latitude'], mData['longitude']));

    setState(() {
      markers[markerId] = marker;
    });
  }

  // Marker Icon Color
  selectIcon(int reportNumber) {
    var number = reportNumber;
    if (number <= 5) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else if (number > 5 && number <= 20) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  //Fetch Marker Images
  fetchMarkerImages(mData) {
    List list = mData['crimeImage'];

    return showDialog(
        context: context,
        builder: (context) {
          return Container(
              child: CarouselSlider(
            items: list
                .map((image) => Container(
                      margin: EdgeInsets.only(bottom: 6.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                              image: NetworkImage(image), fit: BoxFit.fill)),
                    ))
                .toList(),
            carouselController: _carouselController,
            options: CarouselOptions(
                aspectRatio: 16 / 9,
                height: 200,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.95,
                enlargeCenterPage: true,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ));
        });
  }

  // get addCrimeDragrabble widget.
  Widget getAddCrimeDraggableWidget() {
    double min = 0.0, initial = 0.13, max = 0.13;
    Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_controller!),
        child: DraggableScrollableSheet(
          minChildSize:
              min, // 0.0 times of available height, sheet can't go below this on dragging
          maxChildSize:
              max, // 0.13 times of available height, sheet can't go above this on dragging
          initialChildSize:
              initial, // 0.13 times of available height, sheet start at this size when opened for first time
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
                            margin: EdgeInsets.only(left: 15.0, right: 15.0),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01),
                                Container(
                                  height: 30,
                                  width: 30,
                                  child: Icon(Icons.add_outlined,
                                      size: 30, color: Colors.black54),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(16)),
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
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // take image dialog box
  takeImage(mContext) {
    return showDialog(
        barrierDismissible: false,
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
                      width: 13,
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
                      width: 13,
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

  // Pick photo from the Gallary
  pickPhotofromGallary() async {
    Navigator.pop(context);

    final picker = ImagePicker();

    final imageFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (imageFile != null) {
        file = File(imageFile.path);
        getLocation();
        _addCrimeController!.forward();
      } else {
        print('No image selected.');
        _controller!.forward();
      }
    });
  }

  // Get user's location
  getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissonStatus;

    // check if permission to access location is allowed.
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissonStatus = await location.hasPermission();

    if (_permissonStatus == PermissionStatus.denied) {
      _permissonStatus = await location.requestPermission();
      if (_permissonStatus != PermissionStatus.granted) {
        return;
      }
    }

    // Initialize the currect location of the user.
    _currentPosition = await location.getLocation();

    _initialcameraposition =
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);

        _getAddress(_currentPosition!.latitude!, _currentPosition!.longitude!)
            .then((value) {
          setState(() {
            _address = "${value.first.addressLine}";
          });
        });
      });
    });
  }

  // Get the address of user's location.
  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }

  // A widget to add crime location.
  Widget getAddCrimeLocationWidget() {
    double min = 0, initial = 0.58, max = 0.58;
    Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_addCrimeController!),
        child: DraggableScrollableSheet(
          minChildSize:
              min, // 0.0 times of available height, sheet can't go below this on dragging
          maxChildSize:
              max, // 0.58 times of available height, sheet can't go above this on dragging
          initialChildSize:
              initial, // 0.58 times of available height, sheet start at this size when opened for first time
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
                        Row(
                          children: [
                            Container(
                              child: IconButton(
                                  onPressed: () {
                                    _addCrimeController!.reverse();
                                    _controller!.forward();
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    size: 30,
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.width * 0.80,
                          decoration: BoxDecoration(
                              // color: Colors.green,
                              image: DecorationImage(
                                  image: FileImage(file!), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        SizedBox(height: 20),
                        if (_currentPosition != null)
                          Text(
                              "Latitude: ${_currentPosition!.latitude!}, Longitude: ${_currentPosition!.longitude!}"),
                        SizedBox(
                          height: 3,
                        ),
                        if (_address != null) Text("Address: $_address"),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            _addCrimeController!.reverse();
                            _controller!.forward();
                            await uploadImageAndSaveCrimeLocationInfo();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "Congratulation! Your crime location is successfully added",
                              textAlign: TextAlign.center,
                            )));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.80,
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                                color: Config().lightGradientShadecolor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text("Confirm",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Upload image and save location's information
  uploadImageAndSaveCrimeLocationInfo() async {
    String imageDownloadUrl = await uploadCrimeImage(file);

    setState(() {
      downloadUrlLink = imageDownloadUrl;
    });

    saveCrimeData();
  }

  // upload crime image
  Future<String> uploadCrimeImage(mFileImage) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('crime');

    TaskSnapshot taskSnapshot =
        await storageReference.child("crime_$crimeId.jpg").putFile(mFileImage);

    var downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  // Filter whether the crimelocaton exist or not.
  saveCrimeData() async {
    final QuerySnapshot result = await crimeRef.get();

    final List<DocumentSnapshot> documents = result.docs;

    if ((documents.singleWhereOrNull((element) =>
            element.id.toString() ==
            _currentPosition!.verticalAccuracy!.truncate().toString())) !=
        null) {
      // add image to list.
      addImageToList(_currentPosition!.verticalAccuracy!.truncate().toString());
      //increae the number of reports.
      increamentReportNumber(
          _currentPosition!.verticalAccuracy!.truncate().toString());
    } else {
      // set Data
      saveCrimeLocation();
    }
  }

  // Set data to firestore.
  saveCrimeLocation() {
    crimeRef
        .doc(_currentPosition!.verticalAccuracy!.truncate().toString())
        .set({
      "latitude": _currentPosition!.latitude,
      "longitude": _currentPosition!.longitude,
      "reportNumber": reportNumber,
      "crimeImage": [downloadUrlLink],
    });
    setState(() {
      file = null;
      crimeId = DateTime.now().millisecondsSinceEpoch.toString();
    });

    // add image to list.
    // addImageToList(crimeId);
  }

  // Add an image.
  addImageToList(id) {
    var crimeIdVal = id;
    DocumentReference documentReference = crimeRef.doc(crimeIdVal);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Document does not exist!");
      }

      List newImage = snapshot.get('crimeImage');

      newImage.add(downloadUrlLink);

      transaction.update(documentReference, {'crimeImage': newImage});

      return newImage;
    });
  }

  //increment crime report number.
  increamentReportNumber(id) async {
    var crimeIdVal = id;
    DocumentReference documentReference = crimeRef.doc(crimeIdVal);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Document does not exist!");
      }

      int newReport = snapshot.get('reportNumber') + 1;

      transaction.update(documentReference, {'reportNumber': newReport});

      return newReport;
    });
  }
}
