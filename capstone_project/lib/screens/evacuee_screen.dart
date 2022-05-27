import 'dart:async';
import 'package:capstone_project/dataprovider/appdata.dart';
import 'package:capstone_project/models/nearbyShelter.dart';
import 'package:capstone_project/services/firehelpers.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:capstone_project/widgets/drawer_nav.dart';
import 'package:capstone_project/widgets/norescuerdialog.dart';
import 'package:capstone_project/widgets/preogressDialog.dart';
import 'package:capstone_project/widgets/text_field.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class EvacueeScreen extends StatefulWidget {
  @override
  _EvacueeScreenState createState() => _EvacueeScreenState();
}

class _EvacueeScreenState extends State<EvacueeScreen> {
  final _personCount = TextEditingController(text: '1');
  final _helpStatus = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double findContainerHeight = 315;
  double requestingSheetHeight = 0;
  double mapBottomPadding = 0;

  Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polylinrCoordinates = [];
  Set<Polyline> _polylines = {};
  // ignore: non_constant_identifier_names
  Set<Marker> _Markers = {};
  // ignore: non_constant_identifier_names
  Set<Circle> _Circles = {};
  GoogleMapController mapController;
  var geolocator = Geolocator();

// online shelter ICon
  BitmapDescriptor nearbyIcon;
  DatabaseReference shelterRef;

  bool nearbySheltersKeysLoad = false;

  List<NearbyShelter> availableRescuer;

  void setupPositionLocator() async {
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 12);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    String address =
        await HelperMethods.findCordinateAddress(position, context);
    print(address);

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

  void showDetailSheet() async {
    getDirection();
    setState(() {
      findContainerHeight = 350;
    });
  }

  void showRequestSheet() {
    setState(() {
      findContainerHeight = 350;
      requestingSheetHeight = 205;
    });
    createShelterRequest();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;

    setState(() {
      mapBottomPadding = 350;
    });
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
    return Scaffold(
      body: (googlePlexOne != null)
          ? Stack(children: <Widget>[
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.45,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      mapToolbarEnabled: false,
                      zoomGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      initialCameraPosition: googlePlexOne,
                      polylines: _polylines,
                      markers: _Markers,
                      circles: _Circles,
                      onMapCreated: _onMapCreated,
                    ),
                  ),
                ],
              ),
              //
              //<Circle Navigation button>
              Positioned(
                  top: 70,
                  left: 30,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: NavigationDrawer())),
              //

              //<Request for Open-House-Shelter>
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  height: findContainerHeight,
                  decoration: BoxDecoration(
                    color: CustomTheme.backgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7))
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 5, 24, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //information view
                        Text(
                          'Keep Calm & Asses your Situation',
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[800]),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/pin_location.png',
                              height: 43.0,
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'current location...',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
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
                                        fontSize: 15,
                                        fontFamily: 'Brand-Regular',
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Divider(),
                        // find available openhouse button
                        Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                FormTextInput(
                                  icon: Icon(Icons.group_add),
                                  hint: 'Number of Person',
                                  hintText: 'sample2',
                                  readOnly: false,
                                  controller: _personCount,
                                  keebsType: TextInputType.number,
                                ),
                                FormTextInput(
                                  icon: Icon(Icons.content_paste),
                                  hint: 'State your Situation/Status',
                                  hintText: 'Whats your current situation?',
                                  readOnly: false,
                                  controller: _helpStatus,
                                ),
                                WildRaisedButton(
                                  title: 'Send S.O.S.',
                                  color: Colors.blue[400],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Brand-Bold',
                                    fontSize: 17,
                                    letterSpacing: 2,
                                  ),
                                  onPressed: () {
                                    showRequestSheet();
                                    availableRescuer =
                                        FireHelper.nearbyShelterList;

                                    findRescuer();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //<loading waiting for open house shelter>
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  height: requestingSheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7))
                      ]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Waiting for Rescuer.. .',
                            style: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(height: 10),
                        LinearProgressIndicator(),
                        SizedBox(height: 30),
                        GestureDetector(
                          onDoubleTap: () {
                            cancelrequest();
                            resetApp();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey[400],
                                )),
                            child: Icon(
                              Icons.close,
                              size: 25,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          child: Text('double tap to cancel SOS'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ])
          : ProgressDialog(),
    );
  }

//<Get d irention>
  Future<void> getDirection() async {
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;

    var pickLatLng = LatLng(pickup.latitude, pickup.longitude);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog());
    Navigator.pop(context);

    // PolylinePoints polylinePoints = PolylinePoints();
    _polylines.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('poliid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylinrCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polylines.add(polyline);
    });

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
    );

    setState(() {
      _Markers.add(pickupMarker);
    });
    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: Colors.green,
    );
    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: Colors.purple,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: Colors.purple,
    );
    setState(() {
      _Circles.add(pickupCircle);
      _Circles.add(destinationCircle);
    });
  }

//void createEvacueerequest
  void createShelterRequest() {
    //rideRef
    shelterRef =
        FirebaseDatabase.instance.reference().child('shelterRequest').push();

    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    // var destination =
    //     Provider.of<AppData>(context, listen: false).destinationAddress;
    Map pickupMap = {
      'latitude': pickup.latitude.toString(),
      'longitude': pickup.longitude.toString(),
    };

    Map rideMap = {
      'created_at': formattedDate,
      'e_username': currentUserInfo.username,
      'e_phone': currentUserInfo.phone,
      'number_person': _personCount.text.trim(),
      'current_situation': _helpStatus.text.trim(),
      'current_location': pickup.placeName,
      'location': pickupMap,
      'status': 'waiting',
//      'shelter_id': 'waiting',
//      'shelter_name': 'waiting',
    };
    shelterRef.set(rideMap);
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

//<this method will view list of active shelter>
//<this is for shelter also>
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

//cancel request
  void cancelrequest() {
    shelterRef.remove();
  }

  resetApp() {
    setState(() {
      polylinrCoordinates.clear();
      _polylines.clear();
      _Markers.clear();
      _Circles.clear();
      findContainerHeight = 350;
      requestingSheetHeight = 0;
    });
  }

  noRescuerFound() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => NoRescuerDialog(),
    );
  }

  void findRescuer() {
    if (availableRescuer.length == 0) {
      cancelrequest();
      resetApp();
      noRescuerFound();
      return;
    }
    var rescuer = availableRescuer[0];

    notifyRescuer(rescuer);

    availableRescuer.removeAt(0);

    print(rescuer.key);
  }

  void notifyRescuer(NearbyShelter rescuer) {
    DatabaseReference rescuerRef = FirebaseDatabase.instance
        .reference()
        .child('shelters/${rescuer.key}/newShelters');
    rescuerRef.set(shelterRef.key);

    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('shelters/${rescuer.key}/token');
    tokenRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String token = snapshot.value.toString();

        /*send Notification to selected rescuer*/
        HelperMethods.sendNotification(token, context, shelterRef.key);
      } else {
        return;
      }
    });
  }
}
