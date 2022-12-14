import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_api_login/providers/auth.dart';
import 'package:rest_api_login/screens/login_Screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rest_api_login/utils/geo_location.dart';
import 'package:http/http.dart';

class HomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  LatLng currentPosition;

  var currentLocation;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  _getUserLocation() async {
    currentLocation = await new locationServices().determinePosition();
    setState(() {
      currentPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
    print('$currentPosition');
  } 

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition( //innital position in map
                    target: LatLng(currentPosition.latitude, currentPosition.longitude) , //initial position
                    zoom: 14.0, //initial zoom level
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('source'),
                      position: currentPosition
                    ),
                  },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed("/");
          Provider.of<Auth>(context, listen: false).logout();
        },
        label: Text('Logout'),
        icon: Icon(Icons.logout),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
