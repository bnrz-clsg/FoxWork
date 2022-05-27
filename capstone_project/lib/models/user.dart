import 'package:firebase_database/firebase_database.dart';

class MeUser {
  String id;
  String username;
  String phone;
  String email;
  String birthday;
  String houseAddrs;
  String city;
  String zipcode;
  String address;
  String gender;
  String occupation;
  String emergencyName;
  String emergencyPhone;
  String idType;
  String adNumber;
  String status;

  MeUser({
    this.email, //
    this.username, //
    this.phone, //
    this.id, //
    this.birthday, //
    this.houseAddrs,
    this.city,
    this.zipcode,
    this.address, //
    this.gender, //
    this.occupation, //
    this.emergencyName, //
    this.emergencyPhone, //
    this.idType, //
    this.adNumber, //
    this.status, //
  });

  MeUser.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    status = snapshot.value['status'];
    username = snapshot.value['username'];
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    birthday = snapshot.value['birthday'];
    address = snapshot.value['address'];
    gender = snapshot.value['gender'];
    occupation = snapshot.value['occupation'];
    idType = snapshot.value['idType'];
    adNumber = snapshot.value['idNumber'];
    emergencyName = snapshot.value['emergencyName'];
    emergencyPhone = snapshot.value['emergencyPhone'];
  }

 
}
