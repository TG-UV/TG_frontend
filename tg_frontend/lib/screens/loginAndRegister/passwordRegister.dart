import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/widgets/inputField.dart';
import 'package:tg_frontend/widgets/largeButton.dart';

class PasswordRegister extends StatefulWidget {
  const PasswordRegister({super.key});

  @override
  State<PasswordRegister> createState() => _PasswordRegisterState();
}

class _PasswordRegisterState extends State<PasswordRegister> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
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
                  "Por último añade una contraseña",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 35),
                InputField(
                  controller: passwordController,
                  textInput: 'Contraseña',
                  textInputType: TextInputType.text,
                  obscure: false,
                  icon: const Icon(Icons.key),
                ),
                const SizedBox(height: 15),
                InputField(
                  controller: passwordConfirmationController,
                  textInput: 'Confirmación de contraseña',
                  textInputType: TextInputType.text,
                  obscure: false,
                  icon: const Icon(null),
                ),
                const SizedBox(height: 200),
                LargeButton(
                    text: 'Crear cuenta',
                    large: true,
                    onPressed: () {
                      Get.to(() => const Home());
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
