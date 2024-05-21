import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/utils/date_Formatter.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:tg_frontend/widgets/route_info_card.dart';
import 'package:tg_frontend/widgets/seat_request_card.dart';

class DriverDetailsCard extends StatefulWidget {
  const DriverDetailsCard({
    super.key,
    required this.travel,
  });

  final Travel travel;

  @override
  State<DriverDetailsCard> createState() => _DriverDetailsCardState();
}

class _DriverDetailsCardState extends State<DriverDetailsCard> {
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();

  List<Passenger> confirmedPassengersList = [];
  List<Passenger> pendingPassengersList = [];

  String dayOfWeek = "Fecha";
  String startingPointTextDirection = "";
  String arrivalPointTextDirection = "";

  @override
  void initState() {
    _getTextDirections();
    super.initState();
    _loadPassengers();

    dayOfWeek = DateFormatter().dayOfWeekFormated(widget.travel.date);
  }

  void _getTextDirections() async {
    arrivalPointTextDirection = await travelDatasourceImpl.getTextDirection(
        lat: widget.travel.arrivalPointLat,
        long: widget.travel.arrivalPointLong,
        context: context);
    startingPointTextDirection = await travelDatasourceImpl.getTextDirection(
        lat: widget.travel.startingPointLat,
        long: widget.travel.startingPointLong,
        context: context);
    setState(() {});
  }

  Future<void> _loadPassengers() async {
    List<Passenger> passengersList = await travelDatasourceImpl
        .getPassangersRemote(travelId: widget.travel.id, context: context);
    setState(() {
      confirmedPassengersList =
          passengersList.where((element) => element.isConfirmed == 1).toList();
      pendingPassengersList =
          passengersList.where((element) => element.isConfirmed == 0).toList();
    });
  }

  Future<void> _confirmPassenger(
      int passengerTripId, bool valueConfirmed) async {
    int updatePassengers = await travelDatasourceImpl.updatePassengerRemote(
        passengerTripId: passengerTripId,
        valueConfirmed: valueConfirmed,
        context: context);
    if (updatePassengers != 0) {
      _loadPassengers();
    } else {
      await EasyLoading.showInfo("Hubo un error");
      return;
    }
  }

  void _cancelPassenger(int passengerId) async {
    int sendResponse = await travelDatasourceImpl.deleteSpotDriverRemote(
        idPassengerTrip: passengerId, context: context);
    if (sendResponse != 0) {
      _loadPassengers();
    } else {
      await EasyLoading.showInfo("Hubo un error");
      return;
    }
  }

  void _deleteTravel() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content:
              const Text('¿Estás seguro de que quieres eliminar el viaje?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                int sendResponse =
                    await travelDatasourceImpl.deleteTravelRemote(
                        travelId: widget.travel.id.toString(),
                        context: context);
                if (sendResponse != 0) {
                  await EasyLoading.showInfo("Se eliminó tu viaje..");
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  await EasyLoading.showInfo("Hubo un error");
                  return;
                }
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              dayOfWeek,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              DateFormatter().timeFormatedTextController(
                                  widget.travel.hour),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: 25.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                      Text(
                        '   ${widget.travel.date}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 16.0),
                      ),
                      Row(
                        children: [
                          const Image(
                            image: AssetImage(
                              'assets/side2side.png',
                            ),
                            width: 50,
                            height: 70,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    'Desde: $startingPointTextDirection',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontSize: 14),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    'Hacia: $arrivalPointTextDirection',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${widget.travel.seats} cupos ',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.normal, fontSize: 14),
                        textAlign: TextAlign.end,
                      ),
                      Text(
                        '\$ ${widget.travel.price} ',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 14),
                        textAlign: TextAlign.end,
                      ),
                      //const SizedBox(height: 10),
                      confirmedPassengersList.isNotEmpty
                          ? Row(children: [
                              TextButton.icon(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return RouteInfoCard(
                                            passengersList:
                                                confirmedPassengersList,
                                            travel: widget.travel);
                                      });
                                },
                                icon: Icon(
                                  Icons.people_alt_rounded,
                                  color: ColorManager.fourthColor,
                                ),
                                label: Text('Ver ruta con pasajeros',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 10),
                            ])
                          :
                          //AnimatedIcon(icon: AnimatedIcons.list_view, progress: progress)
                          Text(
                              "...Aún no tienes pasajeros en tu viaje... ",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                      const Divider(),
                      if (pendingPassengersList.isNotEmpty)
                        Text(
                          'Están solicitando un cupo',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                      SizedBox(
                        height: 252,
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: pendingPassengersList.length,
                            itemExtent: 250,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: PassengerRequestCard(
                                      myPassenger: pendingPassengersList[index],
                                      onAccept: () => setState(() {
                                            confirmedPassengersList.add(
                                                pendingPassengersList[index]);
                                            pendingPassengersList
                                                .removeAt(index);
                                            _confirmPassenger(
                                                pendingPassengersList[index]
                                                    .idPassenger,
                                                true);
                                          }),
                                      onDeny: () => setState(() {
                                            pendingPassengersList
                                                .removeAt(index);
                                            _cancelPassenger(
                                                pendingPassengersList[index]
                                                    .idPassenger);
                                          })));
                              // return buildPassengerCard(
                              //     pendingPassengersList[index],
                              //     () => setState(() {
                              //           confirmedPassengersList
                              //               .add(pendingPassengersList[index]);
                              //           pendingPassengersList.removeAt(index);
                              //            _confirmPassenger(pendingPassengersList[index].idPassenger, true);
                              //         }),
                              //     () => setState(() {
                              //           pendingPassengersList.removeAt(index);
                              //            _cancelPassenger(pendingPassengersList[index].idPassenger);
                              //         })
                              //         );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Center(
                          child: MainButton(
                        large: true,
                        text: "cancelar viaje",
                        buttonColor: ColorManager.fourthColor,
                        onPressed: () {
                          _deleteTravel();
                        },
                      ))
                    ]))));
  }
}
