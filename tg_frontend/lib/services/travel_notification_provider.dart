import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';

class TravelNotificationProvider extends ChangeNotifier {
  bool _isTravelNotification = false;
  bool _isCurrentTravelNotification = false;
  late Travel _currentTravel;
  late int _idTravelNotification = -1;
  // bool _isTravelCardNotification = false;

  bool get isTavelNotification => _isTravelNotification;
  bool get isCurrentTravelNotification => _isCurrentTravelNotification;
  Travel get currentTravel => _currentTravel;
  int get idTravelNotification => _idTravelNotification;

  //bool get isTravelCardNotification => _isTravelCardNotification;

  void setCurrentTravelNotification(bool value) {
    _isCurrentTravelNotification = value;
    notifyListeners();
  }

  void setTravelNotification(bool value) {
    _isTravelNotification = value;
    print(_isTravelNotification);
    notifyListeners();
  }

  void setCurrentTravel(notificationBody) {}

  void setIdTravelNotification(notificationAdditionalInfo) {
    _idTravelNotification = notificationAdditionalInfo;
  }

  // void setTravelCardNotification(bool value) {
  //   _isTravelCardNotification = value;
  //   notifyListeners();
  // }
}
