import 'dart:async';
import 'package:capstone_project/models/requestShelter.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/services/mapkithelper.dart';
import 'package:capstone_project/style/brandcolor.dart';
import 'package:capstone_project/widgets/preogressDialog.dart';
import 'package:capstone_project/widgets/rescuedsheet.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewRequestPage extends StatefulWidget {
  final RequestShelter requestShelter;
  NewRequestPage({this.requestShelter});
  @override
  _NewRequestPageState createState() => _NewRequestPageState();
}

class _NewRequestPageState extends State<NewRequestPage> {
  GoogleMapController rescueMapController;
  Completer<GoogleMapController> _controller = Completer();

// set destinatiuon
  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  var geolocator = Geolocator();
  var locationOpgions =
      LocationOptions(accuracy: LocationAccuracy.bestForNavigation);

  BitmapDescriptor movingMarkerIcon;

  Position myPosition;

  String status = 'accepted';

  String durationString = '';

  bool isRequestingDirection = false;

  String buttonTitle = 'ARRIVED';

  Color buttonColor = BrandColors.colorGreen;

  Timer timer;

  int durationCounter = 0;

  void createMarker() {
    if (movingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/rescuer_icon.png')
          .then((icon) {
        movingMarkerIcon = icon;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    acceptRequest();
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.13,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  myLocationEnabled: true,
                  circles: _circles,
                  markers: _markers,
                  polylines: _polylines,
                  initialCameraPosition: googlePlexOne,
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                    rescueMapController = controller;

                    var currentLatLng = LatLng(
                        currentPosition.latitude, currentPosition.longitude);
                    var pickLatLng = widget.requestShelter.pickup;
                    await getDirection(currentLatLng, pickLatLng);

                    getLocationUpdates();
                  },
                ),
              ),
            ],
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                width: double.infinity,
                color: Color.fromRGBO(14, 21, 38, .85),
                // ignore: deprecated_member_use
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // ignore: deprecated_member_use
                      RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(45)),
                        color: buttonColor,
                        // textColor: Colors.white,
                        child: Container(
                          height: 50,
                          width: 200,
                          child: Center(
                            child: Text(
                              buttonTitle,
                              style: TextStyle(
                                  fontFamily: 'Brand-Bold',
                                  fontSize: 18,
                                  color: Colors.white,
                                  letterSpacing: 2),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (status == 'accepted') {
                            status = 'ARRIVED';
                            shelterRequestRef.child('status').set(('arrived'));

                            setState(() {
                              buttonTitle = 'On-Rescue';
                              buttonColor = Colors.green;
                            });
                          } else if (status == 'ARRIVED') {
                            status = 'On-Rescue';
                            shelterRequestRef.child('status').set('on-rescue');

                            setState(() {
                              buttonTitle = 'END RESCUE';
                              buttonColor = Colors.red[900];
                            });

                            startTimer();
                          } else if (status == 'On-Rescue') {
                            endRescue();
                          }
                        }, // end on press
                      ),
                    ],
                  ),
                ),
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.only(
//                      topLeft: Radius.circular(30),
//                      topRight: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0,
                        spreadRadius: 0.8,
                        offset: Offset(0.7, 0.7))
                  ], color: Colors.white),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'estimated time: ' + durationString,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.blue,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.requestShelter.evacUsername,
                          style: TextStyle(
                              fontFamily: 'Brand-Bold',
                              fontSize: 15,
                              letterSpacing: 2),
                        ),
