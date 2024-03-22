import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/models/user_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController mailLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();
  Dio dio = Dio();
  DatabaseProvider databaseProvider = DatabaseProvider.db;
  late UserDatasourceMethods userDatasourceImpl;
  late Database database;
  EndPoints endPoint = EndPoints();
  late Future<String> user;

  Future<void> loginUser(String username, String password) async {
    final token = await userDatasourceImpl.getUserAuth(
        endPoint: endPoint.baseUrl+endPoint.getUserAuth, username: username, password: password);
    token != null
        ? saveAuthInformation(token, username, password)
        : showErrorMessage('El usuario no existe, intente de nuevo');

    Get.to(() => const Home());
  }

  void saveAuthInformation(token, username, password) async {
    await AuthStorage().saveToken(token);
    await AuthStorage().saveNickname(username);
    await AuthStorage().savePassword(password);
  }

  void showErrorMessage(errorMessage){
    //Mensaje de error
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                    text: 'Iniciar sesion',
                    large: true,
                    onPressed: () {
                      loginUser(mailLoginController.text,
                          passwordLoginController.text);
                      print(mailLoginController.text.toString());
                      //Get.to(() =>  Home());
                    }),
              ]),
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
