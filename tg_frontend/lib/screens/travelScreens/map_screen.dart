import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/screens/loginAndRegister/login.dart';
import 'package:tg_frontend/screens/travelScreens/available_travels.dart';
import 'package:tg_frontend/screens/travelScreens/new_travel.dart';
import 'package:tg_frontend/screens/travelScreens/search_travels.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:logger/logger.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/user_data.dart';

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
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> getLocation() async {
    final location = loc.Location();
    try {
      final myCurrentLocation = await location.getLocation();
      setState(() {
        currentLocation = myCurrentLocation;
      });
    } catch (e) {
      logger.e('Error getting location: $e');
    }
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
          shape: Border(right: BorderSide(color: Colors.red, width: 3)),
          child: ListView(
            children: <Widget>[
              SizedBox(
                  height: 130, // Cambia la altura aquí
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
                  leading: Icon(Icons.motorcycle_outlined),
                  title: Text('Añadir vehículo'),
                  onTap: () {},
                ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configuración'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.support_agent_outlined),
                title: Text('Soporte'),
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
                leading: Icon(Icons.login_outlined),
                title: Text('Cerrar sesión'),
                onTap: () {
                  _showConfirmationDialog(context);
                },
              ),
            ],
          ),
        ),
        body: Stack(children: [
          FlutterMap(
            options: const MapOptions(
                initialCenter: LatLng(3.43722, -76.5225),
                minZoom: 5,
                maxZoom: 25,
                initialZoom: 18),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: const {
                  'accessToken': mapboxAccessToken,
                  'id':
                      'mapbox/streets-v11', // Puedes cambiar el estilo según tus necesidades
                },
              ),
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

          /*
          MapboxMap(
            accessToken: 'TU_TOKEN_DE_ACCESO_AQUI',
            styleString: 'mapbox://styles/mapbox/streets-v11',
            onMapCreated: (MapboxMapController controller) {
              // Puedes agregar marcadores u otras configuraciones aquí
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194), // Coordenadas de San Francisco, puedes ajustar esto
              zoom: 12.0,
            ),
          ),
          */

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
                    : Get.to(() => const SearchTravels());
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
