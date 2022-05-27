import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'shelter_page.dart';

class RescuerInfo extends StatefulWidget {
  static const String id = 'shelterinfo';

  @override
  _RescuerInfoState createState() => _RescuerInfoState();
}

class _RescuerInfoState extends State<RescuerInfo> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  DatabaseReference shelterRef;

  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(title,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 15)));
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  var teamName = TextEditingController();
  var teamCount = TextEditingController();
  var companyName = TextEditingController();

  @override
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/logo_icon_final.png'),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Rescuer(\'s) Information',
                      style: TextStyle(fontFamily: 'Brand_Bold', fontSize: 22),
                    ),
                    SizedBox(height: 25),
                    TextField(
                      controller: teamName,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Enter Team Name',
                        hintText: 'Team name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                        controller: teamCount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Team Count',
                          hintText: 'Team Count',
                          border: OutlineInputBorder(),
                        )),
                    SizedBox(height: 10),
                    TextField(
                      controller: companyName,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Enter Company Name',
                        hintText:
                            'Company name (ex. redcross, coastguard, etc.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    WildRaisedButton(
                      // color: Colors.grey,
                      onPressed: () {
                        rescuerInfoDialog();
                      },
                      title: 'Submit',
                      style: TextStyle(
                          fontFamily: 'Brand-regular',
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  rescuerInfoDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Rescuer\'s information!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Team name: ' + teamName.text),
              Text('Rescuer count: ' + teamCount.text),
              Text('Company name: ' + companyName.text),
            ],
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('Register info'),
              textColor: Colors.blue,
              onPressed: () {
                updateProfile();
              },
            ),
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('cancel'),
              textColor: Colors.red[200],
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  void updateProfile() {
    String id = currentFirebaseUser.uid;
// <Firebase>
    DatabaseReference _shelterRef =
        FirebaseDatabase.instance.reference().child('shelters/$id');

    Map<String, dynamic> rescuermap = {
      'teamName': teamName.text,
      'teamCount': teamCount.text,
      'companyName': companyName.text,
    };

    _shelterRef
        .child('rescuerInfo')
        .set(rescuermap); //<send to firebase realtime database

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ShelterPage()));
  }
}
