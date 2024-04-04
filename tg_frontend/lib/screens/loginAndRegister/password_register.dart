import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/services/auth_services.dart';

class PasswordRegister extends StatefulWidget {
  const PasswordRegister({super.key, required this.user, this.vehicle});
  final User user;
  final Vehicle? vehicle;
  @override
  State<PasswordRegister> createState() => _PasswordRegisterState();
}

class _PasswordRegisterState extends State<PasswordRegister> {
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
      int sent = 1;

  void submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      widget.user.password = passwordConfirmationController.text;
   //   int idUser= await userDatasourceImpl.insertUserRemote(user: widget.user);
     // if (idUser != 0) {
      if (sent == 1) {
        User newUser = await userDatasourceImpl.getUserLocal(21);
        // if (widget.vehicle != null) {
        //   Vehicle newVehicle = Vehicle(
        //     idVehicle: widget.vehicle!.idVehicle,
        //     owner: newUser.idUser,
        //     vehicleBrand: widget.vehicle!.vehicleBrand,
        //     vehicleColor: widget.vehicle!.vehicleColor,
        //     vehicleModel: widget.vehicle!.vehicleModel,
        //     vehicleType: widget.vehicle!.vehicleType,
        //     licensePlate: widget.vehicle!.licensePlate,
        //   );
        //   await userDatasourceImpl.insertVehicleRemote(vehicle: newVehicle);
        // }
        saveAuthInformation(newUser, newUser.email, passwordConfirmationController.text);
      }
    } else {
      AlertDialog(
          title: const Text("Error"),
          content: const SingleChildScrollView(
              child: ListBody(
            children: <Widget>[
              Text("Faltan campos por completar."),
            ],
          )),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Aceptar"))
          ]);
    }
  }

  void saveAuthInformation(user, username, password) async {
    final token = await userDatasourceImpl.getUserAuth(
        username: username, password: password);
    if (token != null) {
      await AuthStorage().saveToken(token!);
      await AuthStorage().saveNickname(username);
      await AuthStorage().savePassword(password);

      Environment.sl.registerSingleton<User>(user);
      Get.to(() => const Home());
    } else {
      print('Error al intentar registrar el user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Form(
                key: _formKey, // Aquí se usa la clave _formKey
                child: Stack(children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              submitForm(context);
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
                ]))));
  }
}
