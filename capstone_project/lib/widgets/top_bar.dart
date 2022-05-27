import 'package:capstone_project/screens/setting_screen.dart';
import 'package:capstone_project/screens/signin_screen.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:capstone_project/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:capstone_project/widgets/button_widget.dart';

import '../auth.dart';

class TopBar extends StatelessWidget {
  final Function onPressed;
  const TopBar({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            blurRadius: 1,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          )
        ], color: CustomTheme.backgroundColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 15),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingScreen()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF303030),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[900],
                                blurRadius: 1,
                                spreadRadius: 0.8,
                                offset: Offset(0.7, 0.7))
                          ]),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                        child: Image.asset(
                            'assets/images/baynihan_appbar_icon.png',
                            height: 30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MyProfile()),
                // );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      (imageUrl != null) ? imageUrl : ' ',
                    ),
                    radius: 12,
                    backgroundColor: Color(0xFF303030),
                  ),
                  SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingScreen()),
                      );
                    },
                    icon: Icon(
                      OMIcons.settings,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(AppContent.areYouSureLogout),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15)),
                              actionsPadding: EdgeInsets.only(right: 15.0),
                              actions: <Widget>[
                                GestureDetector(
                                    onTap: () async {
                                      signOutEmail();
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (context) {
                                        return LoginScreen();
                                      }), ModalRoute.withName('/'));
                                    },
                                    child: HelpMe().accountDeactivate(
                                        60, AppContent.yesText,
                                        height: 30.0)),
                                SizedBox(
                                  width: 8.0,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: HelpMe().submitButton(
                                        60, AppContent.noText,
                                        height: 30.0)),
                              ],
                            );
                          });
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
