import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/largeButton.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    super.key,
    required this.travel,
  });

  // final TextEditingController controller;

  final Travel travel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.grey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  travel.price,
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(width: 10),
                Text(
                  "Carro",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 25.0),
                  overflow: TextOverflow.ellipsis,
                ),

                //const SizedBox(width: 8),
              ],
            ),
            const SizedBox(width: 10),
            Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      "Juan Sebastian Estupiñan ",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${travel.seats} + cupos ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Partida: + ${travel.startingPoint}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Destino: + ${travel.arrivalPoint}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(width: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          child: Text(
                            '3.500',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 10),
                        LargeButton(
                          large: false,
                          text: "solicitar reserva",
                          onPressed: () {/* ... */},
                        ),
                        //const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
