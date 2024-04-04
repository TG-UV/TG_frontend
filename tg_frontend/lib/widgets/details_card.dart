import 'package:flutter/material.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';

class DetailsCard extends StatefulWidget {
  const DetailsCard({
    super.key,
    required this.travel,
  });

  final Travel travel;

  @override
  State<DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  TravelDatasourceMethods travelDatasourceMethods =
      Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();
  var _seats = 1;

  void seatsIncrement() {
    setState(() {
      _seats++;
    });
  }

  void _reserveSpot() async {
    Passenger passenger = Passenger(
        idPassenger: user.idUser,
        pickupPoint: "no se aún",
        seats: _seats,
        isConfirmed: 0,
        trip: widget.travel.id,
        passenger: widget.travel.driver,
        phoneNumber: '324342534',
        firstName: 'nada',
        lastName: "aún");

    int sendResponse = await travelDatasourceMethods.insertPassengerRemote(
        passenger: passenger);
    if (sendResponse == 1) {}
  }

  void _cancelSpot(int passengerId) async {
    int sendResponse = await travelDatasourceMethods.deletePassengerRemote(
        passengerId: passengerId);
    if (sendResponse == 1) {}
  }

  @override
  Widget build(BuildContext context) {
    Card generalTravelInformation = Card(
      color: Colors.grey.shade200,
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '\$ ${widget.travel.price}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(width: 10),
                  Text(
                    "Motocicleta",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 25.0),
                    overflow: TextOverflow.ellipsis,
                  ),

                  //const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                  margin: const EdgeInsets.only(left: 40.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Juan Sebastian Estupiñan ",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                        Text(
                          '${widget.travel.seats} cupos disponibles ',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'Partida:  ${widget.travel.startingPoint}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Destino:   ${widget.travel.arrivalPoint}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ])),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    width: 13,
                  ),
                  Text(
                    'cupos: $_seats',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextButton.icon(
                      label: const Text(''),
                      onPressed: seatsIncrement,
                      icon: const Icon(
                        Icons.plus_one_rounded,
                        color: Colors.black,
                      )),

                  const SizedBox(height: 10),
                  LargeButton(
                    large: false,
                    text: "reservar",
                    onPressed: () {
                      _reserveSpot();
                    },
                  ),
                  //const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 15),
            ],
          )),
    );

    Card bookedTravelInformation = Card(
      color: Colors.grey.shade200,
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '\$ ${widget.travel.price}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(width: 10),
                  Text(
                    "Motocicleta",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 25.0),
                    overflow: TextOverflow.ellipsis,
                  ),

                  //const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                  margin: const EdgeInsets.only(left: 40.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Juan Sebastian Estupiñan ",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                        Text(
                          '3145872849',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'AVH 234',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'chevrolet onix rojo',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'Partida:  ${widget.travel.startingPoint}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Destino:   ${widget.travel.arrivalPoint}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ])),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    width: 13,
                  ),
                  Text(
                    'cupos: $_seats',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  const SizedBox(height: 10),
                  LargeButton(
                    large: false,
                    text: "cancelar",
                    onPressed: () {
                      _cancelSpot(user.idUser);
                    },
                  ),
                  //const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 15),
            ],
          )),
    );
    return Center(child: bookedTravelInformation);
  }
}
