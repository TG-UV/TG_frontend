import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/screens/loginAndRegister/login.dart';
import 'package:tg_frontend/screens/loginAndRegister/vehicle_managment.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:tg_frontend/widgets/setUserInformation.dart';

final logger = Logger();

const mapboxAccessToken =
    'pk.eyJ1Ijoic2FybWFyaWUiLCJhIjoiY2xwYm15eTRrMGZyYjJtcGJ1bnJ0Y3hpciJ9.v5mHXrC66zG4x-dgZDdLSA';

class PassengerRequestCard extends StatefulWidget {
  const PassengerRequestCard(
      {super.key,
      required this.myPassenger,
      required this.onAccept,
      required this.onDeny});

  final Passenger myPassenger;
  final Function() onAccept;
  final Function() onDeny;
  @override
  State<PassengerRequestCard> createState() => _PassengerRequestCardState();
}

class _PassengerRequestCardState extends State<PassengerRequestCard> {
  User user = Environment.sl.get<User>();
  late LatLng coordinates;
  @override
  void initState() {
    coordinates = LatLng(
        widget.myPassenger.pickupPointLat, widget.myPassenger.pickupPointLong);
    super.initState();
    print("coordinates: $coordinates");
  }

  Widget _mapDialog() {
    return SizedBox(
      width: double.infinity,
      height: 135,
      child: FlutterMap(
        options: MapOptions(
            initialCenter: coordinates,
            minZoom: 5,
            maxZoom: 25,
            initialZoom: 15),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: const {
              'accessToken': mapboxAccessToken,
              'id': 'mapbox/streets-v11',
            },
          ),
          MarkerLayer(markers: [
            Marker(
              point: coordinates,
              child: Icon(
                Icons.location_on_sharp,
                color: ColorManager.fourthColor,
                size: 40,
              ),
            )
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 230,
        width: 230,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0.9,

            // color: ColorManager.thirdColor,
            //shadowColor: ColorManager.primaryColor,
            child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _mapDialog(),
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${widget.myPassenger.firstName} ${widget.myPassenger.lastName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),

                            Text('cupos: ${widget.myPassenger.seats}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontSize: 12)),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       ' Coordenadas: ',
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .titleSmall!
                            //           .copyWith(fontSize: 15),
                            //     ),
                            //     IconButton(
                            //         onPressed: () {
                            //           // Mostrar el AlertDialog con el mapa
                            //           showDialog(
                            //             context: context,
                            //             builder: (BuildContext context) {
                            //               return _mapDialog(LatLng(3.3765821, -76.5334617));
                            //             },
                            //           );
                            //         },
                            //         icon: const Icon(
                            //           Icons.location_on_outlined,
                            //           size: 20,
                            //         )),
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Spacer(),
                                TextButton(
                                    onPressed: () {
                                      widget.onDeny();
                                    },
                                    child: Text(
                                      "rechazar",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: ColorManager.fourthColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      widget.onAccept();
                                    },
                                    child: Text(
                                      "aceptar",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                    ))
                              ],
                            ),
                          ]))
                ])));
  }
}
