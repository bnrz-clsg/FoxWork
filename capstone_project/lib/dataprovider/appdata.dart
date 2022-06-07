import 'package:capstone_project/dataprovider/history.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  String totalRescued = '0';
  int rescueCount = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistory = [];

  void updateTotalRescue(String newRescue) {
    totalRescued = newRescue;
    notifyListeners();
  }

  void updateRescueCount(int newRescueCount) {
    rescueCount = newRescueCount;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistory(History historyItem) {
    tripHistory.add(historyItem);
    notifyListeners();
  }
}
