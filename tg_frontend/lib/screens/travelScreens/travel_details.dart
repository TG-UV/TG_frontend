import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/passenger_associated_details_card.dart';
import 'package:tg_frontend/widgets/passenger_global_details_card.dart';
import 'package:tg_frontend/widgets/driver_details_card.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';

class TravelDetails extends StatefulWidget {
  const TravelDetails({
    super.key,
    required this.selectedTravel,
    required this.pastTravel,
  });

  final bool pastTravel;
  final Travel selectedTravel;

  @override
  State<TravelDetails> createState() => _TravelDetailsState();
}

class _TravelDetailsState extends State<TravelDetails> {
  User user = Environment.sl.get<User>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
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
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: const Color.fromARGB(255, 231, 231, 231)),
                    ),
                    const SizedBox(height: 20),
                  ]))),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),

              //color: const Color.fromARGB(255, 255, 58, 58),
              width: MediaQuery.of(context).size.width *
                  0.75, // 3 cuartos de la pantalla
              height: MediaQuery.of(context).size.height *
                  0.75, // 3 cuartos de la pantalla
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 235, 235, 235),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  child: Column(children: [
                    Flexible(
                        child: user.type == 2
                            ? DriverDetailsCard(travel: widget.selectedTravel)
                            : widget.pastTravel
                                ? AssociatesDetailsCard(
                                    travel: widget.selectedTravel)
                                : GlobalDetailsCard(
                                    travel: widget.selectedTravel))
                  ]))))
    ]);
  }
}
