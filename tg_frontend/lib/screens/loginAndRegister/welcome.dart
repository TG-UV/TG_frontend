import 'package:flutter/material.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/screens/loginAndRegister/login.dart';
import 'package:tg_frontend/screens/loginAndRegister/sign_up.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  final String userType = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 150),
                        Image.asset(
                          'assets/1200px-U+2301.svg.png',
                          width: 50, // ajusta el ancho según tus necesidades
                          height: 50, // ajusta la altura según tus necesidades
                          fit: BoxFit
                              .cover, // ajusta el modo de ajuste de la imagen
                        ),
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Rayo",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 70),
                        MainButton(
                          text: 'Conductor',
                          large: true,
                          onPressed: () {
                            Get.to(() => const Login());
                          },
                        ),
                        const SizedBox(height: 20),
                        MainButton(
                            text: 'Pasajero',
                            large: true,
                            onPressed: () {
                              Get.to(() => const Login());
                            }),
                        const SizedBox(height: 200),
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: Text(
                                '¿No tienes una cuenta?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  //Get.to(() => const SignUp());
                                  Get.to(() => const SignUp());
                                },
                                child: const Text(
                                  'Regístrate !',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ])))),
    );
  }
}
