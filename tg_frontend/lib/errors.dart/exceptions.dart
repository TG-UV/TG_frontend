import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/theme.dart';

class ErrorHandler {
  static void showErrorAlert(BuildContext context, String errorMessage) {
    String finalMessage;
    List<String> partes = errorMessage.split("[");
    if (partes.length > 1) {
      List<String> secondPart = partes[1].split("]");
      finalMessage = secondPart.first.trim();
    } else {
      finalMessage = errorMessage;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorManager.staticColor,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Advertencia',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: ColorManager.fourthColor),
          ),
          content: Text(
            "  $finalMessage",
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 10,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okey',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: ColorManager.primaryColor)),
            ),
            // TextButton(
            //   onPressed: () {
            //     AuthStorage().removeValues();
            //     Get.to(() => const Login());
            //   },
            //   child:
            //       Text('Salir', style: Theme.of(context).textTheme.titleSmall),
            // ),
          ],
        );
      },
    );
  }
}
