import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/screens/travelScreens/search_travels.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:tg_frontend/widgets/travel_card.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';

class AvailableTravels extends StatefulWidget {
  const AvailableTravels(
      {super.key, required this.startingPoint, required this.arrivalPoint});
  final LatLng startingPoint;
  final LatLng arrivalPoint;

  @override
  State<AvailableTravels> createState() => _ListedTravelsState();
}

class _ListedTravelsState extends State<AvailableTravels> {
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();
  List<Travel> travelsList = [];
  late Map<String, dynamic> requestData;

  @override
  void initState() {
    _initRequestData();
    super.initState();
  }

  void _initRequestData() {
    requestData = {
      "starting_point_lat":
          double.parse(widget.startingPoint.latitude.toStringAsFixed(6)),
      "starting_point_long":
          double.parse(widget.startingPoint.longitude.toStringAsFixed(6)),
      "arrival_point_lat":
          double.parse(widget.arrivalPoint.latitude.toStringAsFixed(6)),
      "arrival_point_long":
          double.parse(widget.arrivalPoint.longitude.toStringAsFixed(6)),
      "seats": "1",
      // "start_time": "5:25:00",
      // "start_date": "2024-04-29"
    };
    setState(() {});
  }

  Stream<List<Travel>> _fetchTravelsStream() async* {
    final value = await travelDatasourceImpl.getTravelSuggestions(
        searchData: requestData, context: context);
    yield value;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Row(children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              const SizedBox(width: 5),
              Text(
                "Busca un viaje",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 26),
              )
            ]),
            const SizedBox(height: 40),
            MainButton(
              text: 'Buscar',
              large: false,
              onPressed: () {
                Get.to(() => SearchTravels(
                      arrivalPoint: widget.arrivalPoint,
                      startingPoint: widget.startingPoint,
                    ));
              },
            ),
            const SizedBox(height: 30),
            Text("!Viajes próximos a salir!",
                style: Theme.of(context).textTheme.titleMedium),
          ]),
      Positioned(
          bottom: 0,
          left: 5,
          right: 5,
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),

              //color: const Color.fromARGB(255, 255, 58, 58),
              width: MediaQuery.of(context).size.width *
                  0.75, // 3 cuartos de la pantalla
              height: MediaQuery.of(context).size.height *
                  0.65, // 3 cuartos de la pantalla
              decoration: BoxDecoration(
                color: ColorManager.fourthColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: SizedBox(
                      height: 500,
                      child: StreamBuilder<List<Travel>>(
                          stream: _fetchTravelsStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              travelsList = snapshot.data ?? [];
                              if (travelsList.isEmpty) {
                                return const Center(
                                  child:
                                      Text('No tiene viajes por el momento...'),
                                );
                              } else {
                                return Flex(
                                  direction: Axis.vertical,
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "  Ahora",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(color: Colors.white),
                                          textAlign: TextAlign.left,
                                        )),
                                    //TravelCard(travel: perfectTravel),
                                    TravelCard(
                                      travel: travelsList[0],
                                    ),
                                    const SizedBox(height: 30),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Mas tarde",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(color: Colors.white),
                                          textAlign: TextAlign.left,
                                        )),
                                    Expanded(
                                        child: ListView.builder(
                                            itemCount: travelsList.length,
                                            itemBuilder: (context, index) {
                                              return TravelCard(
                                                travel: travelsList[index],
                                                pastTravel: false,
                                              );
                                            }))
                                  ],
                                );
                              }
                            }
                          })))))
    ]);
  }
}
