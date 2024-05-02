import 'package:flutter/material.dart';

class MapScreenProvider extends ChangeNotifier {
  bool _showNotificationCard = false;

  bool get showNotificationCard => _showNotificationCard;

  void setShowNotificationCard(bool value) {
    _showNotificationCard = value;
    notifyListeners();
  }
}
