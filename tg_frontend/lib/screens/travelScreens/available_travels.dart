import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/travelScreens/search_travels.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/widgets/travel_card.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AvailableTravels extends StatefulWidget {
  const AvailableTravels({
    super.key,
  });

  @override
  State<AvailableTravels> createState() => _ListedTravelsState();
}

class _ListedTravelsState extends State<AvailableTravels> {
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

  Travel perfectTravel = Travel(
      id: '3',
      arrivalPoint: 'Univalle',
      startingPoint: 'Comfandi guadalupe ',
      driver: 'Carlos Perez',
      passengers: ['Sara Eraso'],
      price: '4000',
      seats: 1,
      hour: '1:00 pm',
      date: '3-Dic-2023');
      */

  @override
  void initState() {
    super.initState();
    _cargarViajes();
  }

  Future<void> _cargarViajes() async {
    final response = await http
        .get(Uri.parse('https://tg-backend-cojj.onrender.com/api/Trip/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        travelsList = data.map((json) => Travel.fromJson(json)).toList();
      });
    } else {
      throw Exception('Error al cargar los viajes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            alignment: Alignment.topCenter,
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Busca un viaje",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  LargeButton(
                    text: 'Buscar',
                    large: false,
                    onPressed: () {
                      Get.to(() => const SearchTravels());
                    },
                  ),
                  const SizedBox(height: 30),
                  Text("!Viajes Próximos a salir!",
                      style: Theme.of(context).textTheme.titleMedium),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Ahora",
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.left,
                      )),
                  //TravelCard(travel: perfectTravel),
                  TravelCard(travel: travelsList[0]),
                  const SizedBox(height: 30),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Mas tarde",
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.left,
                      )),
                  Expanded(
                      child: ListView.builder(
                          itemCount: travelsList.length,
                          itemBuilder: (context, index) {
                            return TravelCard(travel: travelsList[index]);
                          }))
                ])));
  }
}
