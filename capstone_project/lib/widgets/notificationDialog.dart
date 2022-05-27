import 'package:capstone_project/models/requestShelter.dart';
import 'package:capstone_project/screens/newrequestpage.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:capstone_project/widgets/wildoutlinebutton.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:toast/toast.dart';
import '../style/brandcolor.dart';
import 'progress_indicator.dart';

class NotificationDioalog extends StatelessWidget {
  final RequestShelter requestShelter;

  NotificationDioalog({this.requestShelter});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomTheme.backgroundColor,
            borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // SizedBox(height: 10),
            Image.asset(
              'assets/images/sos_alert_img.png',
              height: 90,
            ),
            Text(
              'RESCUE ALERT',
              style: TextStyle(
                  fontFamily: 'Brand-Bold', fontSize: 20, wordSpacing: 2),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.group, color: Colors.grey),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text(
                              'No. of person:  ' + requestShelter.evacCount)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.description, color: Colors.blueGrey),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text(
                        requestShelter.evacStatus,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      )),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(OMIcons.accountCircle, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(requestShelter.evacUsername),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.contact_page_outlined, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(requestShelter.evacPhone
//                          +
//                          ' - ' +
//                          requestShelter.evacEmail
                          ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.album_outlined, color: Colors.blue),
                      SizedBox(width: 10),
                      Expanded(child: Text(requestShelter.pickupAddress)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Divider(
              thickness: 2,
              endIndent: 20,
              indent: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Container(
                    child: WildOutlineButton(
                      title: 'DECLINE',
                      onPressed: () {
                        assetsAudioPlayer.stop();
                        Navigator.pop(context);
                      },
                      color: BrandColors.colorTextLight,
                      style: TextStyle(
                        color: BrandColors.colorTextLight,
                        fontFamily: 'Brand-Bold',
                        fontSize: 17,
                        letterSpacing: 2,
                      ),
                    ),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: WildRaisedButton(
                        title: 'ACCEPT',
                        onPressed: () {
                          assetsAudioPlayer.stop();
                          checkAvailability(context);
                        },
                        color: Colors.green[400],
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Brand-Bold',
                          fontSize: 17,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkAvailability(context) {
//Loading dialog while waiting for result
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressCircular(
        status: 'Fetching Details',
      ),
    );

    DatabaseReference newShelterRef = FirebaseDatabase.instance
        .reference()
        .child('shelters/${currentFirebaseUser.uid}/newShelters');
    newShelterRef.once().then((DataSnapshot snapshot) {
      //this will pop dialog preogress box
      Navigator.pop(context);
      //this will pop the RequestFOrShelter Dialog Box
      Navigator.pop(context);

      String thisShelterID = "";
      if (snapshot.value != null) {
        thisShelterID = snapshot.value.toString();
      } else {
        print('Request for Rescue has not been found');
      }
      if (thisShelterID == requestShelter.requestID) {
        newShelterRef.set('accepted');

        HelperMethods.disableHomeTabLocationUpdates();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewRequestPage(
                      requestShelter: requestShelter,
                    )));
      } else if (thisShelterID == 'cancelled') {
        Toast.show("Rescue request has been cancelled", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else if (thisShelterID == 'timeout') {
        Toast.show("Rescue request has been timed out", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Rescue request has not been found", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
