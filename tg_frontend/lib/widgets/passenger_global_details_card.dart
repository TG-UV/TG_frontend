import 'package:flutter/material.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/utils/date_Formatter.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_frontend/widgets/map_location_selector.dart';

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
  late FocusNode emptyFocus = FocusNode();
  List<String> _suggestions = [];
  late LatLng latLngStartingPoint;
  String dayOfWeek = "Fecha";
  String startingPointTextDirection = "";
  String arrivalPointTextDirection = "";

  final GlobalKey _startingPointKey = GlobalKey();
  Offset? startingPointPosition;

  @override
  void initState() {
    _getTextDirections();
    super.initState();
    _loadTravelDetails();
    dayOfWeek = DateFormatter().dayOfWeekFormated(widget.travel.date);
  }

  void _getTextDirections() async {
    arrivalPointTextDirection = await travelDatasourceImpl.getTextDirection(
        lat: widget.travel.arrivalPointLat,
        long: widget.travel.arrivalPointLong,
        context: context);
    startingPointTextDirection = await travelDatasourceImpl.getTextDirection(
        lat: widget.travel.startingPointLat,
        long: widget.travel.startingPointLong,
        context: context);
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

  Future<void> _loadTravelDetails() async {
    final listResponse = await travelDatasourceImpl.getTravelDetails(
        travelId: widget.travel.id,
        finalUrl: _endPoints.getTravelDetailsPassenger,
        context: context);
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

    int sendResponse = await travelDatasourceImpl.insertPassengerRemote(
        passenger: passenger, context: context);
    if (sendResponse == 1) {
      await EasyLoading.showInfo("Cupo solicitado");
      Navigator.of(context).pop();
    } else {
      await EasyLoading.showInfo("Error al reservar");
      return;
    }
  }

  Future<void> _getSuggestion(String value) async {
    var response = await travelDatasourceImpl.getMapSuggestions(
        address: value, context: context);
    _suggestions = response;
    setState(() {});
  }

  Future<void> _getMapCoordinates(String value, FocusNode foco) async {
    var response = await travelDatasourceImpl.getMapCoordinates(
        address: value, context: context);
    setState(() {
      latLngStartingPoint = response;
    });
  }

  void _openMapSelector(
      bool isStartingPoint, TextEditingController textController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorManager.staticColor,
        title: Text(
          'Seleccione la ubicación en el mapa',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
          maxLines: 3,
        ),
        content: MapSelectionScreen(
          onLocationSelected: (location) {
            latLngStartingPoint = location;
            LatLng latLongPoint = latLngStartingPoint;
            setState(() async {
              textController.text = await travelDatasourceImpl.getTextDirection(
                  lat: latLongPoint.latitude,
                  long: latLongPoint.longitude,
                  context: context);
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child:
                Text('Regresar', style: Theme.of(context).textTheme.titleSmall),
          ),
        ],
      ),
    );
  }

  void _getWidgetPosition(GlobalKey key, Function(Offset) callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      callback(position);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getWidgetPosition(_startingPointKey, (position) {
        setState(() {
          startingPointPosition = position;
        });
      });
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
                                              dayOfWeek,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              DateFormatter()
                                                  .timeFormatedTextController(
                                                      widget.travel.hour),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(fontSize: 25.0),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ]),
                                      Text(
                                        '   ${widget.travel.date}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(fontSize: 16.0),
                                      ),
                                      //const SizedBox(height: 15),
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
                                      const SizedBox(height: 10),
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
                                      // const SizedBox(height: 50),
                                      Stack(
                                        children: [
                                          Card(
                                              color: Colors.white,
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
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
                                                            style: Theme.of(
                                                                    context)
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
                                                                _seatsIncrement(
                                                                    1),
                                                          ),
                                                          Text(
                                                            '$_seats',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall,
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(Icons
                                                                .arrow_drop_down_outlined),
                                                            color: Colors.black,
                                                            iconSize: 40,
                                                            onPressed: () =>
                                                                _seatsIncrement(
                                                                    0),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      InputField(
                                                          key:
                                                              _startingPointKey,
                                                          foco:
                                                              _focusNodeStartingPoint,
                                                          controller:
                                                              startingPointController,
                                                          textInput:
                                                              "Punto de recogida",
                                                          textInputType:
                                                              TextInputType
                                                                  .text,
                                                          color: ColorManager
                                                              .staticColor,
                                                          icon: const Icon(Icons
                                                              .location_history),
                                                          onPressed: () {
                                                            _openMapSelector(
                                                                true,
                                                                startingPointController);
                                                            setState(() {
                                                              _focusNodeStartingPoint
                                                                  .unfocus();
                                                              _currentFoco =
                                                                  emptyFocus;
                                                            });
                                                          },
                                                          onChange: (value) {
                                                            _currentFoco =
                                                                _focusNodeStartingPoint;
                                                            _getSuggestion(
                                                                value);
                                                          },
                                                          obscure: false),
                                                      // if (_suggestions.isNotEmpty &&
                                                      //     _currentFoco ==
                                                      //         _focusNodeStartingPoint)
                                                      //   Positioned(
                                                      //     top: 50.0,
                                                      //     left: 0.0,
                                                      //     right: 0.0,
                                                      //     child: Container(
                                                      //       height: 100,
                                                      //       decoration:
                                                      //           BoxDecoration(
                                                      //         color: Colors.white,
                                                      //         boxShadow: [
                                                      //           BoxShadow(
                                                      //             color: Colors.grey
                                                      //                 .withOpacity(
                                                      //                     0.5),
                                                      //             spreadRadius: 1,
                                                      //             blurRadius: 3,
                                                      //             offset:
                                                      //                 const Offset(
                                                      //                     0, 2),
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      //       child: ListView.builder(
                                                      //         itemCount:
                                                      //             _suggestions
                                                      //                 .length,
                                                      //         itemBuilder:
                                                      //             (context, index) {
                                                      //           return ListTile(
                                                      //             title: Text(
                                                      //                 _suggestions[
                                                      //                     index]),
                                                      //             onTap: () {
                                                      //               startingPointController
                                                      //                       .text =
                                                      //                   _suggestions[
                                                      //                       index];
                                                      //               _getMapCoordinates(
                                                      //                   _suggestions[
                                                      //                       index],
                                                      //                   _focusNodeStartingPoint);
                                                      //               _suggestions
                                                      //                   .clear();
                                                      //             },
                                                      //           );
                                                      //         },
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      const SizedBox(
                                                          height: 30),
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
                                          if (_suggestions.isNotEmpty &&
                                              _currentFoco ==
                                                  _focusNodeStartingPoint)
                                            Positioned(
                                              top: startingPointPosition != null
                                                  ? startingPointPosition!.dy +
                                                      50
                                                  : 170.0,
                                              left: 0.0,
                                              right: 0.0,
                                              child: Container(
                                                height: 250.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: ListView.builder(
                                                  itemCount:
                                                      _suggestions.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                      title: Text(
                                                          _suggestions[index]),
                                                      onTap: () {
                                                        startingPointController
                                                                .text =
                                                            _suggestions[index];
                                                        _getMapCoordinates(
                                                            _suggestions[index],
                                                            _focusNodeStartingPoint);
                                                        _suggestions.clear();
                                                        setState(() {
                                                          _currentFoco
                                                              .unfocus();
                                                          _focusNodeStartingPoint
                                                              .unfocus();
                                                        });
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                    ]))))));
  }
}
