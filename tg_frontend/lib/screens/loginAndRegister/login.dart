import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/loginAndRegister/sign_up.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/large_button.dart';
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
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  EndPoints endPoint = EndPoints();

  late Future<String> user;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loginUser(String username, String password) async {
    final token = await userDatasourceImpl.getUserAuth(
        username: username, password: password);
    token != null
        ? saveAuthInformation(token, username, password)
        : showErrorMessage('El usuario no existe, intente de nuevo');
  }

  void saveAuthInformation(token, username, password) async {
    await AuthStorage().saveToken(token);
    print('tokennnnnn-----------$token');
    await AuthStorage().saveNickname(username);
    await AuthStorage().savePassword(password);
    int idUser = await userDatasourceImpl.getUserRemote(
        endPoint: endPoint.baseUrl + endPoint.getUserLogged);
    User user = await userDatasourceImpl.getUserLocal(idUser);
    Environment.sl.registerSingleton<User>(user);
    Get.to(() => const Home());
  }

  Widget showErrorMessage(errorMessage) {
    return AlertDialog(
        title: const Text("Error"),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cerrar"),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Stack(children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100),
                        Center(
                            child: Image.asset(
                          'assets/1200px-U+2301.svg.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )),
                        const SizedBox(height: 60),
                        Text(
                          "Inicia sesión",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 50),
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
                        const SizedBox(height: 50),
                        LargeButton(
                            text: 'Iniciar sesion',
                            large: true,
                            onPressed: () {
                              loginUser(mailLoginController.text,
                                  passwordLoginController.text);
                            }),
                        const SizedBox(height: 80),
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
                      ]),

                  // Positioned(
                  //     top: 30.0,
                  //     left: 5.0,
                  //     child: IconButton(
                  //         onPressed: () {
                  //           Navigator.pop(context);
                  //         },
                  //         icon: const Icon(Icons.arrow_back)))
                ]))));
  }
}
