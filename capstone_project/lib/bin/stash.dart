// //Registration stash
// /*
// import 'package:capstone_project/screens/homescreen.dart';
// import 'package:capstone_project/screens/login_page.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class RegistrationPage extends StatefulWidget {
//   static const String id = 'register';

//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   bool isLoading = false;
//   final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
//   void showSnackBar(String title) {
//     final snackBar = SnackBar(
//         content: Text(
//       title,
//       textAlign: TextAlign.center,
//       style: TextStyle(fontSize: 15),
//     ));
//     scaffoldKey.currentState.showSnackBar(snackBar);
//   }

//   // final FirebaseAuth _auth = FirebaseAuth.instance;

//   // DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("User");

//   TextEditingController fullnameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   void registerUser() async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//               email: emailController.text, password: passwordController.text);
//       if (userCredential != null) {
//         DatabaseReference dbRef =
//             FirebaseDatabase.instance.reference().child("User");
//         Map userMap = {
//           'fullname': fullnameController.text,
//           'email': emailController.text,
//           'phone': phoneController.text,
//         };
//         dbRef.set(userMap);

//         Navigator.pushNamedAndRemoveUntil(
//             context, HomeScreen.id, (route) => false);
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       body: Form(
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: ExactAssetImage('assets/images/loginBG.jpg'),
//               fit: BoxFit.fill,
//               alignment: Alignment.topCenter,
//             ),
//           ),
//           child: Center(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       CircleAvatar(
//                         radius: 43.0,
//                         backgroundColor: Color.fromRGBO(110, 110, 110, 10),
//                         backgroundImage:
//                             AssetImage("assets/images/logo_icon_final.png"),
//                       ),
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                       Text(
//                         "BAYANIHAN",
//                         style: TextStyle(
//                           fontFamily: 'Arial',
//                           color: Colors.white,
//                           fontSize: 25,
//                           letterSpacing: 7,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         "evacuation system",
//                         style: TextStyle(
//                           fontFamily: 'Brand-Regular',
//                           color: Colors.black,
//                           fontSize: 18.0,
//                           letterSpacing: 1.10,
//                           fontWeight: FontWeight.normal,
//                         ),
//                       ),
//                       SizedBox(height: 50),
//                       _registerAccount(),
//                       FlatButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LoginPage()),
//                           );
//                         },
//                         child: Text(
//                           'Already have BAYANIHAN account? Login here!',
//                           style: TextStyle(
//                             fontSize: 15.0,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _registerAccount() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             //fullname
//             TextFormField(
//               controller: fullnameController,
//               decoration: InputDecoration(
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white, width: 2.0),
//                 ),
//                 labelText: 'Full name',
//                 labelStyle: TextStyle(fontSize: 17.0),
//                 hintStyle: TextStyle(color: Colors.white, fontSize: 10.0),
//               ),
//               style: TextStyle(
//                   fontSize: 17.0, color: Colors.white, letterSpacing: 1.8),
//             ),
//             SizedBox(height: 10.0),
//             //email
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white, width: 2.0),
//                 ),
//                 labelText: 'Email address',
//                 labelStyle: TextStyle(fontSize: 17.0),
//                 hintStyle: TextStyle(color: Colors.white, fontSize: 10.0),
//               ),
//               style: TextStyle(
//                   fontSize: 17.0, color: Colors.white, letterSpacing: 1.8),
//             ),
//             SizedBox(height: 10.0),
//             //phone number
//             TextFormField(
//               controller: phoneController,
//               keyboardType: TextInputType.number,
//               inputFormatters: <TextInputFormatter>[
//                 FilteringTextInputFormatter.digitsOnly
//               ],
//               decoration: InputDecoration(
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white, width: 2.0),
//                 ),
//                 labelText: 'Phone number',
//                 labelStyle: TextStyle(fontSize: 17.0),
//                 hintStyle: TextStyle(color: Colors.white, fontSize: 10.0),
//               ),
//               style: TextStyle(
//                   fontSize: 17.0, color: Colors.white, letterSpacing: 1.8),
//             ),
//             SizedBox(height: 10.0),
//             //password
//             TextFormField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white, width: 2.0),
//                 ),
//                 labelText: 'Password',
//                 labelStyle: TextStyle(fontSize: 17.0),
//                 hintStyle: TextStyle(color: Colors.white, fontSize: 10.0),
//               ),
//               style: TextStyle(
//                   fontSize: 17.0, color: Colors.white, letterSpacing: 1.8),
//             ),
//             SizedBox(height: 10.0),
//             RaisedButton(
//               shape: new RoundedRectangleBorder(
//                   borderRadius: new BorderRadius.circular(5)),
//               color: Colors.blue,
//               textColor: Colors.white,
//               child: Container(
//                 height: 40.0,
//                 child: Center(
//                   child: Text(
//                     'REGISTER',
//                     style: TextStyle(
//                         fontSize: 20.0,
//                         fontFamily: 'Brand-Bold',
//                         letterSpacing: 2.0),
//                   ),
//                 ),
//               ),
//               onPressed: () async {
//                 var connectivityResult =
//                     await Connectivity().checkConnectivity();
//                 if (connectivityResult != ConnectivityResult.mobile &&
//                     connectivityResult != ConnectivityResult.wifi) {
//                   showSnackBar('No internet connection');
//                   return;
//                 }

