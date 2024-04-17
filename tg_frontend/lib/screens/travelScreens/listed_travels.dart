import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/widgets/travel_card.dart';
import 'package:http/http.dart' as http;
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:get_it/get_it.dart';

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
    _selectEndpoint();
    super.initState();
    //_cargarViajes();
  }

  void _selectEndpoint() {
    //double if to determinate ui case, it depends on user type and travel atribute(past or future)
    widget.pastTravel
        ? user.type == 2
            ? currentEndPoint = endPoints.getTravelHistoryDriver
            : currentEndPoint = endPoints.getTravelHistoryPassenger
        : user.type == 2
            ? currentEndPoint = endPoints.getTravelPlannedDriver
            : currentEndPoint = endPoints.getTravelPlannedPassenger;
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
    return Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(
          height: 90,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.pastTravel
              ? Text(
                  "Historial de viajes",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 26),
                )
              : Text(
                  "Tus próximos viajes",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 26),
                ),
        ),
      ]),
      Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),

              //color: const Color.fromARGB(255, 255, 58, 58),
              width: MediaQuery.of(context).size.width *
                  0.75, // 3 cuartos de la pantalla
              height: MediaQuery.of(context).size.height *
                  0.75, // 3 cuartos de la pantalla
              decoration: BoxDecoration(
                color: widget.pastTravel
                    ? ColorManager.fourthColor.withOpacity(0.5)
                    : ColorManager.fourthColor,
                borderRadius: const BorderRadius.only(
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
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: TravelCard(
                                            travel: travelsList[index],
                                            pastTravel: widget.pastTravel,//true
                                          ));
                                    });
                              }
                            }
                          })))))
    ]);
  }
}
