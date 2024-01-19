import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key,
      required this.controller,
      required this.textInput,
      required this.textInputType,
      required this.icon,
      required this.obscure});

  final TextEditingController controller;
  final String textInput;
  final TextInputType textInputType;
  final bool obscure;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscure,

      //autofocus: true,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 9.0, horizontal: 7.0),
        hintText: textInput,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 71, 71, 71), fontSize: 12),
        filled: true,
        suffixIcon: icon,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            )),
      ),
      /*
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'El campo no puede estar vacio';
        }

        if (text.length < 2 || text.length > 49) {
          return 'Por favor ingrese un dato valido';
        }
        
      },*/
    );
  }
}
