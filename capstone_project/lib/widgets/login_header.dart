import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 43.0,
            backgroundColor: Color.fromRGBO(110, 110, 110, 10),
            backgroundImage: AssetImage("assets/images/logo_icon_final.png"),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "BAYANIHAN",
            style: TextStyle(
              fontFamily: 'Arial',
              color: Colors.white,
              fontSize: 25,
              letterSpacing: 7,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "evacuation system",
            style: TextStyle(
              fontFamily: 'Brand-Regular',
              color: Colors.black,
              fontSize: 18.0,
              letterSpacing: 1.10,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
