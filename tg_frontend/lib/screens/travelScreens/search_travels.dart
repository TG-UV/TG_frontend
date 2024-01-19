import 'package:flutter/material.dart';
import 'package:tg_frontend/widgets/square_button.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/travel_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchTravels extends StatefulWidget {
  const SearchTravels({super.key});

  @override
  State<SearchTravels> createState() => _SearchTravelsState();
}

class _SearchTravelsState extends State<SearchTravels> {
  final TextEditingController startingPointController = TextEditingController();
  final TextEditingController arrivalPointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<Travel> travelsList = [];

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
      color: const Color(0xFFDD3D32),
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
              Text(
                "Busca un viaje",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 26),
              )
            ]),
            const SizedBox(height: 50),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Desde",
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.left,
                )),
            InputField(
              controller: startingPointController,
              textInput: 'Universidad del Valle',
              textInputType: TextInputType.text,
              obscure: false,
              icon: const Icon(Icons.edit),
            ),
            const SizedBox(height: 10),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Hacia",
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.left,
                )),
            InputField(
              controller: arrivalPointController,
              textInput: 'Home',
              textInputType: TextInputType.text,
              obscure: false,
              icon: const Icon(Icons.edit),
            ),
            const SizedBox(height: 40),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Cuando",
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.left,
                )),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              //BotonPersonalizado('Botón 1'),
              SquareButton(text: '10 min', onPressed: () {}),
              SquareButton(text: '30 min', onPressed: () {}),
              SquareButton(text: '1 hora', onPressed: () {}),
              SquareButton(
                myIcon: Icons.edit,
                text: '',
                onPressed: () {},
              ),
            ]),
            const SizedBox(height: 20),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Tu mejor opción",
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.left,
                )),
            //TravelCard(travel: perfectTravel),
            TravelCard(travel: travelsList[0]),
            const SizedBox(height: 30),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Revisa otras opciones",
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.left,
                )),
            Expanded(
                child: ListView.builder(
                    itemCount: travelsList.length,
                    itemBuilder: (context, index) {
                      return TravelCard(travel: travelsList[index]);
                    }))
          ]),
    ));
  }
}
