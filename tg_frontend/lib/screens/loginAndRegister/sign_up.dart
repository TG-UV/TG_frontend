import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/loginAndRegister/user_register.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(children: [
      Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Registrate",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 100),
              Text(
                'Selecciona el tipo de cuenta que deseas crear:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 90),
              LargeButton(
                  text: 'Pasajero',
                  large: true,
                  onPressed: () {
                    Get.to(() => const UserRegister(userType: 3));
                  }),
              const SizedBox(height: 10),
              Text(
                'para PEDIR servicios. Separa y organiza tus viajes',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 55),
              LargeButton(
                  text: 'Conductor',
                  large: true,
                  onPressed: () {
                    Get.to(() => const UserRegister(userType: 2));
                  }),
              const SizedBox(height: 10),
              Text(
                'Ofrece tus cupos libres',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 100),
              Text(
                'Al registrarte estás aceptando los Términos y Condiciones y la Política de Privacidad de Rayo',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          )),
      Positioned(
          top: 30.0,
          left: 5.0,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back))),
    ])));
  }
}
