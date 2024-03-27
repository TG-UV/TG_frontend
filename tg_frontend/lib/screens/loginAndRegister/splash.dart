import 'package:flutter/material.dart';
//import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/loginAndRegister/login.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:tg_frontend/services/auth_services.dart';

//import 'package:unidrive_driver/ui/utils/global.colors.dart';

class Splash extends StatefulWidget {
  // final Splash({Key? key}) : super(key: key);
  const Splash({super.key});
  @override
  State<Splash> createState() => _LoginState();
}

class _LoginState extends State<Splash> {
  final TextEditingController emailController = TextEditingController();
  final authStorage = AuthStorage();

  @override
  void initState() {
    super.initState();
    verifyLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    // Timer(const Duration(seconds: 3), () {
    //   Get.to(() => const Welcome());
    // });
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.error,
      body: Center(
        child: Image.asset(
          'assets/1200px-U+2301.svg.png',
          width: 100, // ajusta el ancho según tus necesidades
          height: 100, // ajusta la altura según tus necesidades
          fit: BoxFit.cover, // ajusta el modo de ajuste de la imagen
        ),

        /*
        child: InputField(
            controller: emailController,
            textInput: 'Prueba Input',
            textInputType: TextInputType.text,
            icon: const Icon(null),
            obscure: true),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 40),
            LargeButton(text: 'Prueba Boton grande', large: true),
            SizedBox(height: 40),
            LargeButton(text: 'Prueba Boton corto', large: false),
          ],
        ),
       
        child: LargeButton(
          text: 'Prueba Boton',
          large: true,
        ), */
      ),
    );
  }

  Future<bool> verifyAuth() async {
    authStorage.removeValues();
    bool isLoggedIn = false;
    final nickname = await authStorage.getNickName();
    final password = await authStorage.getPassword();
    print('llega a verifyAuth');
    if (nickname != null && password != null) {
      isLoggedIn = true;
    }
    return isLoggedIn;
  }

  Future<void> verifyLoggedIn() async {
    print('llega a verifyLoggedIn');
    Future<bool> isAuth = verifyAuth();
    await isAuth ? Get.to(() => const Home()) : Get.to(() => const Login());
  }
}