//                 if (fullnameController.text.length < 3) {
//                   showSnackBar('Please provide valid fullname');
//                   return;
//                 }
//                 if (!emailController.text.contains('@')) {
//                   showSnackBar('Please provide valid email address');
//                   return;
//                 }
//                 if (phoneController.text.length != 11) {
//                   showSnackBar('Provide valid phone number');
//                   return;
//                 }
//                 if (passwordController.text.length < 8) {
//                   showSnackBar('Password must be at least 8 characters');
//                   return;
//                 }
//                 registerUser();
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// */

// import 'package:capstone_project/bin/mydata.dart';
// import 'package:flutter/material.dart';

// class StepperBody extends StatefulWidget {
//   @override
//   _StepperBodyState createState() => new _StepperBodyState();
// }

// class _StepperBodyState extends State<StepperBody> {
//   int currStep = 0;
//   static var _focusNode = new FocusNode();
//   GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
//   static MyData data = new MyData();

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() {
//       setState(() {});
//       print('Has focus: $_focusNode.hasFocus');
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   List<Step> steps = [
//     new Step(
//         title: const Text('Name'),
//         //subtitle: const Text('Enter your name'),
//         isActive: true,
//         //state: StepState.error,
//         state: StepState.indexed,
//         content: new TextFormField(
//           focusNode: _focusNode,
//           keyboardType: TextInputType.text,
//           autocorrect: false,
//           onSaved: (String value) {
//             data.name = value;
//           },
//           maxLines: 1,
//           //initialValue: 'Aseem Wangoo',
//           validator: (value) {
//             if (value.isEmpty || value.length < 1) {
//               return 'Please enter name';
//             }
//           },
//           decoration: new InputDecoration(
//               labelText: 'Enter your name',
//               hintText: 'Enter a name',
//               //filled: true,
//               icon: const Icon(Icons.person),
//               labelStyle:
//                   new TextStyle(decorationStyle: TextDecorationStyle.solid)),
//         )),
//     new Step(
//         title: const Text('Phone'),
//         //subtitle: const Text('Subtitle'),
//         isActive: true,
//         //state: StepState.editing,
//         state: StepState.indexed,
//         content: new TextFormField(
//           keyboardType: TextInputType.phone,
//           autocorrect: false,
//           validator: (value) {
//             if (value.isEmpty || value.length < 10) {
//               return 'Please enter valid number';
//             }
//           },
//           onSaved: (String value) {
//             data.phone = value;
//           },
//           maxLines: 1,
//           decoration: new InputDecoration(
//               labelText: 'Enter your number',
//               hintText: 'Enter a number',
//               icon: const Icon(Icons.phone),
//               labelStyle:
//                   new TextStyle(decorationStyle: TextDecorationStyle.solid)),
//         )),
//     new Step(
//         title: const Text('Email'),
//         // subtitle: const Text('Subtitle'),
//         isActive: true,
//         state: StepState.indexed,
//         // state: StepState.disabled,
//         content: new TextFormField(
//           keyboardType: TextInputType.emailAddress,
//           autocorrect: false,
//           validator: (value) {
//             if (value.isEmpty || !value.contains('@')) {
//               return 'Please enter valid email';
//             }
//           },
//           onSaved: (String value) {
//             data.email = value;
//           },
//           maxLines: 1,
//           decoration: new InputDecoration(
//               labelText: 'Enter your email',
//               hintText: 'Enter a email address',
//               icon: const Icon(Icons.email),
//               labelStyle:
//                   new TextStyle(decorationStyle: TextDecorationStyle.solid)),
//         )),
//     new Step(
//         title: const Text('Age'),
//         // subtitle: const Text('Subtitle'),
//         isActive: true,
//         state: StepState.indexed,
//         content: new TextFormField(
//           keyboardType: TextInputType.number,
//           autocorrect: false,
//           validator: (value) {
//             if (value.isEmpty || value.length > 2) {
//               return 'Please enter valid age';
//             }
//           },
//           maxLines: 1,
//           onSaved: (String value) {
//             data.age = value;
//           },
//           decoration: new InputDecoration(
//               labelText: 'Enter your age',
//               hintText: 'Enter age',
//               icon: const Icon(Icons.explicit),
//               labelStyle:
//                   new TextStyle(decorationStyle: TextDecorationStyle.solid)),
//         )),
//     // new Step(
//     //     title: const Text('Fifth Step'),
//     //     subtitle: const Text('Subtitle'),
//     //     isActive: true,
//     //     state: StepState.complete,
//     //     content: const Text('Enjoy Step Fifth'))
//   ];

//   @override
//   Widget build(BuildContext context) {
//     void showSnackBarMessage(String message,
//         [MaterialColor color = Colors.red]) {
//       Scaffold.of(context)
//           .showSnackBar(new SnackBar(content: new Text(message)));
//     }

//     void _submitDetails() {
//       final FormState formState = _formKey.currentState;

//       if (!formState.validate()) {
//         showSnackBarMessage('Please enter correct data');
//       } else {
//         formState.save();
//         print("Name: ${data.name}");
//         print("Phone: ${data.phone}");
//         print("Email: ${data.email}");
//         print("Age: ${data.age}");

//         showDialog(
//             context: context,
//             child: new AlertDialog(
//               title: new Text("Details"),
//               //content: new Text("Hello World"),
//               content: new SingleChildScrollView(
//                 child: new ListBody(
//                   children: <Widget>[
//                     new Text("Name : " + data.name),
//                     new Text("Phone : " + data.phone),
//                     new Text("Email : " + data.email),
//                     new Text("Age : " + data.age),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 new FlatButton(
//                   child: new Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ));
//       }
//     }

//     return new Container(
//         child: new Form(
//       key: _formKey,
//       child: new ListView(children: <Widget>[
//         new Stepper(
//           steps: steps,
//           type: StepperType.vertical,
//           currentStep: this.currStep,
//           onStepContinue: () {
//             setState(() {
//               if (currStep < steps.length - 1) {
//                 currStep = currStep + 1;
//               } else {
//                 currStep = 0;
//               }
//               // else {
//               // Scaffold
//               //     .of(context)
//               //     .showSnackBar(new SnackBar(content: new Text('$currStep')));

//               // if (currStep == 1) {
//               //   print('First Step');
//               //   print('object' + FocusScope.of(context).toStringDeep());
//               // }

//               // }
//             });
//           },
//           onStepCancel: () {
//             setState(() {
//               if (currStep > 0) {
//                 currStep = currStep - 1;
//               } else {
//                 currStep = 0;
//               }
//             });
//           },
//           onStepTapped: (step) {
//             setState(() {
//               currStep = step;
//             });
//           },
//         ),
//         new RaisedButton(
//           child: new Text(
//             'Save details',
//             style: new TextStyle(color: Colors.white),
//           ),
//           onPressed: _submitDetails,
//           color: Colors.blue,
//         ),
//       ]),
//     ));
//   }
// }


// flutter pub run flutter_launcher_icons:main