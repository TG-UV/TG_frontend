import 'package:flutter/material.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/device/environment.dart';

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

  @override
  void initState() {
    super.initState();
    _loadPassengers();
  }

  Future<void> _loadPassengers() async {
    List<Passenger> passengersList =
        await travelDatasourceImpl.getPassangersRemote(travelId: 2);
    confirmedPassengersList =
        passengersList.where((element) => element.isConfirmed == 1).toList();
    pendingPassengersList =
        passengersList.where((element) => element.isConfirmed == 0).toList();
    setState(() {});
  }

  Future<void> _updatePassengers(
      int passengerTripId, bool valueConfirmed) async {
    void updatePassengers = await travelDatasourceImpl.updatePassengerRemote(
        passengerTripId: passengerTripId, valueConfirmed: valueConfirmed);
    _loadPassengers();
  }

  Card buildPassengerInfo(Passenger myPassenger) {
    return Card(
        //color: Colors.white54,
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
                  onPressed: () {},
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
    return Center(
        child: Card(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Partida:  ${widget.travel.startingPoint}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        'Destino:   ${widget.travel.arrivalPoint}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        'Fecha: ${widget.travel.date},  ${widget.travel.hour}',
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
                        '${widget.travel.price} ',
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
                          physics: const NeverScrollableScrollPhysics(),
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
                      Container(
                        height: 150,
                        alignment: Alignment.topLeft,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: pendingPassengersList.length,
                          itemBuilder: (context, index) {
                            return buildPassengerCard(
                                pendingPassengersList[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ]))));
  }
}
