import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeFirebaseMessaging({
    required void Function(RemoteMessage message) onMessageReceived,
    required void Function(String notificationType) onNotificationTypeReceived,
  }) async {
    _firebaseMessaging.requestPermission();
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      onMessageReceived(message);
      onNotificationTypeReceived(message.data['notification_type']);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
      onNotificationTypeReceived(message.data['notification_type']);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Función que maneja los mensajes en segundo plano
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
