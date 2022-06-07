import 'package:capstone_project/dataprovider/appdata.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_project/screens/historypage.dart';

class DashboardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: CustomTheme.screenTitleColor,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Icon(Icons.face, size: 75, color: Colors.white),
                SizedBox(height: 20),
                Text(
                  '${Provider.of<AppData>(context).totalRescued}',
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 40,
                      fontFamily: 'Brand-Bold'),
                ),
                Text(
                  ' People Rescued',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Brand-Bold'),
                )
              ],
            ),
          ),
        ),
        Container(
          color: Colors.grey,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Image.asset(
                  'assets/images/rescuer_icon.png',
                  width: 70,
                ),
                SizedBox(height: 20),
                Text(
                  '${Provider.of<AppData>(context).rescueCount.toString()}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Brand-Bold'),
                ),
                Text(
                  'Rescue Operations',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Brand-Bold'),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryPage()));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View History',
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.double_arrow),
              ],
            ),
          ),
        ),
        Divider(thickness: 2),
      ],
    );
  }
}
