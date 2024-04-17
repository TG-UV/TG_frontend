import 'package:flutter/material.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/widgets/square_button.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/travel_card.dart';
import 'package:http/http.dart' as http;
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:latlong2/latlong.dart';

class SearchTravels extends StatefulWidget {
  const SearchTravels({super.key});

  @override
  State<SearchTravels> createState() => _SearchTravelsState();
}

class _SearchTravelsState extends State<SearchTravels> {
  User user = Environment.sl.get<User>();
  TravelDatasourceMethods travelDatasourceMethods =
      Environment.sl.get<TravelDatasourceMethods>();
  EndPoints endPoint = EndPoints();

  int _selectedTimeButtonIndex = -1;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController startingPointController = TextEditingController();
  final TextEditingController arrivalPointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Travel> travelsList = [];

  List<String> _suggestions = [];
  late LatLng latLngArrivalPoint;
  late LatLng latLngStartingPoint;

  final FocusNode _focusNodeArrivalPoint = FocusNode();
  final FocusNode _focusNodeStartingPoint = FocusNode();
  late FocusNode _currentFoco;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchTravels() async {
    List<Travel> value = await travelDatasourceMethods.getTravelsRemote(
        finalEndPoint: endPoint.getGeneralTravels);
    if (value.isNotEmpty) {
      setState(() {
        travelsList = value;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(2025));
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        dateController.text = _selectedDate.toString().substring(0, 10);
      });
    }
    _selectTime();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
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
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 16),
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
                          LargeButton(
                              text: "buscar",
                              large: false,
                              onPressed: _fetchTravels),
                        ],
                      ),
                    ),
                    travelsList.isNotEmpty
                        ? DraggableScrollableSheet(
                            initialChildSize: 0.35,
                            minChildSize: 0.25,
                            maxChildSize: 0.75,
                            builder: (context, scrollController) {
                              return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child:
                                          //  Flex(direction: Axis.vertical, children: [
                                          //     Text(
                                          //       "Tu mejor opción",
                                          //       style: Theme.of(context)
                                          //           .textTheme
                                          //           .titleSmall,
                                          //       textAlign: TextAlign.left,
                                          //     ),
                                          //     //TravelCard(travel: perfectTravel),
                                          //     TravelCard(travel: travelsList[0]),
                                          //     const SizedBox(height: 30),
                                          //     Text(
                                          //       "Revisa otras opciones",
                                          //       style: Theme.of(context)
                                          //           .textTheme
                                          //           .titleSmall,
                                          //       textAlign: TextAlign.left,
                                          //     ),
                                          ListView.builder(
                                              controller: scrollController,
                                              itemCount: travelsList.length,
                                              itemBuilder: (context, index) {
                                                return TravelCard(
                                                  travel: travelsList[index],
                                                  pastTravel: false,
                                                );
                                              })));
                            })
                        : Center(
                            child: Text("",
                                style: Theme.of(context).textTheme.titleMedium))
                  ],
                ))));
  }
}
