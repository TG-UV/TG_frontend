import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/widgets/square_button.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:intl/intl.dart';

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
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController startingPointController = TextEditingController();
  final TextEditingController arrivalPointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();

  void submitForm(BuildContext context) async {
    // DateTime now = DateTime.now();
    //String formattedTime = DateFormat('yyyy-MM-dd').format(now);
    //dateController.text = formattedTime;
    if (_formKey.currentState!.validate()) {
      //List<Travel> travelList = [];
      Travel travel = Travel(
          id: 100,
          arrivalPoint: arrivalPointController.text,
          startingPoint: startingPointController.text,
          driver: user.idUser,
          price: int.parse(priceController.text),
          seats: int.parse(seatsController.text),
          date: dateController.text,
          hour: timeController.text,
          // date: DateFormat('yyyy-MM-dd').parse(dateController.text),
          // hour: DateFormat('HH:mm').parse(dateController.text),
          currentTrip: 0);
      //travelList.add(travel);

      travelDatasourceMethods.insertTravelRemote(travel: travel);
      Get.to(() => const Home());
    } else {
      AlertDialog(
          title: const Text("Error"),
          content: const SingleChildScrollView(
              child: ListBody(
            children: <Widget>[
              Text("Faltan campos por llenar."),
            ],
          )),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Aceptar"))
          ]);
    }
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
        timeController.text =DateFormat('hh:mm a')
                            .format(_parseTimeString(_selectedDate.toString()));
        _selectedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  alignment: Alignment.center,
                  child: Column(children: [
                    const SizedBox(height: 80),
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
                      controller: startingPointController,
                      textInput: 'Universidad del Valle',
                      textInputType: TextInputType.text,
                      obscure: false,
                      //icon: const Icon(Icons.edit),
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
                      controller: arrivalPointController,
                      textInput: 'Home',
                      textInputType: TextInputType.text,
                      obscure: false,
                      //icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(height: 50),

                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Cuando",
                          style: Theme.of(context).textTheme.titleSmall,
                          //textAlign: TextAlign.left,
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
                                  _selectedTimeButtonIndex = 0;
                                  DateTime now = DateTime.now();
                                  DateTime newTime =
                                      now.add(const Duration(minutes: 10));
                                  String formattedTime =
                                      DateFormat('HH:mm:ss').format(newTime);
                                  timeController.text = formattedTime;
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
                                  String formattedTime =
                                      DateFormat('HH:mm:ss').format(newTime);
                                  timeController.text = formattedTime;
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
                                  String formattedTime =
                                      DateFormat('HH:mm:ss').format(newTime);
                                  timeController.text = formattedTime;
                                });
                              }),
                          SquareButton(
                            isSelected: _selectedTimeButtonIndex == 3,
                            myIcon: Icons.edit,
                            text: '',
                            onPressed: () => _selectDate(context),
                          ),
                        ]),
                        Row(children: [
                          Text(
                      '  Fecha y hora: ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),Text(
                      '${_selectedDate.toString().substring(0, 10)},  ${timeController.text}',
                      //' ${DateFormat('HH:mm:ss').format(_selectedDate.toString().substring(0, 10))}',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                    ),
                        ],),
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
                                _selectedSeatsButtonIndex =0;
                                });
                              }),
                          SquareButton(
                              text: '2',
                              isSelected: _selectedSeatsButtonIndex == 1,
                              onPressed: () {
                                setState(() {
                                  seatsController.text = '2';
                                _selectedSeatsButtonIndex =1;
                                });
                              }),
                          SquareButton(
                              text: '3',
                              isSelected: _selectedSeatsButtonIndex == 2,
                              onPressed: () {
                                setState(() {
                                  seatsController.text = '3';
                                _selectedSeatsButtonIndex =2;
                                });
                              }),
                          SquareButton(
                              text: '4',
                              isSelected: _selectedSeatsButtonIndex == 3,
                               onPressed: () {
                                  setState(() {
                                    seatsController.text = '4';
                                _selectedSeatsButtonIndex =3;
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
                      textInput: '3.000',
                      textInputType: TextInputType.text,
                      obscure: false,
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(height: 30),
                    LargeButton(
                        text: 'crear',
                        large: false,
                        onPressed: () {
                          submitForm(context);
                        })
                  ]),
                  /*
              Positioned(
                  top: 30.0,
                  left: 5.0,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)))*/
                ))));
  }
}
