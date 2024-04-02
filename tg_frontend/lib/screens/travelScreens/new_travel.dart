import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/widgets/square_button.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';

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

  final _formKey = GlobalKey<FormState>();

  final TextEditingController startingPointController = TextEditingController();
  final TextEditingController arrivalPointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateControlelr = TextEditingController();
  final TextEditingController seatsController = TextEditingController();

  void submitForm(BuildContext context) async {
    DateTime now = DateTime.now();

    String formattedTime = DateFormat('yyyy-MM-dd').format(now);
    dateControlelr.text = formattedTime;
    if (_formKey.currentState!.validate()) {
      //List<Travel> travelList = [];
      Travel travel = Travel(
          id: 100,
          arrivalPoint: arrivalPointController.text,
          startingPoint: startingPointController.text,
          driver: user.idUser,
          price: int.parse(priceController.text),
          seats: int.parse(seatsController.text),
          date: dateControlelr.text,
          hour: timeController.text,
          // date: DateFormat('yyyy-MM-dd').parse(dateControlelr.text),
          // hour: DateFormat('HH:mm').parse(dateControlelr.text),
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
                      icon: const Icon(Icons.edit),
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
                      icon: const Icon(Icons.edit),
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
                              text: '30 min',
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
                                  //dateControlelr.text = "$newTime";
                                });
                              }),
                          SquareButton(
                              text: '1 hora',
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
                            onPressed: () {},
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
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       //BotonPersonalizado('Botón 1'),
                    //       SquareButton(
                    //           text: '1',
                    //           onPressed: () {
                    //             seatsController.text = '1';
                    //           }),
                    //       SquareButton(
                    //           text: '2',
                    //           onPressed: () {
                    //             seatsController.text = '2';
                    //           }),
                    //       SquareButton(
                    //           text: '3',
                    //           onPressed: () {
                    //             seatsController.text = '3';
                    //           }),
                    //       SquareButton(
                    //           text: '', onPressed: () {}, myIcon: Icons.edit),
                    //     ]),
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
