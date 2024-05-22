import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/errors.dart/exceptions.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/main_button.dart';

class SetUserInformation extends StatefulWidget {
  const SetUserInformation({super.key, required this.user});
  final User user;

  @override
  State<SetUserInformation> createState() => _SetUserInformationState();
}

class SpanishPWValidator implements FlutterPwValidatorStrings {
  @override
  final String atLeast = 'Longitud mínima';
  @override
  final String uppercaseLetters = 'Mayúscula';
  @override
  final String numericCharacters = 'Carácter númerico ';
  @override
  final String specialCharacters = 'Carácter especial';
  @override
  // TODO: implement lowercaseLetters
  String get lowercaseLetters => throw "Minúscula";

  @override
  // TODO: implement normalLetters
  String get normalLetters => throw "Letras normales";
}

class _SetUserInformationState extends State<SetUserInformation> {
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> options;
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  late Vehicle vehicle;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendSetPassword() async {
    var response = await userDatasourceImpl.postUserSetPassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text);
    if (response is int) {
      return EasyLoading.showInfo("contraseña registrada con exito");
    } else {
      return EasyLoading.showInfo(response.toString());
    }
  }

  InputDecoration myInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.secondaryColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          )),
      filled: true,
      fillColor: ColorManager.thirdColor,
    );
  }

  void submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _sendSetPassword();
    } else {
      return ErrorOrAdviceHandler.showErrorAlert(
          context, "Error en alguno de los campos", true);
    }
  }

  _changeVisbilityParameter(bool value) {
    setState(() {
      isVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 90,
                      ),
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back)),
                        Text(
                          " Cambia tu contraseña",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 20),
                        )
                      ]),
                      const SizedBox(height: 30.0),
                      InputField(
                          controller: currentPasswordController,
                          textInput: 'Contraseña actual',
                          textInputType: TextInputType.text,
                          obscure: false,
                          icon: const Icon(null)),
                      const SizedBox(height: 10.0),
                      InputField(
                          controller: newPasswordController,
                          textInput: 'Nueva contraseña',
                          textInputType: TextInputType.text,
                          obscure: false,
                          icon: const Icon(null),
                          onChange: _changeVisbilityParameter(true)),
                      // Visibility(
                      //   visible: isVisible,
                      //   child: FlutterPwValidator(
                      //     controller: newPasswordController,
                      //     minLength: 6,
                      //     uppercaseCharCount: 1,
                      //     numericCharCount: 1,
                      //     specialCharCount: 1,
                      //     width: 400,
                      //     height: 180,
                      //     onSuccess: () {},
                      //     strings: SpanishPWValidator(),
                      //   ),
                      // ),
                      //  const Spacer(),
                      MainButton(
                          text: "guardar",
                          large: true,
                          onPressed: _sendSetPassword)
                    ]))));
  }
}
