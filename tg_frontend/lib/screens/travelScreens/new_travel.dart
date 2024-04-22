import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:tg_frontend/widgets/square_button.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NewTravel extends StatefulWidget {
  const NewTravel({super.key});

  @override
  State<NewTravel> createState() => _NewTravelState();
}

class _NewTravelState extends State<NewTravel> {
  User user = Environment.sl.get<User>();
  TravelDatasourceMethods travelDatasourceMethods =
      Environment.sl.get<TravelDatasourceMethods>();
  int _selectedTimeButtonIndex = -1;
  int _selectedSeatsButtonIndex = -1;
  String _selectedDate = DateTime.now().toString();
  String _selectedTime = TimeOfDay.now().toString();
  List<String> _suggestions = [];
  String inputAddress = "Universidad del valle";
  late LatLng latLngArrivalPoint;
  late LatLng latLngStartingPoint;

  final _formKey = GlobalKey<FormState>();

  final FocusNode _focusNodeArrivalPoint = FocusNode();
  final FocusNode _focusNodeStartingPoint = FocusNode();
  late FocusNode _currentFoco;

  final TextEditingController startingPointController = TextEditingController();
  final TextEditingController arrivalPointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();

  void submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate() &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        seatsController.text.isNotEmpty) {
      Travel travel = Travel(
          id: 100,
          arrivalPointLat: latLngArrivalPoint.latitude,
          arrivalPointLong: latLngArrivalPoint.longitude,
          startingPointLat: latLngStartingPoint.latitude,
          startingPointLong: latLngStartingPoint.longitude,
          driver: user.idUser,
          price: int.parse(priceController.text),
          seats: int.parse(seatsController.text),
          date: _selectedDate,
          hour: _selectedTime,
          currentTrip: 0);

      int sentResponse =
          await travelDatasourceMethods.insertTravelRemote(travel: travel);
      if (sentResponse != 0) {
        await EasyLoading.showInfo("Viaje registrado");
        Get.to(() => const Home());
      } else {
        await EasyLoading.showInfo("Error, intentalo más tarde");
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Error"),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("Faltan campos por llenar."),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Aceptar"))
                ]);
          });
    }
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(2025));
    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        dateController.text =
            DateFormat('EEEE, d MMMM', 'es_ES').format(pickedDate);
      });
      _selectTime();
    }
  }

  Future<void> _selectTime({DateTime? dateTime}) async {
    if (dateTime != null) {
      setState(() {
        _selectedTime = DateFormat('hh:mm:ss').format(dateTime);
        _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        timeController.text =
            DateFormat('hh:mm a').format(_parseTimeString(_selectedTime));
        dateController.text =
            DateFormat('EEEE, d MMMM', 'es_ES').format(DateTime.now());
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
          _selectedTime = DateFormat('hh:mm:ss').format(day);
          timeController.text =
              DateFormat('hh:mm a').format(_parseTimeString(_selectedTime));
        });
      }
    }
  }

  Future<void> _getSuggestion(String value) async {
    var response =
        await travelDatasourceMethods.getMapSuggestions(address: value);
    setState(() {
      _suggestions = response;
    });
  }

  Future<void> _getMapCoordinates(String value, FocusNode foco) async {
    var response =
        await travelDatasourceMethods.getMapCoordinates(address: value);
    setState(() {
      foco == _focusNodeArrivalPoint
          ? latLngArrivalPoint = response
          : latLngStartingPoint = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  alignment: Alignment.center,
                  child: Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 16),
                    Row(children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const SizedBox(width: 5),
                      Text(
                        "Crea un nuevo viaje",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 26),
                      )
                    ]),
                    const SizedBox(height: 60),
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
                      textInput: 'Universidad del Valle',
                      textInputType: TextInputType.text,
                      obscure: false,
                      onChange: (value) {
                        _currentFoco = _focusNodeStartingPoint;
                        _getSuggestion(value);
                      },
                      icon: const Icon(Icons.edit),
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
                                      _focusNodeStartingPoint);
                                  _suggestions.clear();
                                  _focusNodeStartingPoint.unfocus();
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
                      textInput: 'Home',
                      textInputType: TextInputType.text,
                      obscure: false,
                      onChange: (value) {
                        _currentFoco = _focusNodeArrivalPoint;
                        _getSuggestion(value);
                      },
                      icon: const Icon(Icons.edit),
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
                              return ListTile(
                                title: Text(_suggestions[index]),
                                onTap: () {
                                  arrivalPointController.text =
                                      _suggestions[index];
                                  _getMapCoordinates(_suggestions[index],
                                      _focusNodeArrivalPoint);
                                  _suggestions.clear();
                                  _focusNodeArrivalPoint.unfocus();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Text(
                            'Cuándo',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                timeController.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                dateController.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SquareButton(
                              text: '10',
                              isSelected: _selectedTimeButtonIndex == 0,
                              onPressed: () {
                                setState(() {
                                  _selectedTimeButtonIndex = 0;
                                  DateTime now = DateTime.now();
                                  DateTime newTime =
                                      now.add(const Duration(minutes: 10));
                                  _selectTime(dateTime: newTime);
                                });
                              }),
                          SquareButton(
                              text: '30',
                              isSelected: _selectedTimeButtonIndex == 1,
                              onPressed: () {
                                setState(() {
                                  _selectedTimeButtonIndex = 1;
                                  DateTime now = DateTime.now();
                                  DateTime newTime =
                                      now.add(const Duration(minutes: 30));
                                  _selectTime(dateTime: newTime);
                                  //dateController.text = "$newTime";
                                });
                              }),
                          SquareButton(
                              text: '60',
                              isSelected: _selectedTimeButtonIndex == 2,
                              onPressed: () {
                                setState(() {
                                  _selectedTimeButtonIndex = 2;
                                  DateTime now = DateTime.now();
                                  DateTime newTime =
                                      now.add(const Duration(minutes: 60));
                                  _selectTime(dateTime: newTime);
                                });
                              }),
                          SquareButton(
                            isSelected: _selectedTimeButtonIndex == 3,
                            myIcon: Icons.edit,
                            text: '',
                            onPressed: () => _selectDate(context),
                          ),
                        ]),
                    const SizedBox(height: 15),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Cupos",
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.left,
                        )),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SquareButton(
                              text: '1',
                              isSelected: _selectedSeatsButtonIndex == 0,
                              onPressed: () {
                                setState(() {
                                  seatsController.text = '1';
                                  _selectedSeatsButtonIndex = 0;
                                });
                              }),
                          SquareButton(
                              text: '2',
                              isSelected: _selectedSeatsButtonIndex == 1,
                              onPressed: () {
                                setState(() {
                                  seatsController.text = '2';
                                  _selectedSeatsButtonIndex = 1;
                                });
                              }),
                          SquareButton(
                              text: '3',
                              isSelected: _selectedSeatsButtonIndex == 2,
                              onPressed: () {
                                setState(() {
                                  seatsController.text = '3';
                                  _selectedSeatsButtonIndex = 2;
                                });
                              }),
                          SquareButton(
                            text: '4',
                            isSelected: _selectedSeatsButtonIndex == 3,
                            onPressed: () {
                              setState(() {
                                seatsController.text = '4';
                                _selectedSeatsButtonIndex = 3;
                              });
                            },
                            //myIcon: Icons.edit
                          )
                        ]),
                    const SizedBox(height: 40),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Precio",
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.left,
                        )),
                    InputField(
                      controller: priceController,
                      textInput: '2000',
                      textInputType: TextInputType.text,
                      obscure: false,
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(height: 30),
                    MainButton(
                        text: 'crear',
                        large: false,
                        buttonColor: ColorManager.fourthColor,
                        onPressed: () {
                          submitForm(context);
                        }),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
                  ]),
                ))));
  }
}
