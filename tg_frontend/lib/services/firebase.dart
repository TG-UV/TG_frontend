import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tg_frontend/main.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/services/travel_notification_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  //Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? fCMToken;
  //String? get idDevice => fCMToken;
  // https://pub.dev/packages/firebase_messaging/versions/11.4.4/example
  String? getFCMToken() {
    return fCMToken;
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.data}");
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState
        ?.pushNamed('/screens/home.dart', arguments: message);
  }

  Future<void> initializeFirebaseMessaging() async {
    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //fCMToken = await _firebaseMessaging.getToken();

    final TravelNotificationProvider travelNotificationProvider =
        TravelNotificationProvider();

    _firebaseMessaging.getToken().then((token) {
      fCMToken = token;
    });
    print("firebase token: $fCMToken");

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.isEmpty) {
        travelNotificationProvider.setTravelNotification(true);
        print("onMessageee: ${message.data}");
      }

      // final notificationType = message.data['notification_type'];
      // // final notificationProvider =
      // //    Provider.of<TravelNotificationProvider>(context, listen: false);
      // final notificationBody = message.notification?.body ?? "";
      // final notificationAdditionalInfo =
      //     message.data['additional_info']["travelId"] ?? "";

      // if (notificationType == 'travel_notification') {

      //   travelNotificationProvider
      //       .setIdTravelNotification(notificationAdditionalInfo);
      // } else if (notificationType == 'current_travel') {
      //   travelNotificationProvider.setCurrentTravelNotification(true);
      //   travelNotificationProvider.setCurrentTravel(notificationBody);
      // }
      // else if (notificationType == 'travel_notification') {
      //   notificationProvider.setTravelCardNotification(true);
      // }
      // print("onMessage: $message");
      // onMessageReceived(message);
      // onNotificationTypeReceived(message.data['notification_type']);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
      // onNotificationTypeReceived(message.data['notification_type']);
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final notificationType = message.data['notification_type'];
        // final notificationProvider =
        //     Provider.of<TravelNotificationProvider>(context, listen: false);
        final notificationBody = message.notification?.body ?? "";
        final notificationAdditionalInfo =
            message.data['additional_info']["travelId"] ?? "";

        // if (notificationType == 'travel_notification') {
        //   travelNotificationProvider.setTravelNotification(true);
        //   travelNotificationProvider
        //       .setIdTravelNotification(notificationAdditionalInfo);
        //   // Navegar a una pantalla específica aquí
        //   Navigator.of(context).pushNamed('/travel_details',
        //       arguments: notificationAdditionalInfo);
        // } else if (notificationType == 'current_travel') {
        //   travelNotificationProvider.setCurrentTravelNotification(true);
        //   travelNotificationProvider.setCurrentTravel(notificationBody);
        //   // Navegar a una pantalla específica aquí
        //   Navigator.of(context).pushNamed('/current_travel');
        // }
      });
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Función que maneja los mensajes en segundo plano
}
