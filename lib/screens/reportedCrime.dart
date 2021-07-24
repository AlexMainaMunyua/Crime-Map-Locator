import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:crime_map/shared_widgets/shared_widgets.dart';

import 'package:flutter/material.dart';

class ReportedCrime extends StatefulWidget {
  const ReportedCrime({Key? key}) : super(key: key);

  @override
  _ReportedCrimeState createState() => _ReportedCrimeState();
}

class _ReportedCrimeState extends State<ReportedCrime>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  AnimationController? _addCrimeController;
  Duration _duration = Duration(seconds: 2);
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
      resizeToAvoidBottomInset: false,
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
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            MyGoogleMap(),
            getAddCrimeDraggableWidget(),
            getAddCrimeLocationWidget()
          ],
        ),
      ),
    );
  }

  Widget getAddCrimeDraggableWidget() {
    double min = 0.0, initial = 0.13, max = 0.13;
    Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_controller!),
        child: DraggableScrollableSheet(
          minChildSize:
              min, // 0.1 times of available height, sheet can't go below this on dragging
          maxChildSize:
              max, // 0.7 times of available height, sheet can't go above this on dragging
          initialChildSize:
              initial, // 0.1 times of available height, sheet start at this size when opened for first time
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
        _addCrimeController!.forward();
      } else {
        print('No image selected.');
        _controller!.forward();
      }
    });
  }

 Widget getAddCrimeLocationWidget() {
    double min = 0, initial = 0.88, max = 0.88;
    Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_addCrimeController!),
        child: DraggableScrollableSheet(
          minChildSize:
              min, // 0.1 times of available height, sheet can't go below this on dragging
          maxChildSize:
              max, // 0.7 times of available height, sheet can't go above this on dragging
          initialChildSize:
              initial, // 0.1 times of available height, sheet start at this size when opened for first time
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
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          margin: EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Config().darkGradientShadecolor,
                              ),
                              focusColor: Theme.of(context).primaryColor,
                              hintText: "Location",
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            _addCrimeController!.reverse();
                            _controller!.forward();
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
}



