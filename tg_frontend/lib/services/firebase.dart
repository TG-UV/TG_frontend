import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg_frontend/services/travel_notification_provider.dart';

class FirebaseService {
  // Singleton pattern
  // static final FirebaseService _instance = FirebaseService._internal();

  // factory FirebaseService() => _instance;

  // FirebaseService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
    final fCMToken = await _firebaseMessaging.getToken();
    final TravelNotificationProvider travelNotificationProvider =
        TravelNotificationProvider();
    print("firebase token: $fCMToken");

    // _firebaseMessaging.getToken().then((token) {

    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      final notificationType = message.data['notification_type'];
      // final notificationProvider =
      //    Provider.of<TravelNotificationProvider>(context, listen: false);
      final notificationBody = message.notification?.body ?? "";
      final notificationAdditionalInfo =
          message.data['additional_info']["travelId"] ?? "";

      if (notificationType == 'travel_notification') {
        travelNotificationProvider.setTravelNotification(true);
        travelNotificationProvider
            .setIdTravelNotification(notificationAdditionalInfo);
      } else if (notificationType == 'current_travel') {
        travelNotificationProvider.setCurrentTravelNotification(true);
        travelNotificationProvider.setCurrentTravel(notificationBody);
      }
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
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}
