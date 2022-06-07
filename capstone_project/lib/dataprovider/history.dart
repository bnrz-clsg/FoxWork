import 'package:firebase_database/firebase_database.dart';

class History {
  String pickup;
  String name;
  String status;
  String createdAt;
  String count;

  History({
    this.pickup,
    this.name,
    this.status,
    this.createdAt,
    this.count,
  });

  History.fromSnapshot(DataSnapshot snapshot) {
    pickup = snapshot.value['current_location'];
    name = snapshot.value['e_username'];
    createdAt = snapshot.value['created_at'];
    status = snapshot.value['status'];
    count = snapshot.value['number_person'].toString();
  }
}
