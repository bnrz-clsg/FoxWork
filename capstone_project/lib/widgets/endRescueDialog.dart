import 'package:capstone_project/style/brandcolor.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:flutter/material.dart';

import 'bradDivider.dart';

class EndRescue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text('RESCUE SUCCESSFUL'),
            SizedBox(
              height: 20,
            ),
            BrandDivider(),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 230,
              child: WildRaisedButton(
                title: 'RESCUED',
                color: BrandColors.colorGreen,
                onPressed: () {
                  Navigator.pop(context, 'close');
                },
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
