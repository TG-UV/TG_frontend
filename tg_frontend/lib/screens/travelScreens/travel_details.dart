import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/details_card.dart';
import 'package:tg_frontend/widgets/driver_details_card.dart';

class TravelDetails extends StatefulWidget {
  const TravelDetails({
    super.key,
    required this.selectedTravel,
  });

  final Travel selectedTravel;

  @override
  State<TravelDetails> createState() => _TravelDetailsState();
}

class _TravelDetailsState extends State<TravelDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: const Color(0xFFDD3D32),
         
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            alignment: Alignment.topCenter,
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Detalles del viaje",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  //DetailsCard(travel: widget.selectedTravel)
                  DriverDetailsCard(travel: widget.selectedTravel)
                ])));
  }
}
