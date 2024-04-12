import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/theme.dart';

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
        side: MaterialStateProperty.all<BorderSide>(BorderSide(
          color: isSelected
              ? ColorManager.secondaryColor
              : const Color.fromARGB(255, 225, 225, 225), // Color del borde
          width: 1.0, // Ancho del borde
        )),
        elevation: MaterialStateProperty.all(4),
        shadowColor:
            MaterialStateProperty.all(Color.fromARGB(255, 122, 122, 122)),
        // shape: MaterialStateProperty.all<>(
        //   RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
        //   ),
        // ),
      ),
      child: myIcon != null
          ? Icon(
              Icons.edit,
              color: ColorManager.secondaryColor,
            )
          : Column(
              children: [
                Text(
                  text,
                  style: TextStyle(color: ColorManager.secondaryColor),
                ),
                if(text == "10" ||text == "30" ||text == "60")
                Text(
                  "min",
                  style: TextStyle(color: ColorManager.secondaryColor),
                )
              ],
            ),
    );
    // return ElevatedButton(
    //   onPressed: onPressed,
    //   style: ButtonStyle(
    //     fixedSize: MaterialStateProperty.all(const Size(50, 50)),
    //     //maximumSize: MaterialStateProperty.all(const Size(70, 50)),
    //     backgroundColor: MaterialStateProperty.all<Color>(
    //         Theme.of(context).colorScheme.primary),
    //     side: MaterialStateProperty.all<BorderSide>(BorderSide(
    //       color: isSelected
    //           ? ColorManager.secondaryColor
    //           : const Color.fromARGB(255, 225, 225, 225), // Color del borde
    //       width: 2.0, // Ancho del borde
    //     )),
    //     elevation: MaterialStateProperty.all(5),
    //      shadowColor: MaterialStateProperty.all(const Color.fromARGB(255, 35, 35, 35)),
    //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
    //       ),
    //     ),
    //   ),
    //   child: myIcon != null
    //       ?  Icon(
    //           Icons.edit,
    //           color: Theme.of(context).colorScheme.secondary,
    //         )
    //       : Text(
    //       text,
    //       textAlign: TextAlign.center, // Centra horizontalmente el texto
    //       softWrap: false, // Permite que el texto se envuelva en varias líneas
    //       style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 18,
    //           color: Theme.of(context).colorScheme.secondary,
    //           fontFamily: 'Jost'),
    //       maxLines: 2, // Establece el número máximo de líneas permitidas
    //       overflow: TextOverflow.ellipsis, // Trunca el texto si es demasiado largo para dos líneas
    //     ),
    // );
  }
}
