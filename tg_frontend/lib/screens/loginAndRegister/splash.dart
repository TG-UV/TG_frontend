import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/loginAndRegister/login.dart';
import 'package:tg_frontend/services/auth_services.dart';

class Splash extends StatefulWidget {
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.error,
      body: Center(
        child: Image.asset(
          'assets/1200px-U+2301.svg.png',
          width: 100,
          height: 100,
          fit: BoxFit.cover, 
        ),
      ),
    );
  }

  Future<void> _saveToken() async {
    int idUser = await userDatasourceImpl.getUserRemote(context);
    if (idUser != 0) {
      Get.to(() => const Home());
    }
  }

  Future<void> verifyLoggedIn() async {
    token = await AuthStorage().getToken();
    print('verifyLoggedIn');
    token != null ? _saveToken() : Get.to(() => const Login());
  }
}
