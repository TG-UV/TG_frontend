import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  const SquareButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.myIcon,
    required this.isSelected,
  });

  final VoidCallback? onPressed;
  final String text;
  final IconData? myIcon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(50, 50)),
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.primary),
        side: MaterialStateProperty.all<BorderSide>(BorderSide(
          color: isSelected
              ? Colors.black
              : const Color.fromARGB(255, 225, 225, 225), // Color del borde
          width: 2.0, // Ancho del borde
        )),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
          ),
        ),
      ),
      child: myIcon != null
          ? const Icon(
              Icons.edit,
              color: Colors.black,
            )
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

  /*

  @override
  Widget build(BuildContext context) {
    Widget buildTextWidget() {
      final List<String> lines = text.split(' ');
      if (lines.length > 1) {
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: lines[0],
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w500),
            children: <TextSpan>[
              TextSpan(
                text: ' ${lines.sublist(1).join(' ')}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      } else {
        return Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w500),
        );
      }
    }

    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(30, 30)),
          maximumSize: MaterialStateProperty.all(const Size(40, 40)),
          backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary),
          side: MaterialStateProperty.all<BorderSide>(const BorderSide(
            color: Color.fromARGB(255, 37, 37, 37), // Color del borde
            width: 1,
          )),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
            ),
          ),
        ),
        child: Center(
            child: myIcon != null
                ? Icon(
                    myIcon,
                    size: 23,
                    color: Colors.black,
                  )
                : buildTextWidget()));
  }*/
}
