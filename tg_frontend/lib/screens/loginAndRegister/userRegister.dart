import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/screens/loginAndRegister/vehicleRegister.dart';
import 'package:tg_frontend/widgets/inputField.dart';
import 'package:tg_frontend/widgets/largeButton.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Regístrate",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            const SizedBox(height: 50),
            InputField(
              controller: nameController,
              textInput: 'Nombre',
              textInputType: TextInputType.text,
              obscure: false,
              icon: const Icon(Icons.person),
            ),
            const SizedBox(height: 15),
            InputField(
              controller: lastNameController,
              textInput: 'Apellido',
              textInputType: TextInputType.text,
              obscure: false,
              icon: const Icon(Icons.person),
            ),
            const SizedBox(height: 15),
            InputField(
              controller: dateController,
              textInput: 'Fecha de nacimiento',
              textInputType: TextInputType.text,
              obscure: false,
              icon: const Icon(Icons.calendar_today_rounded),
            ),
            const SizedBox(height: 15),
            InputField(
              controller: phoneController,
              textInput: 'Celular',
              textInputType: TextInputType.text,
              obscure: false,
              icon: const Icon(Icons.phone),
            ),
            const SizedBox(height: 15),
            InputField(
              controller: emailController,
              textInput: 'Correo Insitucional',
              textInputType: TextInputType.text,
              obscure: false,
              icon: const Icon(Icons.mail),
            ),
            const SizedBox(height: 15),
            InputField(
              controller: residenceController,
              textInput: 'Ciudad de residencia',
              textInputType: TextInputType.text,
              obscure: false,
              icon: const Icon(Icons.location_city),
            ),
            const SizedBox(height: 100),
            Container(
              alignment: Alignment.center,
              child: LargeButton(
                  text: 'Continuar',
                  large: true,
                  onPressed: () {
                    Get.to(() => const VehicleRegister());
                  }),
            ),
            // child: const GlobalButton(text: 'Iniciar sesión'),
          ],
        ),
        Positioned(
            top: 30.0,
            left: 5.0,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)))
      ],
    )));
  }
}
