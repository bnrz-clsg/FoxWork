import 'package:firebase_database/firebase_database.dart';

class Shelters {
  String fullname;
  String phone;
  String email;
  String id;
  String birthday;
  String houseAddrs;
  String city;
  String brgy;
  String address;
  String gender;
  String company_name;
  String team_count;
  String team_name;

  Shelters(
      {this.fullname,
      this.phone,
      this.email,
      this.id,
      this.birthday,
      this.houseAddrs,
      this.city,
      this.brgy,
      this.address,
      this.gender,
      this.company_name,
      this.team_count,
      this.team_name});

  Shelters.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    fullname = snapshot.value['username'];
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    birthday = snapshot.value['birthday'];
    gender = snapshot.value['birthday'];
    address = snapshot.value['gender'];
    company_name = snapshot.value['rescuerInfo']['companyName'];
    team_count = snapshot.value['rescuerInfo']['teamCount'];
    team_name = snapshot.value['rescuerInfo']['teamName'];
  }
}
