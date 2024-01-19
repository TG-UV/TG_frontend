import 'package:flutter/material.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<Passenger> passengersList = [];

  @override
  void initState() {
    super.initState();
    _loadPassengers();
  }

  Future<void> _loadPassengers() async {
    final response = await http
        .get(Uri.parse('https://tg-backend-cojj.onrender.com/api/Passenger/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        passengersList = data.map((json) => Passenger.fromJson(json)).toList();
      });
    } else {
      throw Exception('Error al cargar los pasajeros de un viaje creado');
    }
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
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          Text(
            'Recoger en:  Calle 13 # 45-32',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          LargeButton(text: 'aceptar', large: false, onPressed: () {})
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
                        'Fecha: ${widget.travel.dateFormatted},  ${widget.travel.hourFormatted}',
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
                          itemCount: passengersList.length,
                          itemBuilder: (context, index) {
                            return buildPassengerInfo(passengersList[index]);
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
                          itemCount: passengersList.length,
                          itemBuilder: (context, index) {
                            return buildPassengerCard(passengersList[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ]))));
  }
}
