import 'dart:io';

import 'package:capstone_project/auth.dart';
import 'package:capstone_project/models/user.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/widgets/preogressDialog.dart';
import 'package:capstone_project/widgets/text_field.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;

class UserRegistration extends StatefulWidget {
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final _formKey = GlobalKey<FormState>();
  static MeUser data = new MeUser();
  TextEditingController dateinput = TextEditingController();

//Start image upload section
  String userPhotoUrl = "";
  File _image;
  final picker = ImagePicker();

  upload() async {
    showDialog(
        context: context,
        builder: (_) {
          return ProgressDialog();
        });

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    firebaseStorage.Reference reference =
        firebaseStorage.FirebaseStorage.instance.ref().child(fileName);
    firebaseStorage.UploadTask uploadTask = reference.putFile(_image);
    firebaseStorage.TaskSnapshot storageTaskSnapshot =
        await uploadTask.whenComplete(() {});

    await storageTaskSnapshot.ref.getDownloadURL().then((url) {
      userPhotoUrl = url;
//      print(userPhotoUrl);
      _registerUser(context);
    });
  }

// End image upload section

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  void _handleRadioValueChanged(value) {
    setState(() {
      this._groupValue = value;
      if (value == 1) {
        data.gender = 'female';
      } else if (value == 0) {
        data.gender = 'male';
      } else {
        data.gender = 'unspecified';
      }
    });
  }

  //here you declare the value of group value
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: new Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        chooseImage();
                      },
                      child: CircleAvatar(
                        radius: _screenWidth * 0.20,
                        backgroundColor: Colors.deepPurple[100],
                        backgroundImage:
                            _image == null ? null : FileImage(_image),
                        child: _image == null
                            ? Icon(
                                Icons.add_photo_alternate,
                                size: _screenWidth * 0.20,
                                color: Colors.white,
                              )
                            : null,
                      )),
                  FormTextInput(
                      hint: 'Fullname',
                      hintText: 'Surname, Name, M.I.',
                      readOnly: false,
                      icon: Icon(Icons.account_circle),
                      onSave: (String value) {
                        data.username = value;
                      }),
                  FormTextInput(
                      hint: 'Phone number',
                      hintText: '0900 000 0000',
                      keebsType: TextInputType.number,
                      readOnly: false,
                      icon: Icon(Icons.phone_android),
                      onSave: (String value) {
                        data.phone = value;
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: email,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  _textDatePicker(),
                  _genderRadio(_groupValue, _handleRadioValueChanged),
                  _address(),
                  WildRaisedButton(
                    onPressed: () {
                      _registerUser(context);
                    },
                    title: 'Submit',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
        FormTextInput(
            hint: 'Lot no., Street, Subdivision/Vilage, ',
            hintText: 'Lot no., Street, Subdivision/Vilage',
            keebsType: TextInputType.text,
            readOnly: false,
            icon: Icon(Icons.tag),
            onSave: (String value) {
              data.houseAddrs = value;
            }),
        FormTextInput(
            hint: 'City/Province',
            hintText: 'Paranaque',
            keebsType: TextInputType.text,
            readOnly: false,
            icon: Icon(Icons.place),
            onSave: (String value) {
              data.city = value;
            }),
        FormTextInput(
            hint: 'Barangay',
            hintText: 'Barangay',
            keebsType: TextInputType.text,
            readOnly: false,
            icon: null,
            onSave: (String value) {
              data.address = value;
            }),
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

  Widget _textDatePicker() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: dateinput,
        onSaved: (String value) {
          data.birthday = value;
        }, //editing controller of this TextField
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
      ),
    );
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File file = File(pickedFile.path);

    setState(() {
      _image = file;
    });
  }

  void _registerUser(context) {
    final FormState isValid = _formKey.currentState;
    if (!isValid.validate()) {
      print('invalid input');
    } else {
      isValid.save();
      String uid = currentFirebaseUser.uid;

      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users/$uid');

      Map<String, dynamic> map = {
        'status': 'approve',
        'created_at': formattedDate,
        'email': email,
        'username': data.username,
        'birthday': data.birthday,
        'gender': data.gender,
        'address': data.houseAddrs,
        'phone': data.phone,
        'imgPro': userPhotoUrl,
      };
      userRef.set(map);
    }
  }
}
