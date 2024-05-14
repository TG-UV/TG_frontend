import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/loginAndRegister/login.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/services/travel_notification_provider.dart';

class Splash extends StatefulWidget {
  // final Splash({Key? key}) : super(key: key);
  const Splash({super.key});
  @override
  State<Splash> createState() => _LoginState();
}

class _LoginState extends State<Splash> {
  final TextEditingController emailController = TextEditingController();
  final authStorage = AuthStorage();
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  String? token;

  @override
  void initState() {
    super.initState();
    verifyLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    // Timer(const Duration(seconds: 3), () {
    //   Get.to(() => const Welcome());
    // });
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.error,
      body: Center(
        child: Image.asset(
          'assets/1200px-U+2301.svg.png',
          width: 100, // ajusta el ancho según tus necesidades
          height: 100, // ajusta la altura según tus necesidades
          fit: BoxFit.cover, // ajusta el modo de ajuste de la imagen
        ),
      ),
    );
  }

  Future<void> _saveToken() async {
    int idUser = await userDatasourceImpl.getUserRemote();
    User user = await userDatasourceImpl.getUserLocal(idUser);
    Environment.sl.registerSingleton<User>(user);
    Get.to(() => const Home());
    //authStorage.removeValues();
    //bool isLoggedIn;

    // final nickname = await authStorage.getNickName();
    // final password = await authStorage.getPassword();
    // print('llega a verifyAuth');
    // if (nickname != null && password != null) {
    //   isLoggedIn = true;
    // }
    // token != null ? isLoggedIn = true : isLoggedIn = false;
    // return isLoggedIn;
  }

  Future<void> verifyLoggedIn() async {
    token = await AuthStorage().getToken();
    print('llega a verifyLoggedIn');
    token != null ? _saveToken() : Get.to(() => const Login());
  }
}
