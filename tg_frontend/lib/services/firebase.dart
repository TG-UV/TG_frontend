import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/services/travel_notification_provider.dart';

class FirebaseService {
  late dynamic notificationType;
  final travel = Travel(
      id: 1,
      startingPointLat: 0.0,
      startingPointLong: 0.0,
      arrivalPointLat: 1.0,
      arrivalPointLong: 1.0,
      date: '2024-05-12',
      hour: '12:00',
      driver: 0,
      price: 3000,
      seats: 1,
      currentTrip: 0);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final TravelNotificationProvider travelNotificationProvider =
      TravelNotificationProvider();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<String> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token!;
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('El usuario otorgó permisos de notificación');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('El usuario otorgó permisos de notificación provisionales');
    } else {
      print('El usuario denegó permisos de notificación');
    }
  }

  void initializeFirebaseMessaging(BuildContext context) {
    Future<void> firebaseMessagingBackgroundHandler(
        RemoteMessage message) async {
      print("Handling a background message: ${message.data}");
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        print("onMessage on listen: ${message.data}");
        _handleMessage(context, message);
      } else {
        travelNotificationProvider.setTravelNotification(true);
        print("onMessage on listen 2: ${message.data}");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessage OpenedApp: $message");
      _handleMessage(context, message);
    });
  }

  void _showNotification(RemoteMessage message) async {
    final notificationData = message.data;
    String bodyNotificationToShow = "";

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final notificationType = message.data['notification_type'];
 
    switch (notificationType) {
      case 'travel_notification':
        bodyNotificationToShow = "Revisa tus viajes";
        break;
      case 'current_travel':
        bodyNotificationToShow = "Alistate!, tienes un viaje en curso";
        break;
      case 'travel_deny':
        bodyNotificationToShow =
            "Lastimosamente el conductor no pudo aceptar tu cupo";
        break;
      case 'travel_canceled':
        bodyNotificationToShow =
            "Lastimosamente uno de tus viajes se ha cancelado";
        break;
     
    }
    await flutterLocalNotificationsPlugin.show(
      0, // Notificati on ID
      "Nueva novedad!", // Title
      bodyNotificationToShow, // Body
      platformChannelSpecifics,
      payload: 'New Payload',
    );
  }

  void _handleMessage(BuildContext context, RemoteMessage message) {
    String notificationType = message.data['notification_type'];
    String mapNotificationAdditionalInfo = message.data['additional_info'];
    Travel notificationAdditionalInfo =
        Travel.fromJsonNotifications(jsonDecode(mapNotificationAdditionalInfo));
    int idTravel = notificationAdditionalInfo.id;
    print("reults: $notificationType ");

    switch (notificationType) {
      case 'travel_notification':
        travelNotificationProvider.setTravelNotification(true);
        travelNotificationProvider.setIdTravelNotification(idTravel);
        break;
      case 'current_travel':
        travelNotificationProvider.setCurrentTravelNotification(true);
        break;
      case 'travel_deny':
        travelNotificationProvider.setTravelNotification(true);
        break;
      case 'travel_canceled':
        travelNotificationProvider.setTravelNotification(true);
        break;
    }
  }
}
