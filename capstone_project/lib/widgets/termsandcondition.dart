import 'package:capstone_project/utils/strings.dart';
import 'package:flutter/material.dart';

Widget termsandconditions() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppContent.termsFirst,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            AppContent.terms,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppContent.and,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            AppContent.policy,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ],
  );
}
