import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/services/auth_services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController mailLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();

  Dio dio = Dio();

  Future<void> loginUser(String username, String password) async {
    try {
      var response = await dio.post(
        'https://tg-backend-cojj.onrender.com/auth/token/login/',
        data: {"password": password, "email": username},
      );
      if (response.statusCode == 200) {
        print('autenticacion exitosa: ${response.data}');
        // Extrae el token de la respuesta (ajústalo según la estructura de tu respuesta)
        Map<String, dynamic> responseData = Map.from(response.data);
        String token = responseData['auth_token'];

        // Guarda el token en el almacenamiento seguro
        await AuthStorage().saveToken(token);
        //Get.offAllNamed('/home');
        Get.to(const Home());

        // Maneja el redireccionamiento o la navegación a la siguiente pantalla
        // Puedes hacerlo según tus necesidades
      } else {
        // Maneja la respuesta del backend cuando no es exitosa
        print('Error en la autenticación: ${response.statusCode}');
      }
    } catch (error) {
      // Maneja los errores de autenticación aquí.
      print('Error al autenticar: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Stack(children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(height: 150),
                Text(
                  "Inicia sesión",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 35),
                InputField(
                  controller: mailLoginController,
                  textInput: 'Correo electrónico',
                  textInputType: TextInputType.text,
                  obscure: false,
                  icon: const Icon(Icons.key),
                ),
                const SizedBox(height: 15),
                InputField(
                  controller: passwordLoginController,
                  textInput: 'Contraseña',
                  textInputType: TextInputType.text,
                  obscure: false,
                  icon: const Icon(null),
                ),
                const SizedBox(height: 200),
                LargeButton(
                    text: 'Iniciar sesion',
                    large: true,
                    onPressed: () {
                      loginUser(mailLoginController.text,
                          passwordLoginController.text);
                      Get.to(() => {});
                    }),
              ]),
              Positioned(
                  top: 30.0,
                  left: 5.0,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)))
            ])));
  }
}
