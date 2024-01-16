import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/large_button.dart';

class DetailsCard extends StatefulWidget {
  const DetailsCard({
    super.key,
    required this.travel,
  });

  // final TextEditingController controller;

  final Travel travel;

  @override
  State<DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  var _seats = 1;
  void seatsIncrement() {
    setState(() {
      _seats++;
    });
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
                    onPressed: () {/* ... */},
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
                    onPressed: () {/* ... */},
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