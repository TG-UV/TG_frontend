import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/screens/loginAndRegister/login.dart';
import 'package:tg_frontend/screens/loginAndRegister/vehicle_managment.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/screens/travelScreens/available_travels.dart';
import 'package:tg_frontend/screens/travelScreens/new_travel.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/widgets/lateral_bar.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:logger/logger.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tg_frontend/widgets/setUserInformation.dart';

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

  LatLng? myPosition = const LatLng(3.3765821, -76.5334617);
  LatLng universityPosition = const LatLng(3.3765821, -76.5334617);

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      await _getLocation();
    } else {
      await EasyLoading.showInfo("permiso denegado");
    }
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    myPosition = LatLng(position.latitude, position.longitude);
    setState(() {});
  }

  LatLng _getCenterPosition() {
    _getLocation();
    if (myPosition != null) {
      return myPosition!;
    } else {
      return universityPosition;
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
        drawer: LateralBar(),
        body: Stack(children: [
          FlutterMap(
            options: MapOptions(
                initialCenter: myPosition ?? universityPosition,
                minZoom: 5,
                maxZoom: 25,
                initialZoom: 15),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: const {
                  'accessToken': mapboxAccessToken,
                  'id': 'mapbox/streets-v11',
                },
              ),
              if (myPosition != null)
                MarkerLayer(markers: [
                  Marker(
                    point: myPosition!,
                    child: Icon(
                      Icons.location_on_sharp,
                      color: ColorManager.fourthColor,
                      size: 40,
                    ),
                  )
                ]),
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
            child: MainButton(
              text: 'Voy para la U',
              buttonColor: ColorManager.fourthColor,
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
            child: MainButton(
              text: 'Salgo de la U',
              buttonColor: ColorManager.fourthColor,
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
