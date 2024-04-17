import 'package:flutter/material.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AssociatesDetailsCard extends StatefulWidget {
  const AssociatesDetailsCard({
    super.key,
    required this.travel,
  });

  final Travel travel;

  @override
  State<AssociatesDetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<AssociatesDetailsCard> {
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();
  late Map<String, dynamic>? detailsList;
  final EndPoints _endPoints = EndPoints();
  bool _hasCallSupport = false;
  Future<void>? _launched;

  @override
  void initState() {
    super.initState();
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  Stream<Map<String, dynamic>?> _loadTravelDetails() async* {
    Map<String, dynamic>? value;
    final listResponse = await travelDatasourceImpl.getTravelDetails(
        travelId: widget.travel.id,
        finalUrl: _endPoints.getTravelAssociatedPassenger);
    if (listResponse != null) {
      value = listResponse.data;
    }
    yield value;
  }

  void _cancelSpot(int idPassengerTrip) async {
    int sendResponse = await travelDatasourceImpl.deletePassengerRemote(
        passengerId: idPassengerTrip);
    if (sendResponse == 1) {
      await EasyLoading.showInfo("reserva cancelada");
      Navigator.of(context).pop();
    } else {
      await EasyLoading.showInfo("Error al cancelar");
      return;
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey.shade200,
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: StreamBuilder<Map<String, dynamic>?>(
                stream: _loadTravelDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    detailsList = snapshot.data;
                    if (detailsList!.isEmpty) {
                      return const Center(
                        child: Text('No hay información sobre este viaje'),
                      );
                    } else {
                      return Column(
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
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
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
                            const SizedBox(width: 10),
                            Text(
                              '      ${widget.travel.date}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontSize: 18.0),
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
                            Text(
                              '${detailsList!["seats"]} cupos reservados',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 45),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Conductor ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${detailsList!["trip"]["driver"]["first_name"]}  ${detailsList!["trip"]["driver"]["last_name"]}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.normal),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.phone),
                                      onPressed: _hasCallSupport
                                          ? () => setState(() {
                                                _launched = _makePhoneCall(
                                                    detailsList!["trip"]
                                                            ["driver"]
                                                        ["phone_number"]);
                                              })
                                          : null,
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 20),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '\$ ${widget.travel.price}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            detailsList!["trip"]["vehicle"]
                                                ["vehicle_type"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(fontSize: 25.0),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        ' ${detailsList!["trip"]["vehicle"]["license_plate"]}  ${detailsList!["trip"]["vehicle"]["vehicle_brand"]} ${detailsList!["trip"]["vehicle"]["vehicle_color"]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                        softWrap: true,
                                      ),
                                    ]),

                                //const SizedBox(width: 8),
                              ],
                            ),

                            const SizedBox(height: 50),
                            LargeButton(
                              large: false,
                              text: "cancelar",
                              onPressed: () {
                                _cancelSpot(detailsList!["id_passenger_trip"]);
                              },
                            ),
                            //const SizedBox(width: 8),

                            const SizedBox(height: 15)
                          ]);
                    }
                  }
                })));
  }
}
