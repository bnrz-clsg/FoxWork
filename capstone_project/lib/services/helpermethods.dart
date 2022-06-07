import 'dart:math';
import 'package:capstone_project/dataprovider/history.dart';
import 'package:capstone_project/dataprovider/appdata.dart';
import 'package:capstone_project/models/directiondetails.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/requesthelper.dart';
import 'package:capstone_project/widgets/progress_message_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HelperMethods {
  // <Global Register FirebaseDatabase>

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';
    var response = await RequestHelper.getRequest(url);
    if (response == 'failed') {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int radInt = randomGenerator.nextInt(max);

    return radInt.toDouble();
  }

  static void disableHomeTabLocationUpdates() {
    homeTabPositionStream.pause();
    Geofire.removeLocation(currentFirebaseUser.uid);
  }

  static void enableHomeTabLocationUpdates() {
    homeTabPositionStream.resume();
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);
  }

  static void showProgressDialog(context) {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressMessageDialog(
        message: 'Please wait',
      ),
    );
  }

  static void getHistoryInfo(context) {
    DatabaseReference rescuedRef = FirebaseDatabase.instance
        .reference()
        .child('shelters/${currentFirebaseUser.uid}/rescuedCount');

    rescuedRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String totalRescued = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false)
            .updateTotalRescue(totalRescued);
      }
    });

    DatabaseReference historyRef = FirebaseDatabase.instance
        .reference()
        .child('shelters/${currentFirebaseUser.uid}/history');
    historyRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        int rescueCount = values.length;

        // update trip count to data provider
        Provider.of<AppData>(context, listen: false)
            .updateRescueCount(rescueCount);

        List<String> tripHistoryKeys = [];
        values.forEach((key, value) {
          tripHistoryKeys.add(key);
        });

        // update trip keys to data provider
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);

        getHistoryData(context);
      }
    });
  }

  static void getHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;
    for (String key in keys) {
      DatabaseReference historyRef =
          FirebaseDatabase.instance.reference().child('shelterRequest/$key');

      historyRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistory(history);
          print(history.pickup);
        }
      });
    }
  }
}
