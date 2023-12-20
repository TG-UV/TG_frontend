import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
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
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 23.0),
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
          Text(
            " Alerta de pasajero",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    ));
  }
}
