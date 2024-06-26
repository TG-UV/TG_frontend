import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/errors.dart/exceptions.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/utils/date_Formatter.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:tg_frontend/widgets/map_location_selector.dart';
import 'package:tg_frontend/widgets/square_button.dart';

class NewTravel extends StatefulWidget {
  const NewTravel(
      {super.key, required this.startingPoint, required this.arrivalPoint});
  final LatLng startingPoint;
  final LatLng arrivalPoint;

  @override
  State<NewTravel> createState() => _NewTravelState();
}

class _NewTravelState extends State<NewTravel> {
  User user = Environment.sl.get<User>();
  TravelDatasourceMethods travelDatasourceMethods =
      Environment.sl.get<TravelDatasourceMethods>();
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  int _selectedTimeButtonIndex = -1;
  int _selectedSeatsButtonIndex = -1;
  String _selectedDate = DateTime.now().toString();
  String _selectedTime = TimeOfDay.now().toString();
  List<String> _suggestions = [];
  late LatLng latLngArrivalPoint;
  late LatLng latLngStartingPoint;
  List<Vehicle> driverVehicles = [];
  late Vehicle vehicleSelected;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey _startingPointKey = GlobalKey();
  final GlobalKey _arrivalPointKey = GlobalKey();
  Offset? startingPointPosition;
  Offset? arrivalPointPosition;

  final FocusNode _focusNodeArrivalPoint = FocusNode();
  final FocusNode _focusNodeStartingPoint = FocusNode();
  late FocusNode _currentFoco = FocusNode();
  late FocusNode emptyFocus = FocusNode();

  final TextEditingController startingPointController = TextEditingController();
  final TextEditingController arrivalPointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();

  @override
  void initState() {
    _fetchDirections();
    _fetchVehicles();
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

  void _fetchVehicles() async {
    final List<Vehicle>? listResponse =
        await userDatasourceImpl.getVehiclesDriver(context);
    if (listResponse != null) {
      setState(() {
        driverVehicles = listResponse;
        vehicleSelected = driverVehicles.first;
      });
    } else {
      throw Exception('Error al llamar los vehículos, intente de nuevo');
    }
  }

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
        currentTrip: 0,
        vehicle: vehicleSelected.idVehicle,
      );

      int sentResponse = await travelDatasourceMethods.insertTravelRemote(
          travel: travel, context: context);
      if (sentResponse != 0) {
        await EasyLoading.showInfo("Viaje registrado");
        Get.to(() => const Home());
      } else {
        await EasyLoading.showInfo("Error, intentalo más tarde");
      }
    } else {
      return ErrorOrAdviceHandler.showErrorAlert(
          context, "Error en alguno de los campos", true);
    }
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

  Future<void> _getSuggestion(String value) async {
    var response = await travelDatasourceMethods.getMapSuggestions(
        address: value, context: context);
    setState(() {
      _suggestions = response;
    });
  }

  Future<void> _getMapCoordinates(String value, LatLng point) async {
    LatLng response = await travelDatasourceMethods.getMapCoordinates(
        address: value, context: context);
    setState(() {
      point = response;
    });
  }

  InputDecoration myInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.secondaryColor, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          )),
      filled: true,
      fillColor: ColorManager.thirdColor,
    );
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

      _getWidgetPosition(_arrivalPointKey, (position) {
        setState(() {
          arrivalPointPosition = position;
        });
      });
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
            child: Stack(
              children: [
                Column(children: [
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
                          .copyWith(fontSize: 23),
                    )
                  ]),
                  const SizedBox(height: 20),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Desde",
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.left,
                      )),
                  InputField(
                    key: _startingPointKey,
                    foco: _focusNodeStartingPoint,
                    controller: startingPointController,
                    textInput: startingPointController.text,
                    textInputType: TextInputType.text,
                    obscure: false,
                    onChange: (value) {
                      _currentFoco = _focusNodeStartingPoint;
                      _getSuggestion(value);
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
                  const SizedBox(height: 7),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Hacia",
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.left,
                      )),
                  InputField(
                    key: _arrivalPointKey,
                    foco: _focusNodeArrivalPoint,
                    controller: arrivalPointController,
                    textInput: arrivalPointController.text,
                    textInputType: TextInputType.text,
                    obscure: false,
                    onChange: (value) {
                      _currentFoco = _focusNodeArrivalPoint;
                      _getSuggestion(value);
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
                    textInputType: TextInputType.number,
                    obscure: false,
                    icon: const Icon(Icons.edit),
                  ),
                  const SizedBox(height: 30),
                  driverVehicles.isNotEmpty
                      ? SizedBox(
                          height: 70,
                          child: DropdownButtonFormField<Vehicle>(
                            value: vehicleSelected,
                            onChanged: (Vehicle? newValue) {
                              setState(() {
                                vehicleSelected = newValue!;
                              });
                            },
                            items: driverVehicles.map((Vehicle vehiculo) {
                              return DropdownMenuItem<Vehicle>(
                                value: vehiculo,
                                child: Text(
                                    '${vehiculo.licensePlate} ${vehiculo.vehicleBrand}',
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                              );
                            }).toList(),
                            decoration: myInputDecoration(" Vehículo"),
                          ))
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 20,
                  ),
                  MainButton(
                      text: 'crear',
                      large: false,
                      buttonColor: ColorManager.fourthColor,
                      onPressed: () {
                        submitForm(context);
                      }),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
                ]),
                if (_suggestions.isNotEmpty &&
                    _currentFoco == _focusNodeStartingPoint)
                  Positioned(
                    top: startingPointPosition != null
                        ? startingPointPosition!.dy + 50
                        : 150.0,
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
                              _getMapCoordinates(
                                  _suggestions[index], latLngStartingPoint);
                              _suggestions.clear();
                              setState(() {
                                _currentFoco.unfocus();
                                _focusNodeStartingPoint.unfocus();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                if (_suggestions.isNotEmpty &&
                    _currentFoco == _focusNodeArrivalPoint)
                  Positioned(
                    top: arrivalPointPosition != null
                        ? arrivalPointPosition!.dy + 60
                        : 180.0,
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
                              arrivalPointController.text = _suggestions[index];
                              _getMapCoordinates(
                                  _suggestions[index], latLngArrivalPoint);
                              _suggestions.clear();
                              setState(() {
                                _currentFoco.unfocus();
                                _focusNodeArrivalPoint.unfocus();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
