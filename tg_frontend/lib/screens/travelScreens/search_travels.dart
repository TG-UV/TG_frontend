import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/errors.dart/exceptions.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/utils/date_Formatter.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:tg_frontend/widgets/map_location_selector.dart';
import 'package:tg_frontend/widgets/square_button.dart';
import 'package:tg_frontend/widgets/travel_card.dart';

class SearchTravels extends StatefulWidget {
  const SearchTravels(
      {super.key, required this.startingPoint, required this.arrivalPoint});
  final LatLng startingPoint;
  final LatLng arrivalPoint;

  @override
  State<SearchTravels> createState() => _SearchTravelsState();
}

class _SearchTravelsState extends State<SearchTravels> {
  User user = Environment.sl.get<User>();
  TravelDatasourceMethods travelDatasourceMethods =
      Environment.sl.get<TravelDatasourceMethods>();
  EndPoints endPoint = EndPoints();

  int _selectedTimeButtonIndex = -1;
  String _selectedDate = DateTime.now().toString();
  String _selectedTime = TimeOfDay.now().toString();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController startingPointController = TextEditingController();
  final TextEditingController arrivalPointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Travel> travelsList = [];
  bool searchDone = false;

  List<String> _suggestions = [];
  late LatLng latLngArrivalPoint;
  late LatLng latLngStartingPoint;

