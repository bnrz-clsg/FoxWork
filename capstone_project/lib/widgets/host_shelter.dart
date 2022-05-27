import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/shelter_user/rescuerInfo.dart';
import 'package:capstone_project/shelter_user/rescuerregistration.dart';
import 'package:capstone_project/shelter_user/shelter_page.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:capstone_project/utils/strings.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'alert_dialog.dart';

class HostShelter extends StatefulWidget {
  @override
  _HostShelterState createState() => _HostShelterState();
}

class _HostShelterState extends State<HostShelter> {
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/shelter_appbar_icon.png'),
                  fit: BoxFit.fill,
                )),
              ),
              Text(
                AppContent.hello,
                style: TextStyle(
                    fontSize: 12.0, letterSpacing: 1, color: Colors.grey),
              ),
              SizedBox(height: 5),
              Text(
                AppContent.welcome,
                style: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
              Divider(),
              SizedBox(height: 20),
              Text(AppContent.startShelter),
              SizedBox(height: 15),
              WildRaisedButton(
                color: CustomTheme.green,
                style: TextStyle(letterSpacing: 1.5, fontSize: 16),
                title: AppContent.openShelter,
                size: Size(double.infinity, 35),
                onPressed: () {
                  userValidator();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void userValidator() {
    DatabaseReference _userValidator = FirebaseDatabase.instance
        .reference()
        .child('shelters/${currentFirebaseUser.uid}');
    _userValidator.once().then((DataSnapshot snapshot) {
      var userRescuer = (snapshot.value);
      if (userRescuer != null) {
        rescuerValidator();
      } else {
        var baseDialog = BaseAlertDialog(
            title: AppContent.acctAuth,
            content: AppContent.regAcct,
            yesOnPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RescuerRegistration()));
            },
            noOnPressed: () {
              Navigator.pop(context);
            },
            yes: AppContent.continueText,
            no: AppContent.cancelText);
        showDialog(
            context: context, builder: (BuildContext context) => baseDialog);
      }
    });
  }

  void rescuerValidator() {
    DatabaseReference statusRef = FirebaseDatabase.instance
        .reference()
        .child('shelters/${currentFirebaseUser.uid}/status');
    statusRef.once().then((DataSnapshot snapshot) {
      String _status = (snapshot.value);
      if (_status == 'true') {
        DatabaseReference _rescuerRef = FirebaseDatabase.instance
            .reference()
            .child('shelters/${currentFirebaseUser.uid}/rescuerInfo');
        _rescuerRef.once().then((DataSnapshot snapshot) {
          var _rescuerInfo = (snapshot.value);
          if (_rescuerInfo != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ShelterPage()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RescuerInfo()));
          }
        });
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
            context: context, builder: (BuildContext context) => baseDialog);
      }
    });
  }
}
