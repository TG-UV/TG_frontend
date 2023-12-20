import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';

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
                TextButton(
                  child: Text(
                    '3.500',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 10),
                TextButton(
                  child: Text(
                    "Carro",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 25.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      "Juan Sebastian Estupiñan ",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      "3 cupos",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      "Partida: Carrera 58 # 10-53 ",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      " Destino: Universidad del Valle",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