  final FocusNode _focusNodeArrivalPoint = FocusNode();
  final FocusNode _focusNodeStartingPoint = FocusNode();
  late FocusNode _currentFoco = FocusNode();
  late FocusNode emptyFocus = FocusNode();

  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    _fetchDirections();
    super.initState();
  }

  void _fetchDirections() async {
    latLngArrivalPoint = widget.arrivalPoint;
    latLngStartingPoint = widget.startingPoint;
    startingPointController.text =
        await travelDatasourceMethods.getTextDirection(
            lat: latLngStartingPoint.latitude,
            long: latLngStartingPoint.longitude,
            context: context);

    arrivalPointController.text =
        await travelDatasourceMethods.getTextDirection(
            lat: latLngArrivalPoint.latitude,
            long: latLngArrivalPoint.longitude,
            context: context);
    setState(() {});
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate() &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty) {
      Map<String, dynamic> requestData = {
        // 'starting_point_lat':
        //     double.parse(latLngStartingPoint.latitude.toStringAsFixed(6)),
        // "starting_point_long":
        //     double.parse(latLngStartingPoint.longitude.toStringAsFixed(6)),
        // "arrival_point_lat":
        //     double.parse(latLngArrivalPoint.latitude.toStringAsFixed(6)),
        // "arrival_point_long":
        //     double.parse(latLngArrivalPoint.longitude.toStringAsFixed(6)),
        "starting_point_lat": "3.376582",
        "starting_point_long": "-76.533462",
        "arrival_point_lat": "3.399394",
        "arrival_point_long": "-76.543935",
        'start_time': _selectedTime,
        'start_date': _selectedDate,
      };

      // Map<String, dynamic> requestData = {
      //   "starting_point_lat": "3.370051",
      //   "starting_point_long": "-76.53266",
      //   "arrival_point_lat": "3.391652",
      //   "arrival_point_long": "-76.551000",
      //   "seats": "1",
      //   "start_time": "5:25:00",
      //   "start_date": "2024-04-29"
      // };

      _fetchTravels(requestData);
      //print("form correcto.........$data");
    } else {
      return ErrorOrAdviceHandler.showErrorAlert(
          context, "Campos incompletos o error en alguno de ellos", true);
    }
  }

  Future<void> _fetchTravels(Map<String, dynamic> requestData) async {
    List<Travel> travelsResponse = await travelDatasourceMethods
        .getTravelSuggestions(searchData: requestData, context: context);

    setState(() {
      searchDone = true;
      travelsList = travelsResponse;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(2025));
    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormatter().dateFormatedToSend(pickedDate);
        dateController.text =
            DateFormatter().dateFormatedTextController(pickedDate);
      });
      _selectTime();
    }
  }

  Future<void> _selectTime({DateTime? dateTime}) async {
    if (dateTime != null) {
      setState(() {
        _selectedTime = DateFormatter().timeFormatedToSend(dateTime);
        _selectedDate = DateFormatter().dateFormatedToSend(DateTime.now());
        timeController.text =
            DateFormatter().timeFormatedTextController(_selectedTime);
        dateController.text =
            DateFormatter().dateFormatedTextController(DateTime.now());
      });
    } else {
      final TimeOfDay? pickedTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());

      if (pickedTime != null) {
        DateTime today = DateTime.now();
        final day = DateTime(
          today.year,
          today.month,
          today.day,
          pickedTime.hour,
          pickedTime.minute,
          00,
        );
        setState(() {
          _selectedTime = DateFormatter().timeFormatedToSend(day);
          timeController.text =
              DateFormatter().timeFormatedTextController(_selectedTime);
        });
      }
    }
  }

  Future<void> _getSuggestion(String travelsResponse) async {
    var response = await travelDatasourceMethods.getMapSuggestions(
        address: travelsResponse, context: context);
    setState(() {
      _suggestions = response;
    });
  }

  Future<void> _getMapCoordinates(
      String travelsResponse, LatLng latLngPoint) async {
    var response = await travelDatasourceMethods.getMapCoordinates(
        address: travelsResponse, context: context);
    setState(() {
      latLngPoint = response;
      // foco == _focusNodeArrivalPoint
      //     ? latLngArrivalPoint = response
      //     : latLngStartingPoint = response;
    });
  }

  String _getStringSuggestionFormated(String suggestion) {
    if (suggestion.length > 30) {
      return "${suggestion.substring(0, 30)}...";
    } else {
      return suggestion;
    }
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
            isStartingPoint
                ? latLngStartingPoint = location
                : latLngArrivalPoint = location;
            LatLng latLongPoint =
                isStartingPoint ? latLngStartingPoint : latLngArrivalPoint;
            setState(() async {
              textController.text =
                  await travelDatasourceMethods.getTextDirection(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 16),
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back)),
                        const SizedBox(width: 10),
                        Text(
                          "Busca un viaje",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 26),
                        )
                      ]),
                      const SizedBox(height: 30),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Desde",
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.left,
                          )),
                      InputField(
                        foco: _focusNodeStartingPoint,
                        controller: startingPointController,
                        textInput: startingPointController.text,
                        textInputType: TextInputType.text,
                        obscure: false,
                        onChange: (travelsResponse) {
                          _currentFoco = _focusNodeStartingPoint;
                          _getSuggestion(travelsResponse);
                        },
                        icon: const Icon(Icons.add_location_alt_outlined),
                        onPressed: () {
                          _openMapSelector(true, startingPointController);
                          setState(() {
                            _focusNodeStartingPoint.unfocus();
                            _currentFoco = emptyFocus;
                          });
                        },
                      ),
                      if (_suggestions.isNotEmpty &&
                          _currentFoco == _focusNodeStartingPoint)
                        Positioned(
                          top: 50.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              itemCount: _suggestions.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(_suggestions[index]),
                                  onTap: () {
                                    startingPointController.text =
                                        _suggestions[index];
                                    _getMapCoordinates(_suggestions[index],
                                        latLngStartingPoint);
                                    _suggestions.clear();
                                    // _focusNodeStartingPoint.unfocus();
                                    setState(() {
                                      _currentFoco = emptyFocus;
                                      _focusNodeStartingPoint.unfocus();
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 7),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Hacia",
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.left,
                          )),
                      InputField(
                        foco: _focusNodeStartingPoint,
                        controller: arrivalPointController,
                        textInput: arrivalPointController.text,
                        textInputType: TextInputType.text,
                        obscure: false,
                        onChange: (travelsResponse) {
                          _currentFoco = _focusNodeArrivalPoint;
                          _getSuggestion(travelsResponse);
                        },
                        icon: const Icon(Icons.add_location_alt_outlined),
                        onPressed: () {
                          _openMapSelector(false, arrivalPointController);
                          setState(() {
                            //  _currentFoco.unfocus();
                            _focusNodeArrivalPoint.unfocus();
                            _currentFoco = emptyFocus;
                          });
                        },
                      ),
                      if (_suggestions.isNotEmpty &&
                          _currentFoco == _focusNodeArrivalPoint)
                        Positioned(
                          top: 100.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              itemCount: _suggestions.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(_getStringSuggestionFormated(
                                          _suggestions[index])),
                                      onTap: () {
                                        arrivalPointController.text =
                                            _suggestions[index];
                                        _getMapCoordinates(_suggestions[index],
                                            latLngArrivalPoint);
                                        _suggestions.clear();
                                        setState(() {
                                          _currentFoco = emptyFocus;
                                          _focusNodeArrivalPoint.unfocus();
                                        });
                                      },
                                    ),
                                    const Divider(
                                      height:
                                          0.5, // Ajusta el espaciado vertical entre las líneas
                                      color: Colors.grey, // Color de la línea
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 40),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Cuándo",
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.left,
                          )),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //BotonPersonalizado('Botón 1'),
                            SquareButton(
                                text: '10',
                                isSelected: _selectedTimeButtonIndex == 0,
                                onPressed: () {
                                  setState(() {
                                    timeController.text = '0';
                                    _selectedTimeButtonIndex = 0;
                                  });
                                }),
                            SquareButton(
                                text: '30',
                                isSelected: _selectedTimeButtonIndex == 1,
                                onPressed: () {
                                  setState(() {
                                    timeController.text = '1';
                                    _selectedTimeButtonIndex = 1;
                                  });
                                }),
                            SquareButton(
                                text: '60',
                                isSelected: _selectedTimeButtonIndex == 2,
                                onPressed: () {
                                  setState(() {
                                    timeController.text = '2';
                                    _selectedTimeButtonIndex = 2;
                                  });
                                }),
                            SquareButton(
                              isSelected: _selectedTimeButtonIndex == 3,
                              myIcon: Icons.edit,
                              text: '',
                              onPressed: () => _selectDate(context),
                            ),
                          ]),
                      const SizedBox(height: 20),
                      MainButton(
                          text: "buscar",
                          large: false,
                          buttonColor: ColorManager.fourthColor,
                          onPressed: () => _submitForm(context)),
                      const SizedBox(height: 70),
                      if (travelsList.isEmpty && searchDone)
                        Container(
                          decoration: BoxDecoration(
                              color: ColorManager.thirdColor,
                              border: Border.all(color: Colors.red),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Lastimosamente no encontramos viajes para esta solicitud, intentalo más tarde o intenta modificar el horario",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12),
                            maxLines: 3,
                          ),
                        )
                    ],
                  ),
                )),
            if (travelsList.isNotEmpty)
              DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.2,
                  maxChildSize: 0.75,
                  snapSizes: [0.2, 0.75],
                  snap: true,
                  builder: (BuildContext context, scrollSheetController) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorManager.primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Aquí puedes agregar tu encabezado
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    color: ColorManager.staticColor,
                                  ),
                                )),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const ClampingScrollPhysics(),
                                controller: scrollSheetController,
                                itemCount: travelsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TravelCard(
                                    travel: travelsList[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
          ],
        ));
  }
}
