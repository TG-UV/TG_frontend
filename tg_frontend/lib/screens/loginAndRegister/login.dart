import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/widgets/inputField.dart';
import 'package:tg_frontend/widgets/largeButton.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController mailLoginController = TextEditingController();
  final TextEditingController passwordLoginController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Stack(children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(height: 150),
                Text(
                  "Inicia sesión",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 35),
                InputField(
                  controller: mailLoginController,
                  textInput: 'Correo electrónico',
                  textInputType: TextInputType.text,
                  obscure: false,
                  icon: const Icon(Icons.key),
                ),
                const SizedBox(height: 15),
                InputField(
                  controller: passwordLoginController,
                  textInput: 'Contraseña',
                  textInputType: TextInputType.text,
                  obscure: false,
                  icon: const Icon(null),
                ),
                const SizedBox(height: 200),
                LargeButton(
                    text: 'Crear cuenta',
                    large: true,
                    onPressed: () {
                      Get.to(() => {});
                    }),
              ]),
              // child: const GlobalButton(text: 'Iniciar sesión'),

              Positioned(
                  top: 30.0,
                  left: 5.0,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)))
            ])));
  }
}