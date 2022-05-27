import 'package:flutter/material.dart';

class BaseAlertDialog extends StatelessWidget {
  //When creating please recheck 'context' if there is an error!

  Color _color = Color.fromARGB(220, 117, 218, 255);

  String _title;
  String _content;
  String _yes;
  String _no;
  Function _yesOnPressed;
  Function _noOnPressed;

  BaseAlertDialog(
      {String title,
      String content,
      Function yesOnPressed,
      Function noOnPressed,
      String yes = "Yes",
      String no = "No"}) {
    this._title = title;
    this._content = content;
    this._yesOnPressed = yesOnPressed;
    this._noOnPressed = noOnPressed;
    this._yes = yes;
    this._no = no;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(this._title),
      content: new Text(this._content),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5)),
      actions: <Widget>[
        // ignore: deprecated_member_use
        new FlatButton(
          child: new Text(this._yes),
          textColor: Colors.blue,
          onPressed: () {
            this._yesOnPressed();
          },
        ),
        // ignore: deprecated_member_use
        new FlatButton(
          child: Text(this._no),
          textColor: Colors.red[200],
          onPressed: () {
            this._noOnPressed();
          },
        ),
      ],
    );
  }
}
