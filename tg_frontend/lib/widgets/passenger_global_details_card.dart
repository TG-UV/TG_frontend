import 'package:flutter/material.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class GlobalDetailsCard extends StatefulWidget {
  const GlobalDetailsCard({
    super.key,
    required this.travel,
  });

  final Travel travel;

  @override
  State<GlobalDetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<GlobalDetailsCard> {
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();

  late Map<String, dynamic>? detailsList;
  final EndPoints _endPoints = EndPoints();

  final TextEditingController locationController = TextEditingController();
  var _seats = 1;

  void _seatsIncrement(int value) async {
    //int value = 0;
    int newValue = _seats;
    if (value == 1 && _seats < widget.travel.seats) {
      newValue++;
    } else if (value == 0 && _seats > 1) {
      newValue--;
    }
    _seats = newValue;
    setState(() {});
  }

  Future<Map<String, dynamic>?> _loadTravelDetails() async {
    Map<String, dynamic>? value;
    final listResponse = await travelDatasourceImpl.getTravelDetails(
        travelId: widget.travel.id,
        finalUrl: _endPoints.getTravelDetailsPassenger);
    if (listResponse != null) {
      value = listResponse.data;
    }
    return value;
  }

  void _reserveSpot() async {
    Passenger passenger = Passenger(
        idPassenger: user.idUser,
        pickupPoint: locationController.text,
        seats: _seats,
        isConfirmed: 0,
        trip: widget.travel.id,
        passenger: user.idUser,
        phoneNumber: user.phoneNumber,
        firstName: user.firstName,
        lastName: user.lastName);

    int sendResponse =
        await travelDatasourceImpl.insertPassengerRemote(passenger: passenger);
    if (sendResponse == 1) {
      await EasyLoading.showInfo("Cupo solicitado");
      Navigator.of(context).pop();
    } else {
      await EasyLoading.showInfo("Error al reservar");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder<Map<String, dynamic>?>(
              future: _loadTravelDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  detailsList = snapshot.data;
                  if (detailsList!.isEmpty) {
                    return const Center(
                      child: Text('No tiene viajes por el momento...'),
                    );
                  } else {
                    return Container(
                        margin: const EdgeInsets.only(left: 30.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      DateFormat('EEEE').format(
                                          DateTime.parse(widget.travel.date)),
                                      //travel.date,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      widget.travel.hour,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(fontSize: 25.0),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                              Text(
                                '     ${widget.travel.date}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontSize: 16.0),
                                overflow: TextOverflow.ellipsis,
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
                              const SizedBox(height: 50),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '\$ ${widget.travel.price}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    detailsList!["vehicle"]["vehicle_type"],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 25.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Text(
                                '${detailsList!["driver"]["first_name"]}  ${detailsList!["driver"]["last_name"]}',
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
                              Row(
                                children: [
                                  Text(
                                    'cupos:  ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextButton.icon(
                                      label: const Text(''),
                                      onPressed: () => _seatsIncrement(0),
                                      icon: const Icon(
                                        Icons.exposure_minus_1_rounded,
                                        color: Colors.black,
                                      )),
                                  Text(
                                    '$_seats',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  TextButton.icon(
                                      label: const Text(''),
                                      onPressed: () => _seatsIncrement(1),
                                      icon: const Icon(
                                        Icons.plus_one_outlined,
                                        color: Colors.black,
                                      )),
                                ],
                              ),

                              const SizedBox(height: 10),
                              InputField(
                                  controller: locationController,
                                  textInput: "Punto de recogida",
                                  textInputType: TextInputType.text,
                                  icon: const Icon(Icons.location_history),
                                  obscure: false),
                                  const SizedBox(height: 10),
                              LargeButton(
                                large: false,
                                text: "reservar",
                                onPressed: () {
                                  _reserveSpot();
                                },
                              ),
                              //const SizedBox(width: 8),

                              const SizedBox(height: 15),
                            ]));
                  }
                }
              }),
        ));
  }
}
