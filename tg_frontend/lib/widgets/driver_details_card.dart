import 'package:flutter/material.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
    _loadPassengers();
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

  Future<void> _updatePassengers(
      int passengerTripId, bool valueConfirmed) async {
    int updatePassengers = await travelDatasourceImpl.updatePassengerRemote(
        passengerTripId: passengerTripId, valueConfirmed: valueConfirmed);
    if (updatePassengers != 0) {
      _loadPassengers();
    } else {
      await EasyLoading.showInfo("Error");
      return;
    }
  }

  void _cancelTravel(int passengerId) async {
    int sendResponse = await travelDatasourceImpl.deletePassengerRemote(
        passengerId: passengerId);
    if (sendResponse == 1) {
      await EasyLoading.showInfo("reserva cancelada");
      Navigator.of(context).pop();
    } else {
      await EasyLoading.showInfo("Error al cancelar");
      return;
    }
  }

  // _launchCaller(String phoneNumber) async {
  // Uri url = 'tel:$phoneNumber';
  // if (await canLaunchUrl(url)) {
  //   await launchUrl(url);
  // } else {
  //   throw 'No se pudo realizar la llamada: $url';
  // }
  // }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Card buildPassengerInfo(Passenger myPassenger) {
    return Card(
        color: Colors.white54,
        borderOnForeground: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  ' ${myPassenger.firstName} ${myPassenger.lastName} ',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: _hasCallSupport
                      ? () => setState(() {
                            _launched = _makePhoneCall(myPassenger.phoneNumber);
                          })
                      : null,
                  // child: _hasCallSupport
                  //     ? const Text('Make phone call')
                  //     : const Text('Calling not supported'),
                ),
              ])
        ]));
  }

  Card buildPassengerCard(Passenger myPassenger) {
    return Card(
      color: Colors.white54,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                ' ${myPassenger.firstName} ${myPassenger.lastName}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onPressed: () {
                  _updatePassengers(myPassenger.idPassenger, false);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          Text(
            'recoger en: ${myPassenger.pickupPoint}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          LargeButton(
              text: 'aceptar',
              large: false,
              onPressed: () {
                _updatePassengers(myPassenger.idPassenger, true);
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              DateFormat('EEEE')
                                  .format(DateTime.parse(widget.travel.date)),
                              //travel.date,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.travel.hour,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: 25.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                      const SizedBox(height: 20),
                      Text(
                        'Desde: ${widget.travel.startingPoint}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        'Hacia: ${widget.travel.arrivalPoint}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '${widget.travel.seats} cupos disponibles ',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                      Text(
                        '\$ ${widget.travel.price} ',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 25),
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
                      ListView.builder(
                          shrinkWrap: true,
                          //physics: const NeverScrollableScrollPhysics(),
                          itemCount: confirmedPassengersList.length,
                          itemBuilder: (context, index) {
                            return buildPassengerInfo(
                                confirmedPassengersList[index]);
                          }),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Pasajeros pendientes',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w800),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: pendingPassengersList.length,
                            itemBuilder: (context, index) {
                              return pendingPassengersList.isNotEmpty
                                  ? buildPassengerCard(
                                      pendingPassengersList[index])
                                  : Text(
                                      'No tienes pasajeros pendientes',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.normal),
                                    );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      LargeButton(
                        large: false,
                        text: "cancelar",
                        onPressed: () {
                          _cancelTravel(user.idUser);
                        },
                      ),
                    ]))));
  }
}
