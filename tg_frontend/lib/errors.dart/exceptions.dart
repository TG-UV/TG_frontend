import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/theme.dart';

class ExceptionsHandle implements Exception {}

class ErrorHandler {
  static void showErrorAlert(BuildContext context, String errorMessage) {
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
            errorMessage,
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
