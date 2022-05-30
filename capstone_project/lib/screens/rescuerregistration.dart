//import 'package:capstone_project/auth.dart';
//import 'package:capstone_project/models/shelters.dart';
//import 'package:capstone_project/models/user.dart';
//import 'package:capstone_project/screens/shelter_page.dart';
//import 'package:capstone_project/services/globalvariable.dart';
//import 'package:capstone_project/widgets/text_field.dart';
//import 'package:capstone_project/widgets/wildraisedbutton.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import '../auth.dart';
//
//class RescuerRegistration extends StatefulWidget {
//  @override
//  _RescuerRegistrationState createState() => _RescuerRegistrationState();
//}
//
//class _RescuerRegistrationState extends State<RescuerRegistration> {
//  final _formKey = GlobalKey<FormState>();
//  static Shelters data = new Shelters();
//  TextEditingController dateinput = TextEditingController();
//
//  @override
//  void initState() {
//    dateinput.text = ""; //set the initial value of text field
//    super.initState();
//  }
//
//  var teamName = TextEditingController();
//  var teamCount = TextEditingController();
//  var companyName = TextEditingController();
//
//  void _handleRadioValueChanged(value) {
//    setState(() {
//      this._groupValue = value;
//      if (value == 1) {
//        data.gender = 'female';
//      } else if (value == 0) {
//        data.gender = 'male';
//      } else {
//        data.gender = 'unspecified';
//      }
//    });
//  }
//
//  //here you declare the value of group value
//  int _groupValue = -1;
//
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//      onWillPop: () async => false,
//      child: Scaffold(
//        body: Form(
//          key: _formKey,
//          child: new Center(
//            child: SingleChildScrollView(
//              child: Padding(
//                padding: EdgeInsets.all(10),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    FormTextInput(
//                        hint: 'Fullname',
//                        hintText: 'Surname, Name, M.I.',
//                        readOnly: false,
//                        icon: Icon(Icons.account_circle),
//                        onSave: (String value) {
//                          data.fullname = value;
//                        }),
//                    FormTextInput(
//                        hint: 'Phone number',
//                        hintText: '0900 000 0000',
//                        keebsType: TextInputType.number,
//                        readOnly: false,
//                        icon: Icon(Icons.phone_android),
//                        onSave: (String value) {
//                          data.phone = value;
//                        }),
//                    Padding(
//                      padding: EdgeInsets.all(8.0),
//                      child: TextFormField(
//                        initialValue: email,
//                        readOnly: true,
//                        decoration: InputDecoration(
//                          prefixIcon: Icon(Icons.email),
//                          labelText: 'Email address',
//                          border: OutlineInputBorder(),
//                        ),
//                      ),
//                    ),
//                    _textDatePicker(),
//                    _genderRadio(_groupValue, _handleRadioValueChanged),
//                    _address(),
//                    _rescuerInfo(),
//                    WildRaisedButton(
//                      onPressed: () {a
//                        _registerUser(context);
//                      },
//                      title: 'Submit',
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  _address() {
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Text(
//          'Address',
//          style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//        ),
//        FormTextInput(
//            hint: 'Lot no., Street, Subdivision/Vilage, ',
//            hintText: 'Lot no., Street, Subdivision/Vilage',
//            keebsType: TextInputType.text,
//            readOnly: false,
//            icon: Icon(Icons.tag),
//            onSave: (String value) {
//              data.houseAddrs = value;
//            }),
//        FormTextInput(
//            hint: 'City/Province',
//            hintText: 'Paranaque',
//            keebsType: TextInputType.text,
//            readOnly: false,
//            icon: Icon(Icons.place),
//            onSave: (String value) {
//              data.city = value;
//            }),
//        FormTextInput(
//            hint: 'Barangay',
//            hintText: 'Barangay',
//            keebsType: TextInputType.text,
//            readOnly: false,
//            icon: null,
//            onSave: (String value) {
//              data.brgy = value;
//            }),
//      ],
//    );
//  }
//
//  _rescuerInfo() {
//    return Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Text(
//            'Rescuer(\'s) Information',
//            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//          ),
//          FormTextInput(
//              hint: 'Enter Team Name',
//              hintText: 'Team name',
//              keebsType: TextInputType.text,
//              readOnly: false,
//              icon: Icon(Icons.tag),
//              onSave: (String value) {
//                data.team_name = value;
//              }),
//          FormTextInput(
//              hint: 'Enter Team Count',
//              hintText: 'Team Count',
//              keebsType: TextInputType.text,
//              readOnly: false,
//              icon: Icon(Icons.place),
//              onSave: (String value) {
//                data.team_count = value;
//              }),
//          FormTextInput(
//              hint: 'Enter Company Name',
//              hintText: 'Company name (ex. redcross, coastguard, etc.',
//              keebsType: TextInputType.text,
//              readOnly: false,
//              icon: null,
//              onSave: (String value) {
//                data.brgy = value;
//              }),
//        ]);
//  }
//
//  _genderRadio(int groupValue, handleRadioValueChanged) =>
//      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
//        Text(
//          'Gender',
//          style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Radio(
//                value: 0,
//                groupValue: groupValue,
//                onChanged: handleRadioValueChanged),
//            Text(
//              "Male",
//              style: new TextStyle(
//                fontSize: 14.0,
//              ),
//            ),
//            Radio(
//                value: 1,
//                groupValue: groupValue,
//                onChanged: handleRadioValueChanged),
//            Text(
//              "Female",
//              style: new TextStyle(
//                fontSize: 14.0,
//              ),
//            ),
//            Radio(
//                value: 2,
//                groupValue: groupValue,
//                onChanged: handleRadioValueChanged),
//            Text(
//              "Unspecified",
//              style: new TextStyle(
//                fontSize: 14.0,
//              ),
//            ),
//          ],
//        )
//      ]);
//
//  Widget _textDatePicker() {
//    return Padding(
//      padding: EdgeInsets.all(8.0),
//      child: TextFormField(
//        controller: dateinput,
//        onSaved: (String value) {
//          data.birthday = value;
//        }, //editing controller of this TextField
//        decoration: InputDecoration(
//          prefixIcon: Icon(Icons.calendar_today),
//
//          labelText: "Date of Birth", //label text of field
//          border: OutlineInputBorder(),
//        ),
//        readOnly: true, //set it true, so that user will not able to edit text
//        onTap: () async {
//          DateTime pickedDate = await showDatePicker(
//              context: context,
//              initialDate: DateTime.now(),
//              firstDate: DateTime(
//                  1950), //DateTime.now() - not to allow to choose before today.
//              lastDate: DateTime.now());
//
//          if (pickedDate != null) {
//            print(
//                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
//            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//            print(
//                formattedDate); //formatted date output using intl package =>  2021-03-16
//            //you can implement different kind of Date Format here according to your requirement
//
//            setState(() {
//              dateinput.text =
//                  formattedDate; //set output date to TextField value.
//            });
//          } else {
//            print("Date is not selected");
//          }
//        },
//      ),
//    );
//  }
//
//  void _registerUser(context) {
//    final FormState isValid = _formKey.currentState;
//    if (!isValid.validate()) {
//      print('invalid input');
//    } else {
//      isValid.save();
//      DatabaseReference _userRef = FirebaseDatabase.instance
//          .reference()
//          .child('shelters/${currentFirebaseUser.uid}');
//
//      Map rescuerMap = {
//        'teamName': teamName.text,
//        'teamCount': teamCount.text,
//        'companyName': companyName.text,
//      };
//
//      Map map = {
//        'status': 'true',
//        'created_at': formattedDate,
//        'email': email,
//        'username': data.fullname.trim(),
//        'birthday': data.birthday.trim(),
//        'birthday': data.gender.trim(),
//        'address': data.houseAddrs + data.brgy + data.city,
//        'phone': data.phone.trim(),
//        'rescuerInfo': rescuerMap,
//      };
//      _userRef.set(map);
//      var upMessage = 'Press continue';
//      _dialog(upMessage);
//    }
//  }
//
//  void _dialog(String message) {
//    showDialog(
//      context: context,
//      builder: (ctx) => AlertDialog(
//        title: Text('Registration Successful!'),
//        content: Text(message),
//        actions: <Widget>[
//          TextButton(
//              onPressed: () {
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => ShelterPage()));
//              },
//              child: Text('Continue'))
//        ],
//      ),
//    );
//  }
//}
