import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:capstone_project/models/requestShelter.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/widgets/notificationDialog.dart';
import 'package:capstone_project/widgets/progress_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging();

  Future initialize(context) async {
    fcm.configure(
      // when we recieve notification when app is in use/open
      onMessage: (Map<String, dynamic> message) async {
        fetchRequestInfo(getRequestID(message), context);
      },
      //recieve notificatrion when the app is not running
      onLaunch: (Map<String, dynamic> message) async {
        fetchRequestInfo(getRequestID(message), context);
      },
      // when app is in backlground/minimize
      onResume: (Map<String, dynamic> message) async {
        fetchRequestInfo(getRequestID(message), context);
      },
    );
  }

  // ignore: missing_return
  Future<String> getToken() async {
    String token = await fcm.getToken();
    print('token: $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('shelters/${currentFirebaseUser.uid}/token');
    tokenRef.set(token);

    fcm.subscribeToTopic('allshelters');
    fcm.subscribeToTopic('allusers');
  }

  String getRequestID(Map<String, dynamic> message) {
    // String requestID = '';

    String requestID = message['data']['request_id'];
    print('request id: $requestID');
    return requestID;
  }

  void fetchRequestInfo(String requestID, context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressCircular(
        status: 'Fetching Details',
      ),
    );
    DatabaseReference requestref = FirebaseDatabase.instance
        .reference()
        .child('shelterRequest/$requestID');
    requestref.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);

      if (snapshot.value != null) {
        //audio alert sound
        assetsAudioPlayer.open(
          Audio('assets/sounds/alert.mp3'),
        );

        assetsAudioPlayer.play();
        double pickupLat =
            double.parse(snapshot.value['location']['latitude'].toString());
        double pickupLng =
            double.parse(snapshot.value['location']['longitude'].toString());
        String pickUpAddress = snapshot.value['current_location'].toString();

        String evacCount = snapshot.value['number_person'];
        String evacStatus = snapshot.value['current_situation'];
        String eusername = snapshot.value['e_username'];
        String evacPhone = snapshot.value['e_phone'];

        RequestShelter requestShleter = RequestShelter();
        requestShleter.requestID = requestID;
        requestShleter.evacUsername = eusername;
        requestShleter.evacCount = evacCount;
        requestShleter.evacStatus = evacStatus;

        requestShleter.evacPhone = evacPhone;
        requestShleter.pickupAddress = pickUpAddress;
        requestShleter.pickup = LatLng(pickupLat, pickupLng);
//        requestShleter.destination = LatLng(destinationLat, destinationLng);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => NotificationDioalog(
            requestShelter: requestShleter,
          ),
        );
      }
    });
  }
}
