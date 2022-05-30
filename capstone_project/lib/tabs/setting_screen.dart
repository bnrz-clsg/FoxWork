import 'package:capstone_project/auth.dart';
import 'package:capstone_project/models/shelters.dart';
import 'package:capstone_project/models/user.dart';
import 'package:capstone_project/screens/signin_screen.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:capstone_project/utils/strings.dart';
import 'package:capstone_project/widgets/button_widget.dart';
import 'package:capstone_project/widgets/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Shelters authUser = Shelters();
  String output = "";
  PackageInfo _packageInfo = PackageInfo(
    appName: 'AppName',
    version: 'Unknown',
    buildNumber: 'Unknown',
    packageName: 'Unknown',
  );

  //authUserUpdated will be called from edit profile screen if user update user info.
  void authUserUpdated() {
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _renderAppBar(),
                if (authUser != null)
                  userInfoCard(authUser, context, authUserUpdated),
                if (authUser != null) logoutSection(),
                // appThemeVersionPrivacy(context),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    AppContent.copyrightText,
                    textAlign: TextAlign.center,
                    style: CustomTheme.smallTextStyleRegular,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderAppBar() {
    return Padding(
      padding: EdgeInsets.only(top: 40.0, bottom: 28.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppContent.titleSettingsScreen,
                style: CustomTheme.screenTitle,
              ),
              Text(
                AppContent.subTitleSettingsScreen,
                style: CustomTheme.displayTextOne,
              )
            ],
          )),
    );
  }

  Widget appThemeVersionPrivacy(context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: () {},
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            title: Text(
              AppContent.rateAndReview,
              style: CustomTheme.displayTextOne,
            ),
            trailing: Image.asset(
              'assets/images/common/arrow_forward.png',
              scale: 2.5,
            ),
          ),
          Divider(
            color: CustomTheme.grey,
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            title: Text(
              AppContent.version,
              style: CustomTheme.displayTextOne,
            ),
            trailing: Text(
              "${_packageInfo.version}(${_packageInfo.buildNumber})",
              style: CustomTheme.displayTextOne,
            ),
          ),
          Divider(
            color: CustomTheme.grey,
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            onTap: () {},
            title: Text(
              AppContent.privacyPolicy,
              style: CustomTheme.displayTextOne,
            ),
            trailing: Image.asset(
              'assets/images/common/arrow_forward.png',
              scale: 2.5,
            ),
          ),
        ],
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: CustomTheme.boxShadow,
        color: Colors.white,
      ),
    );
  }

// logout section
  Widget logoutSection() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: GestureDetector(
        onTap: () {
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
                        child: HelpMe()
                            .submitButton(60, AppContent.noText, height: 30.0)),
                  ],
                );
              });
        },
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                title: Text(
                  AppContent.logout,
                  style: CustomTheme.alartTextStyle,
                ),
              ),
            ],
          ),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: CustomTheme.boxShadow,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
