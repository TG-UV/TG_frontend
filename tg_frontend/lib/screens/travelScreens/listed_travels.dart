import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/home.dart';
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
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();

  late List<Travel> travelsList;

  @override
  void initState() {
    super.initState();
    //_cargarViajes();
  }

  // Future<void> _cargarViajes() async {
  //   travelsList = await travelDatasourceImpl.getTravelsRemote(travelId: 2);
  //   setState(() {});
  // }

  Stream<List<Travel>> _fetchTravelsStream() async* {
    final value = await travelDatasourceImpl.getTravelsRemote();
    yield value;
    // setState(() {
      
    // });
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
                          Get.to(() => const Home());
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
                  Expanded(
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
                                      child: Text(
                                          'No tiene viajes por el momento...'),
                                    );
                                  } else {
                                    
                                          return ListView.builder(
                                              itemCount: travelsList.length,
                                              //physics:const AlwaysScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return TravelCard(
                                                    travel: travelsList[index]);
                                              });
                          }
                                  }
                                }
                              )))
                  // travelsList.isEmpty
                  //     ? const Center(
                  //         child: Text('No tiene viajes por el momento...'),
                  //       )
                  //     : Expanded(
                  //         child: ListView.builder(
                  //             itemCount: travelsList.length,
                  //             itemBuilder: (context, index) {
                  //               return TravelCard(travel: travelsList[index]);
                  //             }))
                ])));
  }
}
