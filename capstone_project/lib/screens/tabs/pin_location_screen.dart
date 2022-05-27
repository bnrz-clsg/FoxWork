import 'dart:async';
import 'package:capstone_project/dataprovider/appdata.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/utils/strings.dart';
import 'package:capstone_project/widgets/preogressDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CurrentLocation extends StatefulWidget {
  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  PageController _pageController;

  var geolocator = Geolocator();
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

// map Style
  String _darkMapStyle;

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    controller.setMapStyle(_darkMapStyle);
  }
//end map style

// <Show Current postion on the map>
  void setupPositionLocator() async {
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 18, tilt: 90);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    String address =
        await HelperMethods.findCordinateAddress(position, context);
  }

  void _onmMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
    _setMapStyle();
    setupPositionLocator();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadMapStyles();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (googlePlexOne != null)
          ? Stack(children: <Widget>[
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      mapToolbarEnabled: false,
                      // compassEnabled: false,
                      zoomGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      initialCameraPosition: googlePlexOne,
                      onMapCreated: _onmMapCreated,
                    ),
                  ),
                ],
              ),

              //<Search Panel, Search Prediction> not needed to be remove

              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //information view
                        SizedBox(height: 5.0),
                        Text(
                          AppContent.nicetoseeyou,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/icon_logo.png',
                              height: 43.0,
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppContent.currentLocation,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[400],
                                        letterSpacing: 1.5),
                                  ),
                                  Text(
                                    (Provider.of<AppData>(context)
                                                .pickupAddress !=
                                            null)
                                        ? Provider.of<AppData>(context)
                                            .pickupAddress
                                            .placeName
                                        : 'current location',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: false,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Brand-Regular',
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //<loading waiting for open house shelter>
            ])
          : ProgressDialog(),
    );
  }
}
