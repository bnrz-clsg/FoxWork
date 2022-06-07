import 'package:capstone_project/dataprovider/history.dart';
import 'package:capstone_project/style/theme.dart';
import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final History history;
  HistoryTile({this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/pin_location.png',
                      height: 16,
                      width: 16,
                    ),
                    SizedBox(width: 18),
                    Expanded(
                        child: Container(
                            child: Text(
                      history.pickup,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18),
                    ))),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset(
                    'assets/images/user_icon.png',
                    height: 16,
                    width: 16,
                  ),
                  SizedBox(width: 18),
                  Text(
                    history.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    ' (${history.count})',
                    style: TextStyle(
                      fontFamily: 'Brand-Bold',
                      fontSize: 16,
                      color: CustomTheme.screenTitleColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                '${history.createdAt}',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
