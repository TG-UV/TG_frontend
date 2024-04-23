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
    
  }
}
