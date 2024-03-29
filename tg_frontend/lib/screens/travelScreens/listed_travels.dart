import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/travel_card.dart';
import 'package:http/http.dart' as http;
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/device/environment.dart';

class ListedTravels extends StatefulWidget {
  const ListedTravels({super.key, required this.pastTravel});
  final bool pastTravel;

  @override
  State<ListedTravels> createState() => _ListedTravelsState();
}

class _ListedTravelsState extends State<ListedTravels> {

  TravelDatasourceMethods travelDatasourceImpl = Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();


  List<Travel> travelsList = [];

  @override
  void initState() {
    super.initState();
    _cargarViajes();
  }

  Future<void> _cargarViajes() async {
    travelsList = await travelDatasourceImpl.getTravelsRemote(travelId: 2);
    setState(() {});
  }



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
                  travelsList.isEmpty
                      ? const Center(
                          child: Text('No tiene viajes por el momento...'),
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount: travelsList.length,
                              itemBuilder: (context, index) {
                                return TravelCard(travel: travelsList[index]);
                              }))
                ])));
  }
}
