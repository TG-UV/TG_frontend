import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  const SquareButton(
      {super.key,
      // required this.controller,
      required this.text,
      required this.onPressed,
      this.myIcon
      //required this.child
      });

  // final TextEditingController controller;

  final VoidCallback? onPressed;
  final String text;
  final IconData? myIcon;

  //final Widget child;
  @override
  Widget build(BuildContext context) {
    Column myRow =
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      FittedBox(
          fit: BoxFit.fill,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Jost,'),
            //overflow: TextOverflow.clip,
            //softWrap: true,
          ))
    ]);

    Widget childOption() {
      if (myIcon == null) {
        return myRow;
      } else {
        return Icon(myIcon, size: 0.5);
      }
    }

    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(50, 50)),
          maximumSize: MaterialStateProperty.all(const Size(60, 60)),
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
        child: childOption());
  }
}
