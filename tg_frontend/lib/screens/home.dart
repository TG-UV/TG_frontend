import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/screens/travelScreens/listed_travels.dart';
import 'package:tg_frontend/screens/travelScreens/map_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/services/travel_notification_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  DatabaseProvider databaseProvider = DatabaseProvider.db;
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  late Database database;
  Dio dio = Dio();
  bool _varHasNotifications = false;

  final List<Widget> _pages = [
    // Home (Index = 0)
    MapScreen(),

    // Scheduled Travles (Future)
    const ListedTravels(
      pastTravel: false,
    ),
    // History Travels (Past)
    const ListedTravels(
      pastTravel: true,
    ),
  ];

  @override
  void initState() {
    userDatasourceImpl.initDatabase();
    travelDatasourceImpl.initDatabase();
    // _hasNotifications =
    //     Provider.of<TravelNotificationProvider>(context).isTavelNotification;
    super.initState();
  }

  Widget _buildIconWithBadge(IconData iconData, bool _hasNotifications) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Icon(
          iconData,
          color: Colors.black,
        ),
        if (_hasNotifications)
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _hasNotifications = Provider.of<TravelNotificationProvider>(context);

    if (_pages.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // return Consumer<TravelNotificationProvider>(
    //     builder: (context, notificationProvider, _) {
    //   _hasNotifications = notificationProvider.isTavelNotification;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        items: [
          const TabItem(
              icon: Icon(
            Icons.home,
            color: Colors.black,
          )),
          TabItem(
              icon: _buildIconWithBadge(Icons.time_to_leave_sharp,
                  _hasNotifications.isTavelNotification)),
          const TabItem(icon: Icon(Icons.timelapse_sharp, color: Colors.black)),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            //  _hasNotifications = false;
          });
        },
        style: TabStyle.react,
        backgroundColor: ColorManager.thirdColor,
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
