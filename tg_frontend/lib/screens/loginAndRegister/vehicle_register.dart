import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/screens/loginAndRegister/password_register.dart';
//import 'package:tg_frontend/screens/vehicleRegister.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/large_button.dart';

class VehicleRegister extends StatefulWidget {
  const VehicleRegister({super.key});

  @override
  State<VehicleRegister> createState() => _VehicleRegisterState();
}

class _VehicleRegisterState extends State<VehicleRegister> {
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 150),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Añade los datos de tu Vehículo",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 35),
                  InputField(
                    controller: vehicleTypeController,
                    textInput: 'Tipo de vehículo',
                    textInputType: TextInputType.text,
                    obscure: false,
                    icon: const Icon(Icons.motorcycle),
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    controller: colorController,
                    textInput: 'Color',
                    textInputType: TextInputType.text,
                    obscure: false,
                    icon: const Icon(null),
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    controller: licensePlateController,
                    textInput: 'Placa',
                    textInputType: TextInputType.text,
                    obscure: false,
                    icon: const Icon(null),
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    controller: brandController,
                    textInput: 'Marca',
                    textInputType: TextInputType.text,
                    obscure: false,
                    icon: const Icon(null),
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    controller: modelController,
                    textInput: 'Modelo',
                    textInputType: TextInputType.text,
                    obscure: false,
                    icon: const Icon(null),
                  ),

                  const SizedBox(height: 80),
                  Container(
                      alignment: Alignment.center,
                      child: LargeButton(
                          text: 'Continuar',
                          large: true,
                          onPressed: () {
                            Get.to(() => const PasswordRegister());
                          })),

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
            ])));
  }
}
