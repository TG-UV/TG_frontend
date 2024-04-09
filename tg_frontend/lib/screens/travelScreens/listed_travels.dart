import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
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
  EndPoints endPoints = EndPoints();
  late String currentEndPoint;
  late List<Travel> travelsList;

  @override
  void initState() {
    super.initState();
    //_cargarViajes();
  }

  void _selectEndpoint() {
    widget.pastTravel
        ? currentEndPoint = endPoints.getTravelHistoryDriver
        : currentEndPoint = endPoints.getTravelPlannedDriver;
  }

  // Future<void> _cargarViajes() async {
  //   travelsList = await travelDatasourceImpl.getTravelsRemote(travelId: 2);
  //   setState(() {});
  // }

  Stream<List<Travel>> _fetchTravelsStream() async* {
    _selectEndpoint();
    final value = await travelDatasourceImpl.getTravelsRemote(
        finalEndPoint: currentEndPoint);
    yield value;
    // setState(() {

    // });
  }

  @override
  Widget build(BuildContext context) {
  
    return Stack(
      children: [
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, 
      children: [ 
        const SizedBox(height: 50,),
        Padding(
         
          padding: const EdgeInsets.all(16.0),
          child: widget.pastTravel
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
        ),
      ]),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding:const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0), 

            //color: const Color.fromARGB(255, 255, 58, 58),
              width: MediaQuery.of(context).size.width *
                  0.75, // 3 cuartos de la pantalla
              height: MediaQuery.of(context).size.height *
                  0.75, // 3 cuartos de la pantalla
              decoration: const  BoxDecoration(
                color: Color.fromARGB(255, 255, 58, 58),
                borderRadius:  BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
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
                                return ListView.builder(
                                    itemCount: travelsList.length,
                                    //physics:const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                     return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TravelCard(travel: travelsList[index]));
                                    });
                              }
                            }
                          })))))
    ]);
  }
}
