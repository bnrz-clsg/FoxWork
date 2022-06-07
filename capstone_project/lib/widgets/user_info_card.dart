import 'package:capstone_project/models/shelters.dart';
import 'package:capstone_project/models/user.dart';
import 'package:capstone_project/screens/rescuerregistration.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

Widget userInfoCard(Shelters authUser, context, authUserUpdated) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    (imageUrl != null) ? imageUrl : ' ',
                    width: 74,
                    height: 74,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      currentSheltersInfo.fullname,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(currentSheltersInfo.email),
                  ],
                ),
              ],
            ),
            Image.asset(
              'assets/images/common/arrow_forward.png',
              scale: 2.5,
            ),
          ],
        ),
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: CustomTheme.boxShadow,
        color: Colors.white,
      ),
    ),
  );
}
