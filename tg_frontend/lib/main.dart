import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/screens/home.dart';
//import 'package:tg_frontend/screens/loginAndRegister/splash.dart';
//import 'package:tg_frontend/screens/welcome.dart';

void main() {
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
      //home: Splash(),
      home: const Home(),
    );
  }

  final ThemeData myTheme = ThemeData.light().copyWith(
    primaryColor: Colors.grey.shade200, // Color primario
    colorScheme: const ColorScheme.light().copyWith(
      primary: Colors.grey.shade200, // Color primario
      secondary: const Color(0x4E504333), // Color secundario
      error: const Color(0xFFDD3D32), // Color terciario (error)
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Jost',
        color: Color(0xFF333333),
        fontSize: 32.0,
        fontWeight: FontWeight.w800,
      ),
      titleMedium: TextStyle(
        // Equivalente a bodyText2
        color: Color(0xFF333333),
        fontFamily: 'Jost',
        fontSize: 22.0,
      ),
      titleSmall: TextStyle(
          // Equivalente a bodyText2
          color: Color(0xFF333333),
          fontFamily: 'Jost',
          fontSize: 18.0,
          fontWeight: FontWeight.bold),
    ),
  );
}
