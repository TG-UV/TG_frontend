import 'package:flutter/material.dart';

class TravelNotificationProvider extends ChangeNotifier {
  bool _isNewPassengerNotification = false;

  bool get isNewPassengerNotification => _isNewPassengerNotification;

  void setNewPassengerNotification(bool value) {
    _isNewPassengerNotification = value;
    notifyListeners();
  }
}
