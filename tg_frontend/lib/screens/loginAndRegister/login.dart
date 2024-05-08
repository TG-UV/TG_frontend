import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/loginAndRegister/sign_up.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/services/firebase.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mailLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();
  final TextEditingController reSetMailController = TextEditingController();
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  EndPoints endPoint = EndPoints();
  DatabaseProvider databaseProvider = DatabaseProvider.db;
  late Database database;
  late Future<String> user;
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    databaseProvider = DatabaseProvider.db;
    databaseProvider.cleanDatabase();
    Environment.sl.unregister<User>();

    super.initState();
  }

  Future<void> loginUser(String username, String password) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    if (_formKey.currentState!.validate() && deviceToken is String) {
      final token = await userDatasourceImpl.getUserAuth(
          username: username, password: password, idDevice: deviceToken);

      token != null
          ? saveAuthInformation(token, username, password)
          : showErrorMessage('Contraseña incorrecta');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> reSetPassword(String email) async {
    await userDatasourceImpl.postReSetPassword(email: email);
  }

  void saveAuthInformation(token, username, password) async {
    await AuthStorage().saveToken(token);
    print('tokennnnnn-----------$token');
    await AuthStorage().saveNickname(username);
    await AuthStorage().savePassword(password);
    int idUser = await userDatasourceImpl.getUserRemote();
    User user = await userDatasourceImpl.getUserLocal(idUser);
    Environment.sl.registerSingleton<User>(user);
    Get.to(() => const Home());
  }

  Future<void> showErrorMessage(String errorMessage) {
    return EasyLoading.showInfo(errorMessage);
    // return AlertDialog(
    //     title: const Text("Error"),
    //     content: Text(errorMessage),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //         },
    //         child: const Text("Cerrar"),
    //       )
    //     ]);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool isPopGesture) {
          SystemNavigator.pop();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //alignment: Alignment.center,
                    child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Stack(children: [
                          Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                ),
                                const SizedBox(height: 15),
                                InputField(
                                    controller: passwordLoginController,
                                    textInput: 'Contraseña',
                                    textInputType: TextInputType.text,
                                    obscure: _obscureText,
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    }),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // Aquí construyes el AlertDialog
                                          return AlertDialog(
                                              title: const Text(
                                                  "Restablecer contraseña"),
                                              content: Column(
                                                children: [
                                                  const Text(
                                                      "Ingrese el correo para restablecer la contraseña"),
                                                  TextFormField(
                                                    controller:
                                                        reSetMailController,
                                                  )
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    reSetPassword(
                                                        reSetMailController
                                                            .text);
                                                  },
                                                  child: const Text("Enviar"),
                                                )
                                              ]);
                                        });
                                  },
                                  style: TextButton.styleFrom(
                                    textStyle: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: ColorManager.primaryColor,
                                        fontSize: 12),
                                  ),
                                  child: Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 12),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                const SizedBox(height: 50),
                                _isLoading
                                    ? const SizedBox(
                                        height: 50.0,
                                        width: 50.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.red),
                                        ),
                                      )
                                    : MainButton(
                                        text: 'Iniciar sesión',
                                        large: true,
                                        buttonColor: ColorManager.fourthColor,
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
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
                        ]))))));
  }
}
