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
      required this.obscure});

  final TextEditingController controller;
  final String textInput;
  final TextInputType textInputType;
  final bool obscure;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [LengthLimitingTextInputFormatter(40)],
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscure,
      style: TextStyle(color: ColorManager.primaryColor),
      //autofocus: true,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 9.0, horizontal: 7.0),
          hintText: textInput,
          hintStyle: const TextStyle(
              color: Color.fromARGB(255, 71, 71, 71), fontSize: 12),
          filled: true,
          suffixIcon: icon,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo no puede estar vacio';
        }
        return null;
      },
      
    );
  }
}
