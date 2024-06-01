import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/screens/travelScreens/listed_travels.dart';
import 'package:tg_frontend/screens/travelScreens/map_screen.dart';
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
    super.initState();
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
      bottomNavigationBar: ConvexAppBar(
        items: [
          const TabItem(
              icon: Icon(
            Icons.home,
            color: Colors.black,
          )),
          TabItem(icon: Consumer<TravelNotificationProvider>(
              builder: (context, travelNotificationProvider, _) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  onPressed: () {
                    Get.to(() => const ListedTravels(
                          pastTravel: false,
                        ));
                  },
                  icon: Icon(Icons.time_to_leave_sharp),
                  color: Colors.black,
                ),
                if (travelNotificationProvider.isTavelNotification)
                  Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
              ],
            );
          })),
          const TabItem(icon: Icon(Icons.timelapse_sharp, color: Colors.black)),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        style: TabStyle.react,
        backgroundColor: ColorManager.thirdColor,
      ),
      
    );
  }
}
