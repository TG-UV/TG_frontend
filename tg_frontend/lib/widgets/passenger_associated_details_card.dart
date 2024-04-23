import 'package:flutter/material.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';

class AssociatesDetailsCard extends StatefulWidget {
  const AssociatesDetailsCard({
    super.key,
    required this.travel,
  });

  final Travel travel;

  @override
  State<AssociatesDetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<AssociatesDetailsCard>
    with SingleTickerProviderStateMixin {
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();
  late Map<String, dynamic>? detailsList;
  final EndPoints _endPoints = EndPoints();
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String dayOfWeekFormated = "Fecha";
  late AnimationController _controller;
  String startingPointTextDirection = "";
  String arrivalPointTextDirection = "";

  @override
  void initState() {
    super.initState();
    _getTextDirections();
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
    initializeDateFormat();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  void initializeDateFormat() {
    initializeDateFormatting('es_ES', null);
  }

  void _getTextDirections() async {
    arrivalPointTextDirection = await travelDatasourceImpl.getTextDirection(
        lat: widget.travel.arrivalPointLat,
        long: widget.travel.arrivalPointLong);
    startingPointTextDirection = await travelDatasourceImpl.getTextDirection(
        lat: widget.travel.startingPointLat,
        long: widget.travel.startingPointLong);
    setState(() {});
  }

  DateTime _parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return DateTime(1, 1, 1, hour, minute);
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
                            if (!detailsList!["is_confirmed"])
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _controller.value,
                                    child: Text(
                                      'El conductor aún no ha confirmado',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: ColorManager.fourthColor,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    dayOfWeekFormated,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    DateFormat('hh:mm a').format(
                                        _parseTimeString(widget.travel.hour)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 25.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ]),
                            Text(
                              '      ${widget.travel.date}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 25),
                            Row(
                              children: [
                                const Image(
                                  image: AssetImage(
                                    'assets/side2side.png',
                                  ),
                                  width: 50,
                                  height: 70,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          'Partida:  $startingPointTextDirection',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          'Destino:   $arrivalPointTextDirection',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '    ${detailsList!["seats"]} cupos reservados',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 45),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                const SizedBox(width: 20),
                                if (detailsList!["is_confirmed"])
                                  Container(
                                    // color: Color.fromARGB(69, 127, 127, 127),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      color: Color.fromARGB(69, 127, 127, 127),
                                    ),
                                    child: Column(
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
                                                  fontWeight:
                                                      FontWeight.normal),
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
                                  ),

                                //const SizedBox(width: 8),
                              ],
                            ),

                            const SizedBox(height: 50),

                            Center(
                              child: MainButton(
                                large: true,
                                text: "cancelar cupo",
                                buttonColor: ColorManager.fourthColor,
                                onPressed: () {
                                  _cancelSpot(
                                      detailsList!["id_passenger_trip"]);
                                },
                              ),
                            ),
                            //const SizedBox(width: 8),

                            const SizedBox(height: 15)
                          ]);
                    }
                  }
                })));
  }
}
