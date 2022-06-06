import 'package:capstone_project/auth.dart';
import 'package:capstone_project/screens/home_screen.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/widgets/login_header.dart';
import 'package:capstone_project/widgets/progress_message_dialog.dart';
import 'package:capstone_project/widgets/round_button.dart';
import 'package:capstone_project/widgets/termsandcondition.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signin_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'SignupScreen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

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
      body: Stack(children: [
        Container(
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
                                  //USERNAME
                                  TextFormField(
                                    controller: _usernameController,
                                    key: ValueKey('username'),
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 4) {
                                        return 'Please provide valid name';
                                      }
                                      return null;
                                    },
                                    decoration:
                                        InputDecoration(labelText: 'Fullname'),
                                  ),
                                  //TEXT FORM EMAIL
                                  TextFormField(
                                    controller: _emailController,
                                    key: ValueKey('email'),
                                    validator: (value) {
                                      if (value.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Pelase enter a valid email address!';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Email address',
                                    ),
                                  ),
                                  // Contact
                                  TextFormField(
                                    controller: _phoneController,
                                    key: ValueKey('phone'),
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 11) {
                                        return 'Please provide valid phone';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText:
                                            'Phone number (09XX XXX XXXX)'),
                                  ),
                                  // Password
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
                                  TextFormField(
                                    // controller: _passwordController,
                                    validator: (value) {
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match!';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Repeat password'),
                                    obscureText: true,
                                  ),

                                  WildRaisedButton(
                                    size: Size(double.infinity, 35),
                                    color: Colors.blue,
                                    style: TextStyle(
                                        letterSpacing: 1.5, fontSize: 16),
                                    title: 'SIGNUP',
                                    onPressed: () {
                                      final isValid =
                                          _formKey.currentState.validate();
                                      if (isValid) {
                                        _signupNewUser(context);
                                      }
                                    },
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 16),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          LoginScreen.id, (route) => false);
                                    },
                                    child: Text(
                                        'Already have BAYANIHAN   account? Login here!',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.blue)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Text('Or continue Signup and login.. .'),
                    SizedBox(height: 20),
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
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          left: 0,
          right: 0,
          child: termsandconditions(),
        ),
      ]),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signupNewUser(BuildContext context) async {
    // ProgressDialog while Authenticating
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressMessageDialog(message: 'Registering.. .');
        });
    final User firebaseUser = (await _auth
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .catchError((error) {
      // Exit ProgressDialog
      Navigator.pop(context);
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    }))
        .user;
    if (firebaseUser != null) {
      Map _map = {
        'created_at': formattedDate,
        'name': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
      };
      userRef.child(firebaseUser.uid).set(_map);
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreenMain.id, (route) => false);
    } else {
      // Exit ProgressDialog
      Navigator.pop(context);
      var errorMessages = 'Authentication failed';
      _showErrorDialog(errorMessages);
    }
  }
}
