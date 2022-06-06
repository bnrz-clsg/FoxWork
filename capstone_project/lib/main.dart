import 'package:capstone_project/screens/home_screen.dart';
import 'package:capstone_project/screens/signin_screen.dart';
import 'package:capstone_project/services/geolocator_service.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/places_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dataprovider/appdata.dart';
import 'models/place.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  currentFirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MultiProvider(
        providers: [
          FutureProvider(create: (context) => locatorService.getLocation()),
          FutureProvider(create: (context) {
            ImageConfiguration configuration =
                createLocalImageConfiguration(context);
            return BitmapDescriptor.fromAssetImage(
                configuration, 'assets/images/icon_logo.png');
          }),
          ProxyProvider2<Position, BitmapDescriptor, Future<List<Place>>>(
            update: (context, position, icon, places) {
              return (position != null)
                  ? placesService.getPlaces(
                      position.latitude, position.longitude, icon)
                  : null;
            },
          )
        ],
        child: MaterialApp(
          // darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Login',
          theme: ThemeData(
            fontFamily: 'Brand-Regular',
            primarySwatch: Colors.blue,
          ),
          // home: LoginPage(),
          initialRoute: (currentFirebaseUser == null)
              ? LoginScreen.id
              : HomeScreenMain.id,
          routes: {
            HomeScreenMain.id: (context) => HomeScreenMain(),
            LoginScreen.id: (context) => LoginScreen(),
          },
        ),
      ),
    );
  }
}
