import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map_app/constant/colors.dart';
import 'package:flutter_map_app/helper/location-helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({Key? key}) : super(key: key);

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  static Position? position;
  Completer<GoogleMapController> _mapController = Completer();
  late CameraPosition _myCurrentLocationCameraPosition;

  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.determinePosition();
    setState(() {
      _myCurrentLocationCameraPosition = CameraPosition(
        target: LatLng(position!.latitude, position!.longitude),
        bearing: 0.0,
        tilt: 0.0,
        zoom: 17,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getMyCurrentLocation();
  }

  Widget buildMap() {
    return GoogleMap(
      initialCameraPosition: _myCurrentLocationCameraPosition,
      mapType: MapType.satellite,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 8, 3),
          child: FloatingActionButton(
            onPressed: _goToMyCurrentLocation,
            backgroundColor: MyColors.blue,
            child: const Icon(Icons.place, color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            position != null
                ? buildMap()
                : const Center(child: CircularProgressIndicator(color: MyColors.blue)),
          ],
        ),
      ),
    );
  }
}
