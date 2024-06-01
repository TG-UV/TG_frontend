import 'package:flutter/material.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
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
    _selectEndpoint();
    super.initState();
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

  Stream<List<Travel>> _fetchTravelsStream() async* {
    _selectEndpoint();
    final value = await travelDatasourceImpl.getTravelsRemote(
        finalEndPoint: currentEndPoint, context: context);
    yield value;
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
              width: MediaQuery.of(context).size.width *
                  0.75, 
              height: MediaQuery.of(context).size.height *
                  0.75,
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
                            } else if (snapshot.hasError ||
                                snapshot.data == null) {
                              return Center(
                                child: Text(
                                  'Se produjo un error, intente mas tarde',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    overflow: TextOverflow.ellipsis,
                                    color: ColorManager.fourthColor,
                                  ),
                                  maxLines: 3,
                                ),
                              );
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
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: TravelCard(
                                            travel: travelsList[index],
                                            pastTravel:
                                                widget.pastTravel, //true
                                          ));
                                    });
                              }
                            }
                          })))))
    ]);
  }
}
