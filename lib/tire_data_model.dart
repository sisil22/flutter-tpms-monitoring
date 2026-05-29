import 'package:flutter/foundation.dart';

class TireDataModel extends ChangeNotifier {
  List<Map<String, dynamic>> tireDataList = [];

void updateTireDataList(List<Map<String, dynamic>> newDataList) {
  tireDataList = newDataList;

  notifyListeners();
}

  double? frontRightPressure;
  double? frontRightTemp;
  double? frontLeftPressure;
  double? frontLeftTemp;
  double? backLeftPressure;
  double? backLeftTemp;
  double? backRightPressure;
  double? backRightTemp;
  
  ValueNotifier<Map<String, dynamic>> tireDataNotifier =
  ValueNotifier<Map<String, dynamic>>({});

  void updateTireData({
    double? frontRightPressure,
    double? frontRightTemp,
    double? frontLeftPressure,
    double? frontLeftTemp,
    double? backLeftPressure,
    double? backLeftTemp,
    double? backRightPressure,
    double? backRightTemp,
  }) {
    this.frontRightPressure = frontRightPressure;
    this.frontRightTemp = frontRightTemp;
    this.frontLeftPressure = frontLeftPressure;
    this.frontLeftTemp = frontLeftTemp;
    this.backLeftPressure = backLeftPressure;
    this.backLeftTemp = backLeftTemp;
    this.backRightPressure = backRightPressure;
    this.backRightTemp = backRightTemp;

    notifyListeners();
  }
}
