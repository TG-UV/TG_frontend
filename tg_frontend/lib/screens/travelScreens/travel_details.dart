import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/passenger_associated_details_card.dart';
import 'package:tg_frontend/widgets/passenger_global_details_card.dart';
import 'package:tg_frontend/widgets/driver_details_card.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:get/get.dart';
import "package:get_it/get_it.dart";

class TravelDetails extends StatefulWidget {
  const TravelDetails({
    super.key,
    required this.selectedTravel,
    this.pastTravel,
  });

  final bool? pastTravel;
  final Travel selectedTravel;

  @override
  State<TravelDetails> createState() => _TravelDetailsState();
}

class _TravelDetailsState extends State<TravelDetails> {
  final TextEditingController locationController = TextEditingController();
  User user = Environment.sl.get<User>();

  Widget _detailsCardHandle() {
    if (widget.pastTravel == null) {
      return GlobalDetailsCard(travel: widget.selectedTravel);
    } else {
      return user.type == 2
          ? DriverDetailsCard(travel: widget.selectedTravel)
          : AssociatesDetailsCard(travel: widget.selectedTravel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          body: Container(
              color: ColorManager.fourthColor,
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
                    // InputField(
                    //     controller: locationController,
                    //     textInput: "Punto de recogida",
                    //     textInputType: TextInputType.text,
                    //     icon: const Icon(Icons.location_history),
                    //     obscure: false),
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
              height: user.type == 2
                  ? MediaQuery.of(context).size.height * 0.75
                  : MediaQuery.of(context).size.height *
                      0.67, // 3 cuartos de la pantallaS
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(50, 30),
                  topRight: Radius.elliptical(50, 30),
                ),
              ),
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  child: Column(children: [
                    Flexible(
                      child: _detailsCardHandle(),
                      fit: FlexFit.tight,
                    )
                  ])))),
      // Positioned(
      //     //top: 0,
      //     bottom: 40,
      //     left: 0,
      //     right: 0,
      //     child: Container(
      //         padding:
      //             const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),

      //         //color: const Color.fromARGB(255, 255, 58, 58),
      //         width: MediaQuery.of(context).size.width *
      //             0.75, // 3 cuartos de la pantalla
      //         height: MediaQuery.of(context).size.height *
      //             0.20, // 3 cuartos de la pantalla
      //         decoration: const BoxDecoration(
      //             color: Color.fromARGB(255, 235, 235, 235),
      //             borderRadius: BorderRadius.all(Radius.elliptical(30, 20))),
      //         child: Text("Reservar"))),
      Positioned(
          top: 30.0,
          left: 5.0,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: ColorManager.thirdColor,
              ))),
    ]);
  }
}
