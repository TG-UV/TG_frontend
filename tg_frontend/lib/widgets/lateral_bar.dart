import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/screens/loginAndRegister/login.dart';
import 'package:tg_frontend/screens/loginAndRegister/vehicle_managment.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/widgets/setUserInformation.dart';

final logger = Logger();

class LateralBar extends StatefulWidget {
  LateralBar({Key? key}) : super(key: key);

  @override
  State<LateralBar> createState() => _LateralBarState();
}

class _LateralBarState extends State<LateralBar> {
  User user = Environment.sl.get<User>();

  @override
  void initState() {
    super.initState();
  }

  _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorManager.staticColor,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Confirmación',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          content: Text(
            '¿Estás seguro de que quiere cerrar sesión?',
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 2,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: ColorManager.fourthColor)),
            ),
            TextButton(
              onPressed: () {
                AuthStorage().removeValues();
                Environment.sl.unregister<User>();
                Get.to(() => const Login());
              },
              child:
                  Text('Salir', style: Theme.of(context).textTheme.titleSmall),
            ),
          ],
        );
      },
    );
  }

  @override
  Drawer build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.4,
      // shadowColor: ColorManager.primaryColor,
      backgroundColor: ColorManager.thirdColor,
      shape:
          Border(right: BorderSide(color: ColorManager.fourthColor, width: 3)),
      child: ListView(
        children: <Widget>[
          SizedBox(
              height: 150,
              child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      color: ColorManager.staticColor,
                      border: const Border(
                          bottom: BorderSide(color: Colors.transparent))),
                  accountName: Text(
                    '${user.firstName.substring(0, 1).toUpperCase()}${user.firstName.substring(1)} ${user.lastName.substring(0, 1).toUpperCase()}${user.lastName.substring(1)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  accountEmail: Text(
                    user.email,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  otherAccountsPictures: [
                    CircleAvatar(
                      backgroundColor: ColorManager.secondaryColor,
                      backgroundImage: const NetworkImage(
                          //"https://randomuser.me/api/portraits/women/74.jpg"),
                          "https://api.dicebear.com/8.x/bottts/png"),
                    ),
                  ])),
          if (user.type == 2)
            ListTile(
              leading: const Icon(Icons.motorcycle_outlined),
              title: const Text('Ver mis vehículos'),
              onTap: () {
                Get.to(() => VehicleManagment(
                      user: user,
                      parent: "menu",
                    ));
              },
            ),
          ExpansionTile(
            title: Text('Configuración'),
            leading: const Icon(Icons.settings),
            children: <Widget>[
              // ListTile(
              //   title: Text('Editar perfil'),
              //   onTap: () {},
              // ),
              ListTile(
                title: Text('Cambiar contraseña'),
                onTap: () {
                  Get.to(() => SetUserInformation(user: user));
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: const Text('Soporte'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("¿Necesitas ayuda?"),
                    content: Column(
                      children: [
                        Text(
                          "Escribe un correo explicando en que podemos ayudarte, te contestaremos lo mas pronto posible. ",
                          maxLines: 4,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: ColorManager.primaryColor),
                        ),
                        Text(
                          "soporte@rayo.com",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorManager.primaryColor),
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cerrar",
                          style: TextStyle(color: ColorManager.primaryColor),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const AboutListTile(
            icon: Icon(
              Icons.info_outline,
            ),
            applicationIcon: Image(
              image: AssetImage(
                'assets/1200px-U+2301.svg.png',
              ),
              width: 40,
              height: 40,
              color: Colors.white,
              // fit: BoxFit.cover,
            ),
            applicationName: 'Rayo',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2024 Company',
            aboutBoxChildren: [
              Column(
                children: [
                  SizedBox(height: 20),
                  Text('Autores'),
                  Text('Sara - Sebastian')
                ],
              )
            ],
            child: Text('Sobre Nosotros'),
          ),
          ListTile(
            leading: const Icon(Icons.login_outlined),
            title: const Text('Cerrar sesión'),
            onTap: () {
              _showConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
