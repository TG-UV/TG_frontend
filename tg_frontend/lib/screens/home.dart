import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/screens/travelScreens/listed_notifications.dart';
import 'package:tg_frontend/screens/travelScreens/listed_travels.dart';
import 'package:tg_frontend/screens/travelScreens/map_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:tg_frontend/services/auth_services.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  DatabaseProvider databaseProvider = DatabaseProvider.db;
  late UserDatasourceMethods userDatasourceImpl;
  late Database database;
  Dio dio = Dio();

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

  @override
  void initState() {
    super.initState();
    // _initializePages();
    // setState(() {
      
    // });
  }

  // Future<void> _initializePages() async {
  //   User user = await _getUser();
  //   setState(() {
  //     _pages = [
  //       // Home (Index = 0)
  //       MapScreen(
  //         user: user,
  //       ),

  //       // Scheduled Travles (Future)
  //        ListedTravels(
  //         pastTravel: false,  user: user,
  //       ),
  //       // History Travels (Past)
  //        ListedTravels(
  //         pastTravel: true,  user: user,
  //       ),
  //       // Notifications
  //       const ListedNotifications()
  //     ];
  //   });
  // }

  Future<User> _getUser() async {
    database = await databaseProvider.database;
    userDatasourceImpl = UserDatasourceMethods();
    User user = await userDatasourceImpl.getUserLocal();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

   
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
