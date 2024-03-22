import 'package:flutter/material.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/travel_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tg_frontend/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tg_frontend/datasource/travel_data.dart';

class ListedTravels extends StatefulWidget {
  const ListedTravels(
      {super.key, required this.pastTravel, required this.user});

  // final TextEditingController controller;

  final bool pastTravel;
  final User user;

  @override
  State<ListedTravels> createState() => _ListedTravelsState();
}

class _ListedTravelsState extends State<ListedTravels> {
  DatabaseProvider databaseProvider = DatabaseProvider.db;
  late TravelDatasourceMethods travelDatasourceImpl;
  late Database database;
  Dio dio = Dio();
  EndPoints endPoints = EndPoints();
  List<Travel> travelsList = [];
  /*
    Travel(
        id: '1',
        arrivalPoint: 'Carrera 59 #11-94',
        startingPoint: 'Univalle',
        driver: 'Javier Perez',
        passengers: ['Sara Eraso, Andrea Perez'],
        price: '3000',
        seats: 3,
        hour: '11:00 am',
        date: '1-Dic-2023'),
    Travel(
        id: '2',
        arrivalPoint: 'Univalle',
        startingPoint: 'Conjunto Cantabria ',
        driver: 'Carlos Perez',
        passengers: ['Sara Eraso'],
        price: '4000',
        seats: 1,
        hour: '3:00 pm',
        date: '3-Dic-2023')
  ];
  */

  @override
  void initState() {
    super.initState();
    _initData();
    _cargarViajes();
  }

  Future<void> _initData() async {
    database = await databaseProvider.database;
    travelDatasourceImpl = TravelDatasourceMethods(dio, database, endPoints);
  }

  Future<void> _cargarViajes() async {
    
  }
  // Future<void> _cargarViajes() async {
  //   final response = await http
  //       .get(Uri.parse('https://tg-backend-cojj.onrender.com/api/Trip/'));

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     setState(() {
  //       travelsList = data.map((json) => Travel.fromJson(json)).toList();
  //     });
  //   } else {
  //     throw Exception('Error al cargar los viajes');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFFDD3D32),
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            alignment: Alignment.topCenter,
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Row(children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    const SizedBox(width: 10),
                    widget.pastTravel
                        ? Text(
                            "Historial de viajes",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 26),
                          )
                        : Text(
                            "Tus próximos viajes",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 26),
                          ),
                  ]),

                  const SizedBox(height: 30),
                  //const TravelCard(),

                  Expanded(
                      child: ListView.builder(
                          itemCount: travelsList.length,
                          itemBuilder: (context, index) {
                            return TravelCard(travel: travelsList[index]);
                          }))
                ])));
  }
}
