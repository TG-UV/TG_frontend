import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/loginAndRegister/vehicle_register.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';


class UserRegister extends StatefulWidget {
  const UserRegister({super.key, required this.userType});
  final int userType;
  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();

  void submitForm(BuildContext context) async {

    if (_formKey.currentState!.validate()) {
      //List<Travel> travelList = [];
      User user = User(
        idUser: 0,
        identityDocument: nameController.text,
        phoneNumber: phoneController.text,
        firstName: nameController.text,
        lastName: lastNameController.text,
        birthDate: dateController.text,
        residenceCity: residenceController.text,
        type: widget.userType,
        email: "",
        password: "",
        isActive: 1,

          );
      //userDatasourceImpl.insertUserRemote(user: user);
      Get.to(() => const Home());
    } else {
      AlertDialog(
          title: const Text("Error"),
          content: const SingleChildScrollView(
              child: ListBody(
            children: <Widget>[
              Text("Faltan campos por llenar."),
            ],
          )),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Aceptar"))
          ]);
    }
  }

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
