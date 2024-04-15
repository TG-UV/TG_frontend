import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tg_frontend/screens/loginAndRegister/user_register.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 16),
              Row(children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                const SizedBox(width: 15),
                Text(
                  "Regístrate",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 26),
                ),
                const SizedBox(width: 5),
                Image.asset(
                  'assets/1200px-U+2301.svg.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                )
              ]),
              SizedBox(height: MediaQuery.of(context).size.height / 16),
              Text(
                'Selecciona el tipo de cuenta que deseas crear',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),
              LargeButton(
                  text: 'Pasajero',
                  large: true,
                  onPressed: () {
                    Get.to(() => const UserRegister(userType: 3));
                  }),
              const SizedBox(height: 10),
              Text(
                'Separa y reserva tus viajes',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.bold),
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
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 100),
              Text(
                'Al registrarte estás aceptando los Términos y Condiciones y la Política de Privacidad de Rayo',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }
}
