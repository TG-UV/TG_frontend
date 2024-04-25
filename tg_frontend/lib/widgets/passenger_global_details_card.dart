import 'package:flutter/material.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:latlong2/latlong.dart';

class GlobalDetailsCard extends StatefulWidget {
  const GlobalDetailsCard({
    super.key,
    required this.travel,
  });

  final Travel travel;

  @override
  State<GlobalDetailsCard> createState() => _GlobalDetailsCardState();
}

class _GlobalDetailsCardState extends State<GlobalDetailsCard> {
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();

  late Map<String, dynamic>? detailsList;
  final EndPoints _endPoints = EndPoints();
  final _formKey = GlobalKey<FormState>();
  var _seats = 1;

  final TextEditingController startingPointController = TextEditingController();

  final FocusNode _focusNodeStartingPoint = FocusNode();
  late FocusNode _currentFoco;
  List<String> _suggestions = [];
  late LatLng latLngStartingPoint;
  String dayOfWeekFormated = "Fecha";
  String startingPointTextDirection = "";
  String arrivalPointTextDirection = "";

  @override
  void initState() {
    _getTextDirections();
    super.initState();
    _loadTravelDetails();
    initializeDateFormat();
    String dayOfWeek =
        DateFormat('EEEE', 'es_ES').format(DateTime.parse(widget.travel.date));
    dayOfWeekFormated =
        "${dayOfWeek.substring(0, 1).toUpperCase()}${dayOfWeek.substring(1)}";
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

  void _seatsIncrement(int value) async {
    int newValue = _seats;
    if (value == 1 && _seats < widget.travel.seats) {
      newValue++;
    } else if (value == 0 && _seats > 1) {
      newValue--;
    }
    _seats = newValue;
    setState(() => _seats = newValue);
  }

  void initializeDateFormat() {
    initializeDateFormatting('es_ES', null);
  }

  DateTime _parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return DateTime(1, 1, 1, hour, minute);
  }

  // Future<Map<String, dynamic>?> _loadTravelDetails() async {
  //   Map<String, dynamic>? value;
  //   final listResponse = await travelDatasourceImpl.getTravelDetails(
  //       travelId: widget.travel.id,
  //       finalUrl: _endPoints.getTravelDetailsPassenger);
  //   if (listResponse != null) {
  //     value = listResponse.data;
  //   }
  //   return value;
  // }
  Future<void> _loadTravelDetails() async {
    Map<String, dynamic>? value;
    final listResponse = await travelDatasourceImpl.getTravelDetails(
        travelId: widget.travel.id,
        finalUrl: _endPoints.getTravelDetailsPassenger);
    if (listResponse != null) {
      setState(() {
        detailsList = listResponse.data;
      });
    }
  }

  void reserveSpot() async {
    Passenger passenger = Passenger(
        idPassenger: user.idUser,
        pickupPointLat: latLngStartingPoint.latitude,
        pickupPointLong: latLngStartingPoint.longitude,
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

  Future<void> _getSuggestion(String value) async {
    var response = await travelDatasourceImpl.getMapSuggestions(address: value);
    _suggestions = response;
    setState(() {});
  }

  Future<void> _getMapCoordinates(String value, FocusNode foco) async {
    var response = await travelDatasourceImpl.getMapCoordinates(address: value);
    setState(() {
      latLngStartingPoint = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.thirdColor,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: detailsList == null
                        ? const Center(child: CircularProgressIndicator())
                        : detailsList!.isEmpty
                            ? const Center(
                                child: Text('Información no disponible'))
                            : Container(
                                color: ColorManager.thirdColor,
                                // margin: const EdgeInsets.only(left: 30.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(
                                              dayOfWeekFormated,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              DateFormat('hh:mm a').format(
                                                  _parseTimeString(
                                                      widget.travel.hour)),
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
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    'Partida:  $startingPointTextDirection',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
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
                                      const SizedBox(height: 40),
                                      Row(
                                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '\$ ${widget.travel.price}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          const SizedBox(width: 20),
                                          Text(
                                            detailsList!["vehicle"]
                                                ["vehicle_type"],
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
                                            .copyWith(
                                                fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        '${widget.travel.seats} cupos disponibles ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.normal),
                                      ),
                                      const SizedBox(height: 50),
                                      Card(
                                          color: Colors.white,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Solicita tu cupo:  ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'cupos:  ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(Icons
                                                            .arrow_drop_up_outlined),
                                                        color: Colors.black,
                                                        iconSize: 40,
                                                        onPressed: () =>
                                                            _seatsIncrement(1),
                                                      ),
                                                      Text(
                                                        '$_seats',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall,
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(Icons
                                                            .arrow_drop_down_outlined),
                                                        color: Colors.black,
                                                        iconSize: 40,
                                                        onPressed: () =>
                                                            _seatsIncrement(0),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  InputField(
                                                      foco:
                                                          _focusNodeStartingPoint,
                                                      controller:
                                                          startingPointController,
                                                      textInput:
                                                          "Punto de recogida",
                                                      textInputType:
                                                          TextInputType.text,
                                                      color: ColorManager
                                                          .staticColor,
                                                      icon: const Icon(Icons
                                                          .location_history),
                                                      onChange: (value) {
                                                        _currentFoco =
                                                            _focusNodeStartingPoint;
                                                        _getSuggestion(value);
                                                      },
                                                      obscure: false),
                                                  if (_suggestions.isNotEmpty &&
                                                      _currentFoco ==
                                                          _focusNodeStartingPoint)
                                                    Positioned(
                                                      top: 50.0,
                                                      left: 0.0,
                                                      right: 0.0,
                                                      child: Container(
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 1,
                                                              blurRadius: 3,
                                                              offset:
                                                                  const Offset(
                                                                      0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: ListView.builder(
                                                          itemCount:
                                                              _suggestions
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              title: Text(
                                                                  _suggestions[
                                                                      index]),
                                                              onTap: () {
                                                                startingPointController
                                                                        .text =
                                                                    _suggestions[
                                                                        index];
                                                                _getMapCoordinates(
                                                                    _suggestions[
                                                                        index],
                                                                    _focusNodeStartingPoint);
                                                                _suggestions
                                                                    .clear();
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  const SizedBox(height: 30),
                                                  Center(
                                                      child: MainButton(
                                                    large: false,
                                                    text: "reservar",
                                                    onPressed: () {
                                                      reserveSpot();
                                                    },
                                                  ))
                                                ],
                                              ))),
                                      const SizedBox(height: 15),
                                    ]))))));
  }
}
