import 'package:flutter/material.dart';

class WildRaisedButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;
  final TextStyle style;
  final Icon icon;

  // final padding;
  final size;

  WildRaisedButton({
    this.title,
    this.onPressed,
    this.color,
    this.style,
    this.icon,
    // this.padding,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(title),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: Colors.white,
        minimumSize: size,
        textStyle: style,
        elevation: 5,
        padding: EdgeInsets.symmetric(horizontal: 16),
        // tapTargetSize: size,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
