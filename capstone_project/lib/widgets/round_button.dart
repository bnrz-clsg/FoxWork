import 'package:capstone_project/style/theme.dart';
import 'package:flutter/material.dart';

Widget googleButton(String iconPath) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        boxShadow: CustomTheme.iconBoxShadow,
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          // ignore: unnecessary_brace_in_string_interps
          'assets/images/${iconPath}.png',
          width: 24,
          height: 24,
        ),
      ),
    ),
  );
}
