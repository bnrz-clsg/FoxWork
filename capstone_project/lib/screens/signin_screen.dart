import 'package:capstone_project/screens/signup_screen.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/widgets/login_header.dart';
import 'package:capstone_project/widgets/progress_message_dialog.dart';
import 'package:capstone_project/widgets/round_button.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('assets/images/loginBG.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 40, 8, 0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Header
                  LoginHeader(),
                  /* Start Email Login */
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // color: Color.fromRGBO(225, 225, 225, .8),
                      margin: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                //TEXT FORM EMAIL
                                TextFormField(
                                  controller: _emailController,
                                  key: ValueKey('email'),
                                  validator: (value) {
                                    if (value.isEmpty || !value.contains('@')) {
                                      return 'Pelase enter a valid email address!';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Email address',
                                  ),
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  key: ValueKey('password'),
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 7) {
                                      return 'Password must be at least 7 characters long!';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(labelText: 'Password'),
                                  obscureText: true,
                                ),
                                SizedBox(height: 12.0),

                                WildRaisedButton(
                                  size: Size(double.infinity, 35),
                                  color: Colors.blue,
                                  style: TextStyle(
                                      letterSpacing: 1.5, fontSize: 16),
                                  title: 'LOGIN',
                                  onPressed: () {
                                    final isValid =
                                        _formKey.currentState.validate();
                                    if (isValid) {
                                      _loginUser(context);
                                    }
                                  },
                                ),
                                TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 16),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          SignupScreen.id, (route) => false);
                                    },
                                    child: Text(
                                        'Don\'t have an account? Sign up here!',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.blue))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  /* END */
                  Divider(),
                  Text('Or continue using.. .'),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      signInWithGoogle().then((result) {
                        if (result != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => HomeScreenMain()),
                          );
                        }
                      });
                    },
                    child: googleButton('google_logo'),
                  ),
                  WildRaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreenMain()));
                    },
                    title: 'tester',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _loginUser(BuildContext context) async {
    // ProgressDialog while Authenticating
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressMessageDialog(message: 'Athenticating.. .');
        });

    final User _firebaseUser = (await _auth
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim())
            .catchError((error) {
      // Exit ProgressDialog
      Navigator.pop(context);
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('ERROR_INVALID_EMAIL')) {
        errorMessage = 'Your email address appears to be malformed.';
      } else if (error.toString().contains('ERROR_WRONG_PASSWORD')) {
        errorMessage = 'Your password is wrong.';
      } else if (error.toString().contains('ERROR_USER_NOT_FOUND')) {
        errorMessage = 'User with this email does not exist.';
      } else if (error.toString().contains('ERROR_USER_DISABLED')) {
        errorMessage = 'User with this email has been disabled.';
      } else if (error.toString().contains('ERROR_TOO_MANY_REQUESTS')) {
        errorMessage = 'Too many requests. Try again later.';
      } else if (error.toString().contains('ERROR_OPERATION_NOT_ALLOWED')) {
        errorMessage = 'Signing in with Email and Password is not enabled.';
      }
      _showErrorDialog(errorMessage);
    }))
        .user;
    if (_firebaseUser != null) {
      userRef.child(_firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreenMain.id, (route) => false);
        } else {
          // Exit ProgressDialog
          Navigator.pop(context);

          _auth.signOut();
          var errorMessage = 'No record for this user. Create new account';
          _showErrorDialog(errorMessage);
        }
      });
    } else {
      // Exit ProgressDialog
      Navigator.pop(context);

      var errorMessage = 'Error occured, Try login again!';
      _showErrorDialog(errorMessage);
    }
  }
}
