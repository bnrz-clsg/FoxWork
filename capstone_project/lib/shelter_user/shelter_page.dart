import 'package:capstone_project/screens/pin_location_screen.dart';
import 'package:capstone_project/screens/search.dart';
import 'package:capstone_project/screens/setting_screen.dart';
import 'package:capstone_project/shelter_user/rescuerInfo.dart';
import 'package:capstone_project/shelter_user/tabs/home_tab.dart';
import 'package:capstone_project/style/brandcolor.dart';
import 'package:flutter/material.dart';

class ShelterPage extends StatefulWidget {
  static const String id = 'ShelterPage';

  @override
  _ShelterPageState createState() => _ShelterPageState();
}

class _ShelterPageState extends State<ShelterPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int selectedIndex = 0;

  void onItemSelect(int index) {
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[
          HomeTab(),
          RescuerInfo(),
          Search(),
          SettingScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.night_shelter),
            label: 'Shelter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_location),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          )
        ],
        backgroundColor: BrandColors.colorDarkGrey,
        currentIndex: selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 14),
        type: BottomNavigationBarType.fixed,
        onTap: onItemSelect,
      ),
    );
  }
}
