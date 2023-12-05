import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';

class TravelCard extends StatelessWidget {
  const TravelCard({
    super.key,   
    required this.travel,
  });

  // final TextEditingController controller;

  final Travel travel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color(0xFFDD3D32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  child: Text(
                    "Miercoles",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 10),
                TextButton(
                  child: Text(
                    "8:30 am",
                    style: Theme.of(context).textTheme.titleLarge,
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
