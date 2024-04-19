import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/services/auth_services.dart';

class PasswordRegister extends StatefulWidget {
  const PasswordRegister({super.key, required this.user, this.vehicle});
  final User user;
  final Vehicle? vehicle;
  
  @override
  State<PasswordRegister> createState() => _PasswordRegisterState();
}

class _PasswordRegisterState extends State<PasswordRegister> {
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  bool emailCheckAdvice = false;
      

  Future<dynamic> submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      widget.user.password = passwordConfirmationController.text;
     Response idUser= await userDatasourceImpl.insertUserRemote(user: widget.user);
     if(idUser is int)
    {
      
        User newUser = await userDatasourceImpl.getUserLocal(idUser as int);
        saveAuthInformation(newUser, newUser.email, passwordConfirmationController.text);
       
        if (widget.vehicle != null) {
          Vehicle newVehicle = Vehicle(
            idVehicle: widget.vehicle!.idVehicle,
            //owner: newUser.idUser,
            vehicleBrand: widget.vehicle!.vehicleBrand,
            vehicleColor: widget.vehicle!.vehicleColor,
            vehicleModel: widget.vehicle!.vehicleModel,
            vehicleType: widget.vehicle!.vehicleType,
            licensePlate: widget.vehicle!.licensePlate,
          );
          Response vehicleRegisterResponse = await userDatasourceImpl.insertVehicleRemote(vehicle: newVehicle);
          if(vehicleRegisterResponse is int){
            setState(() {
              emailCheckAdvice = true;
            });
            return EasyLoading.showInfo("registro exitoso");
            
          }
          else{
            return EasyLoading.showInfo(vehicleRegisterResponse.toString());
          }
        }
       
      }
      else{
        return EasyLoading.showInfo(idUser.toString());
      }
    } else {
      return AlertDialog(
          title: const Text("Error"),
          content: const SingleChildScrollView(
              child: ListBody(
            children: <Widget>[
              Text("Error en alguno de los campos"),
            ],
          )),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Aceptar"))
          ]);
    }
  }

Future<dynamic> reSendConfirmationEmail() async {
  await userDatasourceImpl.postUserSendEmail();
}
  

  void saveAuthInformation(user, username, password) async {
    final token = await userDatasourceImpl.getUserAuth(
        username: username, password: password);
    if (token != null) {
      await AuthStorage().saveToken(token);
      await AuthStorage().saveNickname(username);
      await AuthStorage().savePassword(password);

      Environment.sl.registerSingleton<User>(user);
      Get.to(() => const Home());
    } else {
      print('Error al intentar registrar el user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Form(
                key: _formKey, 
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Stack(children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 150),
                        Text(
                          "Por último añade una contraseña",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 35),
                        InputField(
                          controller: passwordController,
                          textInput: 'Contraseña',
                          textInputType: TextInputType.text,
                          obscure: false,
                          icon: const Icon(Icons.key),
                        ),
                        const SizedBox(height: 15),
                        InputField(
                          controller: passwordConfirmationController,
                          textInput: 'Confirmación de contraseña',
                          textInputType: TextInputType.text,
                          obscure: false,
                          icon: const Icon(null),
                        ),
                        const SizedBox(height: 200),
                        
                        
                        Visibility(child: Row(
                          children: <Widget>[
                            const Expanded(
                              child: Text(
                                'Revisa tu correo para activar tu cuenta. ¿No te ha llegado?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  //Get.to(() => const SignUp());
                                 () => reSendConfirmationEmail();
                                },
                                child: const Text(
                                  'Reenviar correo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        ),

                        Visibility(
                          visible: !emailCheckAdvice,
                          child: 
                        LargeButton(
                            text: 'Crear cuenta',
                            large: true,
                            onPressed: () {
                              submitForm(context);
                            }),)
                      ]),
                  Positioned(
                      top: 30.0,
                      left: 5.0,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)))
                ]))));
  }
}
