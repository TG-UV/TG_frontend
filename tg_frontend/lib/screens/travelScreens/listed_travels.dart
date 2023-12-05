import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/travel_card.dart';

class ListedTravels extends StatefulWidget {
  const ListedTravels({
    super.key,
    required this.pastTravel,
  });

  // final TextEditingController controller;

  final bool pastTravel;

  @override
  State<ListedTravels> createState() => _ListedTravelsState();
}

class _ListedTravelsState extends State<ListedTravels> {
  List<Travel> travelsList = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            alignment: Alignment.topCenter,
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  widget.pastTravel
                      ? Text(
                          "Historial de viajes",
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      : Text(
                          "Tus próximos viajes",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
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
