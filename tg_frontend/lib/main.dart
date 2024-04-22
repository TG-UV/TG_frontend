import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/loginAndRegister/splash.dart';
//import 'package:tg_frontend/screens/welcome.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/screens/travelScreens/available_travels.dart';
import 'package:tg_frontend/screens/travelScreens/new_travel.dart';
import 'package:tg_frontend/screens/travelScreens/search_travels.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final environment = Environment();
  await environment.startEnvironment();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
    cardTheme: CardTheme(color: ColorManager.thirdColor, surfaceTintColor: Colors.transparent),
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
