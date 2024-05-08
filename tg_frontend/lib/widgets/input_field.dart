import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tg_frontend/screens/theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key,
      required this.controller,
      required this.textInput,
      required this.textInputType,
      this.icon,
      this.onChange,
      this.onPressed,
      this.foco,
      required this.obscure,
      this.color});

  final TextEditingController controller;
  final String textInput;
  final TextInputType textInputType;
  final bool obscure;
  final Icon? icon;
  final Function(String)? onChange;
  final Function()? onPressed;
  final FocusNode? foco;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordConfirmationController =
        TextEditingController();

    RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
    bool validatePassword(String pass) {
      String password = pass.trim();
      if (passValid.hasMatch(password)) {
        return true;
      } else {
        return false;
      }
    }

    return TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(40)],
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscure,
        onChanged: onChange,
        style: TextStyle(color: ColorManager.primaryColor),
        //autofocus: true,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 9.0, horizontal: 7.0),
            hintText: textInput,
            hintStyle:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 12),
            filled: true,
            suffixIcon: icon != null
                ? (IconButton(
                    icon: icon!,
                    onPressed: onPressed,
                  ))
                : null,
            //fillColor: Colors.grey.shade200,
            fillColor: ColorManager.thirdColor,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                )),
            labelStyle: const TextStyle(
                color: Color.fromARGB(255, 32, 32, 32), fontSize: 18),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 24, 24, 24),
                width: 2.0,
              ),
            )),
        validator: controller != passwordConfirmationController
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacio';
                }
                return null;
              }
            : (value) {
                if (value!.isEmpty) {
                  return "Please enter password";
                } else {
                  //call function to check password
                  bool result = validatePassword(value);
                  if (result) {
                    // create account event
                    return null;
                  } else {
                    return " La constraseña debe tener al menos un número, un carácter especial y una mayúscula";
                  }
                }
              });
  }
}
