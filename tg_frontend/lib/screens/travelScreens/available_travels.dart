import 'package:flutter/material.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/travelScreens/search_travels.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/widgets/travel_card.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';

class AvailableTravels extends StatefulWidget {
  const AvailableTravels({
    super.key,
  });
  
  @override
  State<AvailableTravels> createState() => _ListedTravelsState();
  
}

class _ListedTravelsState extends State<AvailableTravels> {
  TravelDatasourceMethods travelDatasourceMethods =
      Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();
  List<Travel> travelsList = [];
  final EndPoints _endPoints = EndPoints();
  
  @override
  void initState() {
    super.initState();
    _cargarViajes();
  }

  Future<void> _cargarViajes() async {
    travelsList = await travelDatasourceMethods.getTravelsRemote(finalEndPoint: _endPoints.getTravelPlannedDriver);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            //color: const Color(0xFFDD3D32),
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
                  const SizedBox(height: 20),
                  LargeButton(
                    text: 'Buscar',
                    large: false,
                    onPressed: () {
                      Get.to(() => const SearchTravels());
                    },
                  ),
                  const SizedBox(height: 30),
                  Text("!Viajes próximos a salir!",
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
