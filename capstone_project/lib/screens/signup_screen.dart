import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:capstone_project/utils/strings.dart';
import 'package:capstone_project/widgets/login_header.dart';
import 'package:capstone_project/widgets/progress_message_dialog.dart';
import 'package:capstone_project/widgets/termsandcondition.dart';
import 'package:capstone_project/widgets/text_field.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'signin_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'SignupScreen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _formOne = GlobalKey<FormState>();
  final _formTwo = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final dateinput = TextEditingController();
  final _homeAddress = TextEditingController();
  final _localAddress = TextEditingController();
  final _cityAddress = TextEditingController();
  final teamName = TextEditingController();
  final teamCount = TextEditingController();
  final companyName = TextEditingController();

  var _gender;

  bool _passwordVisible;
  double userInfoHeight = 0;
  double rescuerInfoHeight = 0;
  int _groupValue = -1;

  void _handleRadioValueChanged(value) {
    setState(() {
      this._groupValue = value;
      if (value == 1) {
        _gender = 'female';
      } else if (value == 0) {
        _gender = 'male';
      } else {
        _gender = 'unspecified';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Stack(
        children: [
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
                      Form(
                        key: _formKey,
                        child: Card(
                          color: CustomTheme.backgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 20),
                                FormText(
                                  hint: AppContent.username,
                                  hintText: AppContent.enterUsername,
                                  obscure: false,
                                  controller: _usernameController,
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 4) {
                                      return 'Please provide complete name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                FormText(
                                  hint: AppContent.email,
                                  hintText: AppContent.enterUserEmail,
                                  obscure: false,
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value.isEmpty || !value.contains('@')) {
                                      return 'Pelase enter a valid email address!';
                                    }
                                    return null;
                                  },
                                  keyType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 10),
                                FormText(
                                  hint: AppContent.password,
                                  hintText: AppContent.enterPassword,
                                  controller: _passwordController,
                                  obscure: !_passwordVisible,
                                  sufixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: CustomTheme.grey,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  validator: (value) {
                                    if (!regex.hasMatch(value)) {
                                      return 'Password must at least 8 characters long! \ncontain 1 UPPERCASE \ncontain 1 lowercase \ncontain 1 number\ncontain 1 special character';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                FormText(
                                  hint: AppContent.repassword,
                                  hintText: AppContent.reEnterPassword,
                                  obscure: !_passwordVisible,
                                  validator: (value) {
                                    if (value != _passwordController.text) {
                                      return 'Password must be same as above';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                WildRaisedButton(
                                  onPressed: () {
                                    final isValid =
                                        _formKey.currentState.validate();
                                    if (isValid) {
                                      setState(() {
                                        userInfoHeight = 550;
                                      });
                                    }
                                  },
                                  color: Colors.blue,
                                  title: AppContent.continueText,
                                  size: Size(double.infinity, 40),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 15),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                    child: Text(AppContent.haveAccount),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: termsandconditions(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Form(
              key: _formOne,
              child: Container(
                height: userInfoHeight,
                color: CustomTheme.backgroundColor,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Personal Info'),
                      SizedBox(height: 10),
                      FormText(
                        hint: AppContent.phone,
                        hintText: AppContent.exPhone,
                        obscure: false,
                        keyType: TextInputType.number,
                        controller: _phoneController,
                        validator: (value) {
                          if (value.length != 11) {
                            return 'Please provide correct phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      _textDatePicker(),
                      SizedBox(height: 10),
                      _genderRadio(_groupValue, _handleRadioValueChanged),
                      SizedBox(height: 10),
                      _address(),
                      SizedBox(height: 10),
                      WildRaisedButton(
                        onPressed: () {
                          final isValid = _formOne.currentState.validate();
                          if (isValid) {
                            setState(() {
                              rescuerInfoHeight = 550;
                              userInfoHeight = 0;
                            });
                          }
                        },
                        color: Colors.blue,
                        title: AppContent.continueText,
                        size: Size(double.infinity, 40),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Form(
              key: _formTwo,
              child: Container(
                height: rescuerInfoHeight,
                color: CustomTheme.backgroundColor,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Rescuer\'s Information'),
                      SizedBox(height: 10),
                      _rescuersInfo(),
                      SizedBox(height: 10),
                      WildRaisedButton(
                        onPressed: () {
                          final isValid = _formTwo.currentState.validate();
                          if (isValid) {
                            setState(() {
                              _emailSignUp(context);
                              rescuerInfoHeight = 0;
                              userInfoHeight = 0;
                            });
                          }
                        },
                        color: Colors.blue,
                        title: AppContent.submit,
                        size: Size(double.infinity, 40),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _emailSignUp(BuildContext context) async {
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
      Map rescuerMap = {
        'teamName': teamName.text.trim(),
        'teamCount': teamCount.text.trim(),
        'companyName': companyName.text.trim(),
      };

      Map<String, dynamic> _map = {
        'created_at': formattedDate,
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'birthday': dateinput.text.trim(),
        'gender': _gender.toString().trim(),
        'address': _homeAddress.text + _localAddress.text + _cityAddress.text,
        'rescuerInfo': rescuerMap,
        'status': 'false',
        'newShelters': 'waiting',
      };
      userRef.child(firebaseUser.uid).set(_map);
      Navigator.pop(context);
      var upMessage = 'Press Continue to go to login page';
      _dialog(upMessage);
    } else {
      // Exit ProgressDialog
      Navigator.pop(context);
      var errorMessages = 'Authentication failed';
      _showErrorDialog(errorMessages);
    }
  }

  void _dialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Registration Successful!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Continue'))
        ],
      ),
    );
  }

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

  _textDatePicker() {
    return TextFormField(
      controller: dateinput, //editing controller of this TextField
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.calendar_today),

        labelText: "Date of Birth", //label text of field
        border: OutlineInputBorder(),
      ),
      readOnly: true, //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(
                1950), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime.now());

        if (pickedDate != null) {
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          //you can implement different kind of Date Format here according to your requirement

          setState(() {
            dateinput.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          print("Date is not selected");
        }
      },
    );
  }

  _address() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Address',
          style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        FormText(
          hint: 'Lot no., Street, Subdivision/Vilage, ',
          hintText: 'Lot no., Street, Subdivision/Vilage',
          obscure: false,
          controller: _homeAddress,
          validator: (value) {
            if (value.isEmpty || value.length < 4) {
              return 'Please provide valid address';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        FormText(
          hint: 'Barangay',
          hintText: 'Barangay',
          obscure: false,
          controller: _localAddress,
          validator: (value) {
            if (value.isEmpty || value.length < 4) {
              return 'Please provide valid address';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        FormText(
          hint: 'City Address',
          hintText: 'City Address',
          obscure: false,
          controller: _cityAddress,
          validator: (value) {
            if (value.isEmpty || value.length < 4) {
              return 'Please provide valid address';
            }
            return null;
          },
        ),
      ],
    );
  }

  _rescuersInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        FormText(
          hint: 'Enter Team Name',
          hintText: 'Team name',
          obscure: false,
          controller: teamName,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please provide info';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        FormText(
          hint: 'Enter Team Count',
          hintText: 'Team Count',
          obscure: false,
          controller: teamCount,
          keyType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please provide info';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        FormText(
          hint: 'Enter Company Name',
          hintText: 'Company name (ex. redcross, coastguard, etc.',
          obscure: false,
          controller: companyName,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please provide info';
            }
            return null;
          },
        ),
      ],
    );
  }

  _genderRadio(int groupValue, handleRadioValueChanged) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Text(
          'Gender',
          style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
                value: 0,
                groupValue: groupValue,
                onChanged: handleRadioValueChanged),
            Text(
              "Male",
              style: new TextStyle(
                fontSize: 14.0,
              ),
            ),
            Radio(
                value: 1,
                groupValue: groupValue,
                onChanged: handleRadioValueChanged),
            Text(
              "Female",
              style: new TextStyle(
                fontSize: 14.0,
              ),
            ),
            Radio(
                value: 2,
                groupValue: groupValue,
                onChanged: handleRadioValueChanged),
            Text(
              "Unspecified",
              style: new TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        )
      ]);
}
