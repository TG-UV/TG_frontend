import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/loginAndRegister/sign_up.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/main_button.dart';

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

    super.initState();
  }

  Future<void> loginUser(
      String username, String password, BuildContext context) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    //String deviceToken = "kncñsncunvñsfnv";

    if (_validateFormData(_formKey.currentState!.validate(), deviceToken)) {
      final token = await userDatasourceImpl.getUserAuth(
          username: username,
          password: password,
          idDevice: deviceToken!,
          context: context);

      if (token != null) {
        saveAuthInformation(token, username, password, context);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateFormData(bool formValidate, dynamic deviceToken) {
    if (formValidate && deviceToken is String) {
      print("device token $deviceToken");
      return true;
    } else {
      return false;
    }
  }

  Future<void> reSetPassword(String email, BuildContext context) async {
    await userDatasourceImpl.postReSetPassword(email: email, context: context);
  }

  void saveAuthInformation(token, username, password, context) async {
    // await AuthStorage().saveToken(token);
    await AuthStorage().saveNickname(username);
    await AuthStorage().savePassword(password);
    int idUser = await userDatasourceImpl.getUserRemote(context);
    //User user = await userDatasourceImpl.getUserLocal(idUser);
    // Environment.sl.registerSingleton<User>(user);
    setState(() {});
    if (idUser != 0) {
      Get.to(() => const Home());
    }
  }

  Future<void> showErrorMessage(String errorMessage) {
    return EasyLoading.showInfo(errorMessage);
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
                    child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Stack(children: [
                          Column(
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
                                          return AlertDialog(
                                              backgroundColor:
                                                  ColorManager.staticColor,
                                              surfaceTintColor:
                                                  Colors.transparent,
                                              title: Row(
                                                children: [
                                                  Text(
                                                    "Restablecer contraseña",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                            fontSize: 18,
                                                            color: ColorManager
                                                                .primaryColor,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                    maxLines: 2,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Icon(Icons.settings),
                                                ],
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Ingrese el correo para restablecer la contraseña",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                            color: ColorManager
                                                                .fourthColor,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                    maxLines: 3,
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        reSetMailController,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                          color: ColorManager
                                                              .primaryColor,
                                                        ),
                                                  )
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  style: ButtonStyle(
                                                    overlayColor:
                                                        MaterialStateColor
                                                            .resolveWith(
                                                      (states) => Colors.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    reSetPassword(
                                                        reSetMailController
                                                            .text,
                                                        context);
                                                  },
                                                  child: Text(
                                                    "Enviar",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                            color: ColorManager
                                                                .fourthColor),
                                                  ),
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
                                          loginUser(
                                              mailLoginController.text,
                                              passwordLoginController.text,
                                              context);
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
