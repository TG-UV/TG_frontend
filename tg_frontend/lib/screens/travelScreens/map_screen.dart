import 'package:flutter/material.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/screens/travelScreens/available_travels.dart';
import 'package:tg_frontend/screens/travelScreens/new_travel.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:logger/logger.dart';
import 'package:tg_frontend/models/user_model.dart';

final logger = Logger();

const mapboxAccessToken =
    'pk.eyJ1Ijoic2FybWFyaWUiLCJhIjoiY2xwYm15eTRrMGZyYjJtcGJ1bnJ0Y3hpciJ9.v5mHXrC66zG4x-dgZDdLSA';

class MapScreen extends StatefulWidget {
  final User user;
  const MapScreen({super.key, required this.user});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late loc.LocationData currentLocation;

  @override
  void initState() {
    super.initState();

    //getLocation();
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

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(children: [
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
            '¡Hola ${widget.user.firstName}!',
            style: Theme.of(context).textTheme.titleLarge,
          )),
      Positioned(
        top: 600.0,
        left: 50,
        right: 50,
        child: LargeButton(
          text: 'Voy para la U',
          onPressed: () {
            Get.to(() => NewTravel(user: widget.user));
          },
          large: true,
        ),
      ),
      Positioned(
        top: 700.0,
        left: 50,
        right: 50,
        child: LargeButton(
          text: 'Salgo de la U',
          onPressed: () {
            Get.to(() => const AvailableTravels());
          },
          large: true,
        ),
      )
    ]));
  }
}
