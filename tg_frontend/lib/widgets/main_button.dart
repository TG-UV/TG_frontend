import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/theme.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.text,
    required this.large,
    required this.onPressed,
    this.myIcon,
    this.buttonColor,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool large;
  final IconData? myIcon;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    double largeWidth = MediaQuery.of(context).size.width / 2;
    double largeHeigth = MediaQuery.of(context).size.width / 6.3;
    double shortWidth = MediaQuery.of(context).size.width / 2.5;
    double shortHeigth = MediaQuery.of(context).size.width / 9;

    Color myBackgroundColor =
        buttonColor != null ? buttonColor! : ColorManager.secondaryColor;
    return SizedBox(
        width: large ? largeWidth : shortWidth,
        height: large ? largeHeigth : shortHeigth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            shadowColor: ColorManager.secondaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: myBackgroundColor,
          ),
          onPressed: onPressed,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            if (!large)
              Image.asset(
                'assets/1200px-U+2301.svg.png',
                width: 15,
                height: 15,
                fit: BoxFit.cover,
              ),
            Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Jost,'),
              maxLines: 2,
            )
          ]),
        ));
  }
}
