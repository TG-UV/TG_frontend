import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/travelScreens/listed_notifications.dart';
import 'package:tg_frontend/screens/travelScreens/listed_travels.dart';
import 'package:tg_frontend/screens/travelScreens/map_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/services/auth_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // Home (Index = 0)
    const MapScreen(),

    // Scheduled Travles (Future)
    const ListedTravels(
      pastTravel: false,
    ),
    // History Travels (Past)
    const ListedTravels(
      pastTravel: true,
    ),
    // Notifications
    const ListedNotifications()
  ];

  void fetchData() async {
    String? token = await AuthStorage().getToken();

    if (token != null) {
      try {
        Dio dio = Dio();
        dio.options.headers['Authorization'] = 'Token $token';
        Response response = await dio
            .get('https://tg-backend-cojj.onrender.com/auth/users/me/');
        print('Respuesta del servidor: ${response.data}');
      } catch (error) {
        print('Error al realizar la solicitud: $error');
      }
    } else {
      print('No se encontró ningún token.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      //currentIndex: _selectedIndex,
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(
              icon: Icon(
            Icons.house_outlined,
            color: Colors.black,
          )),
          TabItem(
              icon: Icon(
            Icons.motorcycle_outlined,
            color: Colors.black,
          )),
          TabItem(icon: Icon(Icons.watch_later_outlined, color: Colors.black)),
          TabItem(
              icon: Icon(Icons.notifications_active_outlined,
                  color: Colors.black)),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        style: TabStyle.react,
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        //activeColor: Colors.blue, // Color del ítem seleccionado
        //curveItemInnerPadding: -15, // Ajusta este valor para cambiar el tamaño del cuadro alrededor del ítem seleccionado
      ),
      /*
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
      ),*/
    );
  }
}
