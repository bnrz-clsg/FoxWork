import 'package:capstone_project/screens/evacuee_screen.dart';
import 'package:capstone_project/screens/pin_location_screen.dart';
import 'package:capstone_project/screens/registration_screen.dart';
import 'package:capstone_project/screens/search.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:capstone_project/utils/strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'alert_dialog.dart';

class HomeScreenWidgets extends StatefulWidget {
  @override
  _HomeScreenWidgetsState createState() => _HomeScreenWidgetsState();
}

class _HomeScreenWidgetsState extends State<HomeScreenWidgets> {
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }

  var _userValidator = FirebaseDatabase.instance
      .reference()
      .child('users/${currentFirebaseUser.uid}');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _userValidator.onValue,
        builder: (context, snapshot) {
          return Container(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppContent.nicetoseeyou,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  letterSpacing: 1,
                                  color: Colors.grey),
                            ),
                            SizedBox(height: 5),
                            Text(
                              AppContent.welcome,
                              style: TextStyle(
                                  color: CustomTheme.white,
                                  fontSize: 25,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        //Help need rescue
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (snapshot.data.snapshot.value == null) {
                                var baseDialog = BaseAlertDialog(
                                    title: AppContent.acctAuth,
                                    content: AppContent.regAcct,
                                    yesOnPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserRegistration()));
                                    },
                                    noOnPressed: () {
                                      Navigator.pop(context);
                                    },
                                    yes: AppContent.continueText,
                                    no: AppContent.cancelText);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        baseDialog);
                              } else if (currentUserInfo.status == "approve") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EvacueeScreen()));
                              } else {
                                var baseDialog = BaseAlertDialog(
                                    title: AppContent.auth,
                                    content: AppContent.authProcess,
                                    yesOnPressed: () {
                                      Navigator.pop(context);
                                    },
                                    yes: AppContent.okText,
                                    no: "");
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        baseDialog);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: CustomTheme.blue,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[900],
                                          blurRadius: 1,
                                          spreadRadius: 0.8,
                                          offset: Offset(0.7, 0.7))
                                    ]),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                        'assets/images/bsos.png',
                                      ),
                                      height: 100,
                                    ),
                                    Text(AppContent.needRescue,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        //Find Shelter
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Search()));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: CustomTheme.backgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[900],
                                          blurRadius: 1,
                                          spreadRadius: 0.8,
                                          offset: Offset(0.7, 0.7))
                                    ]),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                        'assets/images/evac.png',
                                      ),
                                      height: 100,
                                    ),
                                    Text(AppContent.findShelter,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        //Weather news
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: CustomTheme.backgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[900],
                                        blurRadius: 1,
                                        spreadRadius: 0.8,
                                        offset: Offset(0.7, 0.7))
                                  ]),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Image(
                                    image: AssetImage(
                                      'assets/images/weather_icon.png',
                                    ),
                                    height: 100,
                                  ),
                                  Text(AppContent.weatherNews,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900))
                                ],
                              ),
                            ),
                          ),
                        ),
                        //Find exact Location
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CurrentLocation()));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: CustomTheme.backgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[900],
                                          blurRadius: 1,
                                          spreadRadius: 0.8,
                                          offset: Offset(0.7, 0.7))
                                    ]),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                        'assets/images/pin_location.png',
                                      ),
                                      height: 100,
                                    ),
                                    Text(AppContent.myLocation,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
