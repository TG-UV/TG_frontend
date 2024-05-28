import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/errors.dart/exceptions.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/screens/loginAndRegister/login.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/main_button.dart';

class PasswordRegister extends StatefulWidget {
  const PasswordRegister({super.key, required this.user, this.vehicle});
  final User user;
  final Vehicle? vehicle;

  @override
  State<PasswordRegister> createState() => _PasswordRegisterState();
}

class FrenchStrings implements FlutterPwValidatorStrings {
  @override
  final String atLeast = 'Au moins - caractères';
  @override
  final String uppercaseLetters = '- Lettres majuscules';
  @override
  final String numericCharacters = '- Chiffres';
  @override
  final String specialCharacters = '- Caractères spéciaux';

  @override
  // TODO: implement lowercaseLetters
  String get lowercaseLetters => throw UnimplementedError();

  @override
  // TODO: implement normalLetters
  String get normalLetters => throw UnimplementedError();

  // @override
  // // TODO: implement lowercaseLetters
  // final String lowercaseLetters = throw 'Minúscula';

  // @override
  // // TODO: implement normalLetters
  // String get normalLetters => throw "Letras normales";
}

class _PasswordRegisterState extends State<PasswordRegister> {
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();

  final GlobalKey<FlutterPwValidatorState> validatorKey =
      GlobalKey<FlutterPwValidatorState>();

  bool emailCheckAdvice = false;
  //String? deviceToken = FirebaseService().fCMToken;

  Future<dynamic> submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      widget.user.password = passwordConfirmationController.text;

      dynamic userInsertResponse =
          await userDatasourceImpl.insertUserRemote(user: widget.user);
      if (userInsertResponse is int) {
        User newUser =
            await userDatasourceImpl.getUserLocal(userInsertResponse);

        if (widget.vehicle != null) {
          Vehicle newVehicle = Vehicle(
            idVehicle: widget.vehicle!.idVehicle,
            //owner: newUser.userInsertResponse,
            vehicleBrand: widget.vehicle!.vehicleBrand,
            vehicleColor: widget.vehicle!.vehicleColor,
            vehicleModel: widget.vehicle!.vehicleModel,
            vehicleType: widget.vehicle!.vehicleType,
            licensePlate: widget.vehicle!.licensePlate,
          );
          dynamic vehicleRegisterResponse = await userDatasourceImpl
              .insertVehicleRemote(vehicle: newVehicle, context: context);
          if (vehicleRegisterResponse is int) {
            return EasyLoading.showInfo("registro de vehículo exitoso");
          }
        }
        setState(() {
          emailCheckAdvice = true;
        });
        _showConfirmationDialog(context);
        saveAuthInformation(
            newUser, newUser.email, passwordConfirmationController.text);
      }
    } else {
      return ErrorOrAdviceHandler.showErrorAlert(
          context, "Error en alguno de los campos", true);
    }
  }

  Future<void> reSendConfirmationEmail() async {
    await userDatasourceImpl.postUserSendEmail(userEmail: widget.user.email);
  }

  void saveAuthInformation(user, username, password) async {
    late final String? token;
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken is String) {
      token = await userDatasourceImpl.getUserAuth(
          username: username, password: password, idDevice: deviceToken);
    }
    if (token != null) {
      await AuthStorage().saveToken(token);
      await AuthStorage().saveNickname(username);
      await AuthStorage().savePassword(password);

      Environment.sl.registerSingleton<User>(user);

      // Get.to(() => const Home());
    } else {
      print('Error al intentar registrar el usuario');
    }
  }

  _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorManager.staticColor,
          surfaceTintColor: Colors.transparent,
          title: Text(
            '¡Bienvenido!',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Hemos enviado un correo de activación, diríjase a su cuenta universitaria para activar su perfil.',
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 6,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                () => reSendConfirmationEmail();
              },
              child: Text('Reenviar correo',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: ColorManager.fourthColor)),
            ),
            TextButton(
              onPressed: () {
                AuthStorage().removeValues();
                Environment.sl.unregister<User>();
                Get.to(() => const Login());
              },
              child:
                  Text('Salir', style: Theme.of(context).textTheme.titleSmall),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return
        // PopScope(
        //     canPop: true,
        //     onPopInvoked: (bool isRegistered) {
        //       Navigator.pop(context);
        //       // if (emailCheckAdvice) {
        //       //   Get.to(() => const Login());
        //       // } else
        //       //   Navigator.pop(context);
        //     },child:

        Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                alignment: Alignment.center,
                child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Stack(children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            Row(children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back)),
                              const SizedBox(width: 5),
                              Text(
                                " Por último, añade una contraseña",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontSize: 15),
                                maxLines: 2,
                              )
                            ]),
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
                            // FlutterPwValidator(
                            //   controller: passwordConfirmationController,
                            //   minLength: 6,
                            //   uppercaseCharCount: 1,
                            //   numericCharCount: 1,
                            //   specialCharCount: 1,
                            //   width: 400,
                            //   height: 175,
                            //   onSuccess: () {},
                            //   //strings: FrenchStrings(),
                            // ),
                            const SizedBox(height: 200),
                            // Visibility(
                            //     visible: emailCheckAdvice,
                            //     //maintainAnimation: true,
                            //     child: _showConfirmationDialog(context)),
                            Visibility(
                              visible: !emailCheckAdvice,
                              child: MainButton(
                                  text: 'Crear cuenta',
                                  large: true,
                                  onPressed: () {
                                    submitForm(context);
                                  }),
                            )
                          ]),
                    ]))));
  }
}
