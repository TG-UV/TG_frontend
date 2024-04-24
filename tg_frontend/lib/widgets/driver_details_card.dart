import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/date_symbol_data_local.dart';

const mapboxAccessToken =
    'pk.eyJ1Ijoic2FybWFyaWUiLCJhIjoiY2xwYm15eTRrMGZyYjJtcGJ1bnJ0Y3hpciJ9.v5mHXrC66zG4x-dgZDdLSA';

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
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String dayOfWeekFormated = "Fecha";
  String startingPointTextDirection = "";
  String arrivalPointTextDirection = "";

  @override
  void initState() {
    _getTextDirections();
    super.initState();
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
    _loadPassengers();
    initializeDateFormat();
    String dayOfWeek =
        DateFormat('EEEE', 'es_ES').format(DateTime.parse(widget.travel.date));
    dayOfWeekFormated =
        "${dayOfWeek.substring(0, 1).toUpperCase()}${dayOfWeek.substring(1)}";
  }

  void _getTextDirections() async {
    arrivalPointTextDirection = await travelDatasourceImpl.getTextDirection(
        lat: widget.travel.arrivalPointLat,
        long: widget.travel.arrivalPointLong);
    startingPointTextDirection = await travelDatasourceImpl.getTextDirection(
        lat: widget.travel.startingPointLat,
        long: widget.travel.startingPointLong);
    setState(() {});
  }

  void initializeDateFormat() {
    initializeDateFormatting('es_ES', null);
  }

  DateTime _parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return DateTime(1, 1, 1, hour, minute);
  }

  Future<void> _loadPassengers() async {
    List<Passenger> passengersList = await travelDatasourceImpl
        .getPassangersRemote(travelId: widget.travel.id);
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
        passengerTripId: passengerTripId, valueConfirmed: valueConfirmed);
    if (updatePassengers != 0) {
      _loadPassengers();
    } else {
      await EasyLoading.showInfo("Hubo un error");
      return;
    }
  }

  void _cancelPassenger(int passengerId) async {
    int sendResponse = await travelDatasourceImpl.deletePassengerRemote(
        passengerId: passengerId);
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
                int sendResponse = await travelDatasourceImpl
                    .deleteTravelRemote(travelId: widget.travel.id.toString());
                if (sendResponse != 0) {
                  await EasyLoading.showInfo("Se eliminó tu viaje..");
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Widget _mapDialog(LatLng coordinates) {
    return AlertDialog(
      title: Text(
        'Punto para recoger',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: ColorManager.primaryColor, fontFamily: 'Jost', fontSize: 18),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300.0,
        child: FlutterMap(
          options: MapOptions(
              initialCenter: coordinates,
              minZoom: 5,
              maxZoom: 25,
              initialZoom: 15),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
              additionalOptions: const {
                'accessToken': mapboxAccessToken,
                'id': 'mapbox/streets-v11',
              },
            ),
            MarkerLayer(markers: [
              Marker(
                point: coordinates,
                child: Icon(
                  Icons.location_on_sharp,
                  color: ColorManager.fourthColor,
                  size: 40,
                ),
              )
            ]),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cerrar',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget buildPassengerInfo(Passenger myPassenger) {
    return SizedBox(
        height: 30,
        width: 210,
        child: Card(
            color: ColorManager.thirdColor,
            borderOnForeground: false,
            child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ' ${myPassenger.firstName} ${myPassenger.lastName} ',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              // Mostrar el AlertDialog con el mapa
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return _mapDialog(
                                      const LatLng(3.3765821, -76.5334617));
                                },
                              );
                            },
                            icon: const Icon(Icons.location_on_outlined)),
                        const SizedBox(width: 2),
                        IconButton(
                          icon: const Icon(Icons.phone_enabled),
                          onPressed: _hasCallSupport
                              ? () => setState(() {
                                    _launched =
                                        _makePhoneCall(myPassenger.phoneNumber);
                                  })
                              : null,
                        ),
                      ])
                ])));
  }

  Widget buildPassengerCard(
      Passenger myPassenger, Function onAccept, Function onDelete) {
    return SizedBox(
        height: 170,
        width: 230,
        child: Card(
          elevation: 0.9,
          // color: ColorManager.thirdColor,
          //shadowColor: ColorManager.primaryColor,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                    '  ${myPassenger.firstName} ${myPassenger.lastName}',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              Text('  ${myPassenger.seats} asiento',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' Coordenadas: ',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 15),
                  ),
                  IconButton(
                      onPressed: () {
                        // Mostrar el AlertDialog con el mapa
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _mapDialog(LatLng(3.3765821, -76.5334617));
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.location_on_outlined,
                        size: 20,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        onDelete();
                        _cancelPassenger(myPassenger.idPassenger);
                      },
                      child: Text(
                        "rechazar",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: ColorManager.fourthColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                  TextButton(
                      onPressed: () {
                        onAccept();
                        _confirmPassenger(myPassenger.idPassenger, true);
                      },
                      child: Text(
                        "aceptar",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              dayOfWeekFormated,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              DateFormat('hh:mm a')
                                  .format(_parseTimeString(widget.travel.hour)),
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
                      const SizedBox(height: 10),
                      Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(Icons.people_alt_rounded),
                            const SizedBox(width: 10),
                            Column(children: [
                              Text('Pasajeros',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w800)),
                            ])
                          ]),
                      confirmedPassengersList.isNotEmpty
                          ? SizedBox(
                              //width: 300,
                              height: 100,
                              child: Container(
                                  alignment: Alignment.topLeft,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      // scrollDirection: Axis.horizontal,
                                      // shrinkWrap: true,
                                      //physics: const NeverScrollableScrollPhysics(),
                                      itemCount: confirmedPassengersList.length,
                                      itemBuilder: (context, index) {
                                        return buildPassengerInfo(
                                            confirmedPassengersList[index]);
                                      })))
                          : Text(
                              "...Aún no tienes pasajeros en tu viaje ",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                      Divider(),
                      if (pendingPassengersList.isNotEmpty)
                        Text(
                          'Están solicitando un cupo',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w800, fontSize: 19),
                        ),
                      SizedBox(
                        height: 150,
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: pendingPassengersList.length,
                            itemBuilder: (context, index) {
                              return buildPassengerCard(
                                  pendingPassengersList[index],
                                  () => setState(() {
                                        confirmedPassengersList
                                            .add(pendingPassengersList[index]);
                                        pendingPassengersList.removeAt(index);
                                         _confirmPassenger(pendingPassengersList[index].idPassenger, true);
                                      }),
                                  () => setState(() {
                                        pendingPassengersList.removeAt(index);
                                         _cancelPassenger(pendingPassengersList[index].idPassenger);
                                      }));
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
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
