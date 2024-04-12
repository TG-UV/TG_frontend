import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/theme.dart';

class LargeButton extends StatelessWidget {
  const LargeButton({
    super.key,
    // required this.controller,
    required this.text,
    required this.large,
    required this.onPressed,
    this.myIcon,

    //required this.child
  });

  // final TextEditingController controller;

  final VoidCallback? onPressed;
  final String text;
  final bool large;
  final IconData? myIcon;
  //final Widget child;
  @override
  Widget build(BuildContext context) {
    Color myBackgroundColor =
        (text == 'Buscar') ? Colors.grey : Theme.of(context).colorScheme.error;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 4,
          shadowColor: ColorManager.secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: myBackgroundColor,
          maximumSize: large ? const Size(300, 77) : const Size(150, 85),
          minimumSize: large ? const Size(300, 77) : const Size(140, 40)),
      onPressed: onPressed,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        if (!large)
          Image.asset(
            'assets/1200px-U+2301.svg.png',
            width: 15, // ajusta el ancho según tus necesidades
            height: 15, // ajusta la altura según tus necesidades
            fit: BoxFit.cover, // ajusta el modo de ajuste de la imagen
          ),
        Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'Jost,'),
        )
      ]),
    );
  }
}
