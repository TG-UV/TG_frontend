import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
//import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/loginAndRegister/splash.dart';
//import 'package:tg_frontend/screens/welcome.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tg_frontend/services/firebase.dart';
import 'package:tg_frontend/services/travel_notification_provider.dart';
import 'firebase_options.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();

//   print("Handling a background message: ${message.messageId}");
// }

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final environment = Environment();
  await environment.startEnvironment();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseService().initializeFirebaseMessaging();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TravelNotificationProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('es', 'ES'),
      debugShowCheckedModeBanner: false,
      title: 'Rayo',
      theme: myTheme,
      builder: EasyLoading.init(),
      home: const Splash(),
      //home: const Home(),
    );
  }

  final ThemeData myTheme = ThemeData.light().copyWith(
    cardColor: ColorManager.fourthColor,

    cardTheme: CardTheme(
        color: ColorManager.thirdColor,
        surfaceTintColor: Color.fromARGB(162, 239, 239, 239)),
    datePickerTheme: DatePickerThemeData(
        backgroundColor: ColorManager.staticColor,
        headerHeadlineStyle: TextStyle(color: ColorManager.primaryColor),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(ColorManager.primaryColor),
          //backgroundColor: MaterialStateProperty.all(ColorManager.primaryColor),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(ColorManager.primaryColor),
        )),
    dialogBackgroundColor: ColorManager.thirdColor,
    primaryColor: ColorManager.thirdColor, // Color primario
    colorScheme: const ColorScheme.light().copyWith(
      primary: ColorManager.thirdColor, // Color primario
      secondary: ColorManager.secondaryColor,
      error: ColorManager.fourthColor,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
          fontFamily: 'Jost',
          color: ColorManager.primaryColor,
          fontSize: 28.0,
          fontWeight: FontWeight.w800,
          overflow: TextOverflow.ellipsis),
      titleMedium: TextStyle(
          // Equivalente a bodyText2
          color: ColorManager.primaryColor,
          fontFamily: 'Jost',
          fontSize: 22.0,
          overflow: TextOverflow.ellipsis),
      titleSmall: TextStyle(
        fontFamily: 'Jost',
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: ColorManager.primaryColor,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
