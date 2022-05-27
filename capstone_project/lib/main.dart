import 'package:capstone_project/screens/shelter_page.dart';
import 'package:capstone_project/screens/signin_screen.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dataprovider/appdata.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  currentFirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Login',
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
        ),
        // home: LoginPage(),
        initialRoute:
            (currentFirebaseUser == null) ? LoginScreen.id : ShelterPage.id,
        routes: {
          ShelterPage.id: (context) => ShelterPage(),
          LoginScreen.id: (context) => LoginScreen(),
        },
      ),
    );
  }
}