//                        Icon(
//                          Icons.phone,
//                          color: Colors.green,
//                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.pin_drop_outlined,
                            color: Colors.red, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text(widget.requestShelter.pickupAddress,
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//<Retrive the ID of shelter request>
  void acceptRequest() {
    String requestID = widget.requestShelter.requestID;
    shelterRequestRef = FirebaseDatabase.instance
        .reference()
        .child('shelterRequest/$requestID');

    shelterRequestRef.child('status').set('accepted');
    shelterRequestRef.child('rescuerName').set(currentSheltersInfo.fullname);
    shelterRequestRef.child('rescuerPhone').set(currentSheltersInfo.phone);
    shelterRequestRef.child('shelters_id').set(currentFirebaseUser.uid);
    // requestRef.child('path'

    Map locationMap = {
      'latitude': currentPosition.latitude.toString(),
      'longitude': currentPosition.longitude.toString(),
    };

    shelterRequestRef.child('rescuer_location').set(locationMap);

    DatabaseReference historyRef = FirebaseDatabase.instance
        .reference()
        .child('shelters/${currentFirebaseUser.uid}/history/$requestID');
    historyRef.set('true');
  }

  void getLocationUpdates() {
    LatLng oldPosition = LatLng(0, 0);

    rescuerPositionStream = geolocator
        .getPositionStream(locationOpgions)
        .listen((Position position) {
      myPosition = position;
      currentPosition = position;
      LatLng pos = LatLng(position.latitude, position.longitude);

      var rotation = MapKitHelpers.getMarkerRotation(oldPosition.latitude,
          oldPosition.longitude, pos.latitude, pos.longitude);

      Marker movingMarker = Marker(
        markerId: MarkerId('moving'),
        position: pos,
        icon: movingMarkerIcon,
        rotation: rotation,
        infoWindow: InfoWindow(title: 'Current Position'),
      );
      setState(() {
        CameraPosition cp = new CameraPosition(target: pos, zoom: 17, tilt: 90);
        rescueMapController.animateCamera(CameraUpdate.newCameraPosition(cp));

        _markers.removeWhere((marker) => marker.markerId.value == 'moving');
        _markers.add(movingMarker);
      });

      oldPosition = pos;

      updateRescueDetails();

      Map locationMap = {
        'latitude': myPosition.latitude.toString(),
        'longitude': myPosition.longitude.toString(),
      };
      shelterRequestRef.child('rescuers_location').set(locationMap);
    });
  }

  void updateRescueDetails() async {
    if (!isRequestingDirection) {
      isRequestingDirection = true;

      if (myPosition == null) {
        return;
      }

      var positionLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;

      if (status == 'accepted') {
        destinationLatLng = widget.requestShelter.pickup;
      } else {
        destinationLatLng = widget.requestShelter.destination;
      }

      var directionDetails = await HelperMethods.getDirectionDetails(
          positionLatLng, destinationLatLng);

      if (directionDetails != null) {
        print(directionDetails.durationText);

        setState(() {
          durationString = directionDetails.durationText;
        });
      }
      isRequestingDirection = false;
    }
  }

  Future<void> getDirection(
      LatLng pickupLatLng, LatLng destinationLatLng) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog());

    var thisDetails = await HelperMethods.getDirectionDetails(
        pickupLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polylineCoordinates.clear();
    if (result.isNotEmpty) {
      result.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }

    _polylines.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polylines.add(polyline);
    });

//this will ensure the draw line is fit inside the map screen
    LatLngBounds bounds;
    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
      );
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
        northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds =
          LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }
    rescueMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });
    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: Colors.green,
    );
    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: Colors.purple,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: Colors.purple,
    );
    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }

  void startTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter++;
    });
  }

  void endRescue() async {
    timer.cancel();

    HelperMethods.showProgressDialog(context);
    Navigator.pop(context);

    shelterRequestRef.child('status').set('rescued');

    rescuerPositionStream.cancel();

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (BuildContext context) => RescuedSheets(
              title: 'Rescue Ended',
              subtitle: 'You rescued ' +
                  widget.requestShelter.evacUsername +
                  ' & ' +
                  widget.requestShelter.evacCount +
                  ' others',
              onPress: () {
                Navigator.pop(context);
                Navigator.pop(context);
                HelperMethods.enableHomeTabLocationUpdates();
              },
            ));

    rescueCounts();
  }

  void rescueCounts() {
    DatabaseReference rescuedRef = FirebaseDatabase.instance
        .reference()
        .child('shelters/${currentFirebaseUser.uid}/rescuedCount');
    rescuedRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        int pastRescue = int.parse(snapshot.value);

        var rescuedCount =
            int.parse(widget.requestShelter.evacCount) + pastRescue;

        rescuedRef.set(rescuedCount);
      } else {
        String rescuedCount = widget.requestShelter.evacCount;
        rescuedRef.set(rescuedCount);
      }
    });
  }
}
