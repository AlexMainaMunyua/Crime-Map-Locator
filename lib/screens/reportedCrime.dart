import 'package:crime_map/shared_widgets/shared_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';

class ReportedCrime extends StatelessWidget {
  const ReportedCrime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late GoogleMapController mapController;

    final LatLng _center = const LatLng(45.521563, -122.677433);

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.red,
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
              EdgeInsets.only(left: 20.0, right: 20.0, top: 3.0, bottom: 3.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Config().lightGradientShadecolor),
        ),
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Drawer(
          child: DrawerWidget(),
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(
      //     Icons.my_location_sharp,
      //     color: Config().darkGradientShadecolor,
      //   ),
      //   backgroundColor: Colors.white,
      //   onPressed: () {},
      // ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(),
    );
  }
}
