import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/theme.dart';

class ErrorOrAdviceHandler {
  static void showErrorAlert(
    BuildContext context,
    String errorMessage,
    bool isError, {
    Future<void> Function()? callbackAcept,
    Future<void> Function()? callbackDeny,
  }) {
    String finalMessage;
    List<String> partes = errorMessage.split("[");
    if (partes.length > 1) {
      List<String> secondPart = partes[1].split("]");
      finalMessage = secondPart.first.trim();
    } else {
      List<String> partes = errorMessage.split("{");
      if (partes.length > 1) {
        List<String> secondPart = partes[1].split("}");
        finalMessage = partes[0] + secondPart.first.trim();
      } else {
        finalMessage = errorMessage;
      }
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
          actions: isError
              ? <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay',
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
                ]
              : <Widget>[
                  TextButton(
                    onPressed: callbackDeny,
                    child: Text('Cancelar',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: ColorManager.fourthColor)),
                  ),
                  TextButton(
                    onPressed: callbackAcept,
                    child: Text('Confirmar',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: ColorManager.primaryColor)),
                  ),
                ],
        );
      },
    );
  }
}
