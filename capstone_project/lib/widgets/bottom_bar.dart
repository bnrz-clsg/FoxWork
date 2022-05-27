import 'package:capstone_project/screens/setting_screen.dart';
import 'package:capstone_project/screens/signin_screen.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:capstone_project/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../auth.dart';
import 'button_widget.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              width: MediaQuery.of(context).size.width / 1,
              height: 50,
              decoration: BoxDecoration(
                  color: CustomTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => ShelterInfo()));
                        },
                        child: Image.asset('assets/images/app_bar_icon.png',
                            height: 35)),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF00ffee),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: []),
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: CircleAvatar(
                              radius: 13,
                              backgroundImage: NetworkImage(
                                (imageUrl != null) ? imageUrl : ' ',
                              ),
                            ),
                          ),
                        ),
                        //Account & Setting Button
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
                        //Logout Button
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(AppContent.areYouSureLogout),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(15)),
                                    actionsPadding:
                                        EdgeInsets.only(right: 15.0),
                                    actions: <Widget>[
                                      GestureDetector(
                                          onTap: () async {
                                            signOutEmail();
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) {
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
