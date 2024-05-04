import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg_frontend/services/travel_notification_provider.dart';

class FirebaseService {
  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeFirebaseMessaging(context) async {
    _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    // _firebaseMessaging.getToken().then((token) {

    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      final notificationType = message.data['notification_type'];
      final notificationProvider =
          Provider.of<TravelNotificationProvider>(context, listen: false);
      final notificationBody = message.notification?.body ?? "";
      final notificationAdditionalInfo =
          message.data['additional_info']["travelId"] ?? "";

      if (notificationType == 'travel_notification') {
        notificationProvider.setTravelNotification(true);
        notificationProvider
            .setIdTravelNotification(notificationAdditionalInfo);
      } else if (notificationType == 'current_travel') {
        notificationProvider.setCurrentTravelNotification(true);
        notificationProvider.setCurrentTravel(notificationBody);
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
        final notificationProvider =
            Provider.of<TravelNotificationProvider>(context, listen: false);
        final notificationBody = message.notification?.body ?? "";
        final notificationAdditionalInfo =
            message.data['additional_info']["travelId"] ?? "";

        if (notificationType == 'travel_notification') {
          notificationProvider.setTravelNotification(true);
          notificationProvider
              .setIdTravelNotification(notificationAdditionalInfo);
          // Navegar a una pantalla específica aquí
          Navigator.of(context).pushNamed('/travel_details',
              arguments: notificationAdditionalInfo);
        } else if (notificationType == 'current_travel') {
          notificationProvider.setCurrentTravelNotification(true);
          notificationProvider.setCurrentTravel(notificationBody);
          // Navegar a una pantalla específica aquí
          Navigator.of(context).pushNamed('/current_travel');
        }
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


  // // Inicializar Firebase
  // Future<void> initializeFirebase() async {
  //   await Firebase.initializeApp();
  //   _configureFirebaseMessaging();
  // }

  // // Configurar Firebase Messaging
  // void _configureFirebaseMessaging() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');

  //     if (message.notification != null) {
  //       print('Message also contained a notification: ${message.notification}');
  //     }
  //   });
  // }


//   // Método para enviar una notificación a un dispositivo específico
//   Future<void> sendNotificationToDevice(String deviceToken, String title, String body) async {
//     try {
//       await FirebaseMessaging.instance.send(
//         Message(
//           notification: Notification(
//             title: title,
//             body: body,
//           ),
//           token: deviceToken,
//         ),
//       );
//       print("Notification sent successfully!");
//     } catch (e) {
//       print("Failed to send notification: $e");
//     }
//   }
// }
