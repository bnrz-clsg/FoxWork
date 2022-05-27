import 'dart:async';
import 'package:intl/intl.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:capstone_project/models/shelters.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = 'AIzaSyBFsUqH4TWWuSfQ-XVHP1GZUDUfg5ORF6g';

String serverKey =
    'key=AAAATtOqDjM:APA91bFkOqjVcWX6GGnHDya61jA88943ADbdBDQd8XxlCh8HJYhQYx-kCXZ6Q_iz9LtcBpi2etA2zXeY4-fH4qaVMBpvBrwA2xnCLpB96Z2PzyEUWWRe_cPp1XG58Yvgg1yMHFM-otsz';

final CameraPosition googlePlexOne = CameraPosition(
  target: LatLng(14.5953, 120.9880),
  zoom: 14.4746,
);

User currentFirebaseUser;
Shelters currentSheltersInfo;

//this is
DatabaseReference shelterRequestRef;

//this is rideRef (request shelter collection)
Position currentPosition;

StreamSubscription<Position> homeTabPositionStream;
StreamSubscription<Position> rescuerPositionStream;

final assetsAudioPlayer = AssetsAudioPlayer();

//this is user collection
DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child('shelters');

final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('yyyy-MM-dd');
final String formattedDate = formatter.format(now);
