import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  const SquareButton(
      {Key? key,
      // required this.controller,
      required this.text,
      required this.onPressed,
      required this.icon
      //required this.child
      })
      : super(key: key);

  // final TextEditingController controller;

  final VoidCallback? onPressed;
  final String text;
  final bool icon;
  //final Widget child;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(50, 50)),
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.primary),
        side: MaterialStateProperty.all<BorderSide>(const BorderSide(
          color: Colors.black, // Color del borde
          width: 2.0, // Ancho del borde
        )),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
          ),
        ),
      ),
      child: icon
          ? const Icon(Icons.edit)
          : Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Jost,'),
            ),
    );
  }
}
