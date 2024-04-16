import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/screens/loginAndRegister/login.dart';
import 'package:tg_frontend/screens/loginAndRegister/vehicle_register.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/screens/travelScreens/available_travels.dart';
import 'package:tg_frontend/screens/travelScreens/new_travel.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:logger/logger.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

final logger = Logger();

const mapboxAccessToken =
    'pk.eyJ1Ijoic2FybWFyaWUiLCJhIjoiY2xwYm15eTRrMGZyYjJtcGJ1bnJ0Y3hpciJ9.v5mHXrC66zG4x-dgZDdLSA';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late loc.LocationData currentLocation;
  User user = Environment.sl.get<User>();
  UserDatasourceMethods userDatasourceImpl = Environment.sl.get<UserDatasourceMethods>();
  LatLng? myPosition;
  LatLng universityPosition = const LatLng(3.3765821, -76.5334617);

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      _getLocation();
    } else {
     await EasyLoading.showInfo("permiso denegado");
    }
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
        setState(() {
          myPosition = LatLng(position.latitude, position.longitude);
        });
    print(' position:  $position');
  }

 

  _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                AuthStorage().removeValues();
                Get.to(() => const Login());
              },
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          width: MediaQuery.of(context).size.width / 1.4,
          shadowColor: Colors.black,
          backgroundColor: const Color.fromARGB(255, 239, 239, 239),
          shape: const Border(right: BorderSide(color: Colors.red, width: 3)),
          child: ListView(
            children: <Widget>[
              SizedBox(
                  height: 130, 
                  child: UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.transparent))),
                      accountName: Text(
                        '${user.firstName.substring(0, 1).toUpperCase()}${user.firstName.substring(1)} ${user.lastName.substring(0, 1).toUpperCase()}${user.lastName.substring(1)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      accountEmail: Text(
                        user.email,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      otherAccountsPictures: const [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                              //"https://randomuser.me/api/portraits/women/74.jpg"),
                              "https://api.dicebear.com/8.x/bottts/png"),
                        ),
                      ])),
              if (user.type == 2)
                ListTile(
                  leading: const Icon(Icons.motorcycle_outlined),
                  title: const Text('Añadir vehículo'),
                  onTap: () {
                    Get.to(() => VehicleRegister(user: user, parent: "menu",));
                  },
                ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.support_agent_outlined),
                title: const Text('Soporte'),
                onTap: () {},
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
        ),
        body: Stack(children: [
          FlutterMap(
            options:  MapOptions(
                initialCenter: myPosition?? universityPosition,
                minZoom: 5,
                maxZoom: 25,
                initialZoom: 18),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: const {
                  'accessToken': mapboxAccessToken,
                  'id': 'mapbox/streets-v11',
                },
              ),
              if(myPosition != null)
              MarkerLayer(markers: [Marker(point: myPosition!, child: Icon(
                            Icons.location_on_sharp,
                            color: ColorManager.fourthColor,
                            size: 40,
                          ),)]),
                        
                      
              /*
          MarkerLayer(markers: [
            Marker(
                point: LatLng(
                    currentLocation.latitude!, currentLocation.latitude!),
                child: const Icon(Icons.location_on_rounded))
          ])
          */
            ],
          ),

          Positioned(
              top: 100.0,
              left: 50,
              right: 50,
              child: Text(
                '¡Hola ${user.firstName.substring(0, 1).toUpperCase()}${user.firstName.substring(1)}!',
                style: Theme.of(context).textTheme.titleLarge,
              )),
          Positioned(
            top: 50.0,
            left: MediaQuery.of(context).size.width / 1.2,
            right: 50,
            child: Builder(builder: (BuildContext context) {
              return FloatingActionButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Abre el menú lateral
                },
                backgroundColor: Colors.transparent,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.boy_rounded,
                  color: Colors.black,
                  size: 50,
                ),
              );
            }),
          ),
          Positioned(
            top: MediaQuery.of(context).size.width / 0.8,
            left: 50,
            right: 50,
            child: LargeButton(
              text: 'Voy para la U',
              onPressed: () {
                user.type == 2
                    ? Get.to(() => const NewTravel())
                    : Get.to(() => const AvailableTravels());
              },
              large: true,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.width / 0.8 + 100,
            left: 50,
            right: 50,
            child: LargeButton(
              text: 'Salgo de la U',
              onPressed: () {
                user.type == 2
                    ? Get.to(() => const NewTravel())
                    : Get.to(() => const AvailableTravels());
              },
              large: true,
            ),
          )
        ]));
  }
}
