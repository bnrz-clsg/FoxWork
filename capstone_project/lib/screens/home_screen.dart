import 'dart:async';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:capstone_project/utils/strings.dart';
import 'package:capstone_project/widgets/bottom_bar.dart';
import 'package:capstone_project/widgets/home_widgets.dart';
import 'package:capstone_project/widgets/host_shelter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreenMain extends StatefulWidget {
  static const id = 'HomeScreenMain';
  @override
  _HomeScreenMainState createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  int _selectedIndex = 0;
  int selectedScreen = 0;
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
    CameraPosition cp = new CameraPosition(target: pos, zoom: 12);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
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
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
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
          Container(
            height: double.infinity,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                /* Join Meeting and Host Meeting Widget*/
                HomeScreenWidgets(),
                HostShelter(),
              ],
            ),
          ),
          Positioned(
            top: 150,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                tabButton(0, AppContent.sos),
                tabButton(1, AppContent.snq),
              ],
            ),
          ),
          BottomBar()
        ],
      ),
    );
  }

  /*Academic Mode Widget*/
  Widget generalMoodWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 13),
              child: Text(
                AppContent.bayanihan,
                style: CustomTheme.screenTitle,
              ),
            ),
          ]),
        ));
  }

  /*navigate between join meeting and host meeting*/
  Widget tabButton(int btnIndex, String btnTitle) {
    return GestureDetector(
      onTap: () {
        _selectedIndex = btnIndex;
        _pageController.animateToPage(_selectedIndex,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
        setState(() {});
      },
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width / 2.3,
        decoration: BoxDecoration(
          borderRadius: btnIndex == 0
              ? BorderRadius.only(
                  topLeft: Radius.circular(6), bottomLeft: Radius.circular(5))
              : BorderRadius.only(
                  bottomRight: Radius.circular(6),
                  topRight: Radius.circular(5)),
          boxShadow:
              _selectedIndex == btnIndex ? CustomTheme.iconBoxShadow : null,
          color: _selectedIndex == btnIndex ? Colors.white : Color(0xff7b7b7b),
        ),
        child: Center(
          child: Text(
            btnTitle,
            style: TextStyle(
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: _selectedIndex == btnIndex
                    ? Color(0xff222222)
                    : Colors.white),
          ),
        ),
      ),
    );
  }
}
