import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/loginAndRegister/welcome.dart';
import 'dart:async';
import 'package:get/get.dart';

//import 'package:unidrive_driver/ui/utils/global.colors.dart';

class Splash extends StatelessWidget {
  // final Splash({Key? key}) : super(key: key);
  Splash({super.key});
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Get.to(() => const Welcome());
    });
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
}
