import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/travelScreens/newTravel.dart';
import 'package:tg_frontend/widgets/largeButton.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const mapboxAccessToken =
    'pk.eyJ1Ijoic2FybWFyaWUiLCJhIjoiY2xwYm15eTRrMGZyYjJtcGJ1bnJ0Y3hpciJ9.v5mHXrC66zG4x-dgZDdLSA';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // Home
    Center(
        child: Stack(children: [
      FlutterMap(
        options: MapOptions(
            center: LatLng(37.7749, -122.4194),
            minZoom: 5,
            maxZoom: 25,
            zoom: 18),
        nonRotatedChildren: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: const {
              'accessToken': mapboxAccessToken,
              'id':
                  'mapbox/streets-v11', // Puedes cambiar el estilo según tus necesidades
            },
          )
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
        top: 600.0,
        left: 50,
        right: 50,
        child: LargeButton(
          text: 'Voy para la U',
          onPressed: () {
            Get.to(() => const NewTravel());
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
            // Acción del botón
          },
          large: true,
        ),
      )
    ]))

    // Travels

    // History

    // Notifications
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.house_outlined, color: Colors.black),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.motorcycle_outlined,
              color: Colors.black,
            ),
            label: 'Viajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later_outlined, color: Colors.black),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.notifications_active_outlined, color: Colors.black),
            label: 'Notificaciones',
          ),
        ],
      ),
    );
  }
}
