import 'dart:async';
import 'package:capstone_project/models/nearbyShelter.dart';
import 'package:capstone_project/services/firehelpers.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/widgets/preogressDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActiveRescuerScreen extends StatefulWidget {
  @override
  _ActiveRescuerScreenState createState() => _ActiveRescuerScreenState();
}

class _ActiveRescuerScreenState extends State<ActiveRescuerScreen> {
  Completer<GoogleMapController> _controller = Completer();

  // ignore: non_constant_identifier_names
  Set<Marker> _Markers = {};
  // ignore: non_constant_identifier_names
  Set<Circle> _Circles = {};
  GoogleMapController mapController;
  var geoLocator = Geolocator();

// online shelter ICon
  BitmapDescriptor nearbyIcon;
  DatabaseReference shelterRef;

  bool nearbySheltersKeysLoad = false;

  List<NearbyShelter> availableRescuer;

  void setupPositionLocator() async {
    Position position = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 12);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    startGeofireListener();
  }

  // map Style
  String _darkMapStyle;

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    controller.setMapStyle(_darkMapStyle);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;

    _setMapStyle();
    setupPositionLocator();
  }

// nearbysheltyer Icon
  void createMarker() {
    if (nearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/nearbyIcon.png')
          .then((icon) {
        nearbyIcon = icon;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
    _loadMapStyles();
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: (googlePlexOne != null)
            ? Stack(children: <Widget>[
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        mapToolbarEnabled: false,
                        zoomGesturesEnabled: false,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                        initialCameraPosition: googlePlexOne,
                        markers: _Markers,
                        circles: _Circles,
                        onMapCreated: _onMapCreated,
                      ),
                    ),
                  ],
                ),
              ])
            : ProgressDialog(),
      ),
    );
  }

//<view all active shelter on map>
  void startGeofireListener() {
//start viewing all nearby shelter into map with the existing range of 20 kilometers
//view all data from firebasedatabse table 'sheltersAvailable
    Geofire.initialize('sheltersAvailable');
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 20)
        .listen((map) {
//      print(map);

      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyShelter nearbyShelter = NearbyShelter();
            nearbyShelter.key = map['key'];
            nearbyShelter.latitude = map['latitude'];
            nearbyShelter.longitude = map['longitude'];
            FireHelper.nearbyShelterList.add(nearbyShelter);

            if (nearbySheltersKeysLoad) {
              updateShleteronMap();
            }
            break;

          case Geofire.onKeyExited:
            FireHelper.removeFromList(map['key']);
            updateShleteronMap();
            break;

          case Geofire.onKeyMoved:
            // Update your key's location
            NearbyShelter nearbyShelter = NearbyShelter();
            nearbyShelter.key = map['key'];
            nearbyShelter.latitude = map['latitude'];
            nearbyShelter.longitude = map['longitude'];
            FireHelper.updateNearbyLocation(nearbyShelter);
            updateShleteronMap();

            break;

          case Geofire.onGeoQueryReady:
            nearbySheltersKeysLoad = true;
            updateShleteronMap();
            break;
        }
      }
    });
    // setState(() {});
  }

//this method will view list of active rescuer
  void updateShleteronMap() {
    setState(() {
      _Markers.clear();
    });
    Set<Marker> tempMarkers = Set<Marker>();
    for (NearbyShelter shelter in FireHelper.nearbyShelterList) {
      LatLng shelterPosition = LatLng(shelter.latitude, shelter.longitude);

      Marker thisMarker = Marker(
        markerId: MarkerId('shelter${shelter.key}'),
        position: shelterPosition,
        icon: nearbyIcon,
        rotation: HelperMethods.generateRandomNumber(360),
      );
      tempMarkers.add(thisMarker);
    }

    setState(() {
      _Markers = tempMarkers;
    });
  }
}
