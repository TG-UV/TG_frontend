import 'package:flutter/material.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';



class DetailsCard extends StatefulWidget {
  const DetailsCard({
    super.key,
    required this.travel,
  });

  final Travel travel;

  @override
  State<DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();
  var _seats = 1;
  late Map<String, dynamic>? detailsList;
  

  void seatsIncrement() {
    setState(() {
      _seats++;
    });
  }

  Stream<Map<String, dynamic>?> _loadTravelDetails() async* {
    Map<String, dynamic>? value;
      final listResponse =
        await travelDatasourceImpl.getTravelDetails(travelId: widget.travel.id);
        if(listResponse != null ){
            value = listResponse.data;
        }
        yield value;
  }

  void _reserveSpot() async {
    Passenger passenger = Passenger(
        idPassenger: user.idUser,
        pickupPoint: "no se aún",
        seats: _seats,
        isConfirmed: 0,
        trip: widget.travel.id,
        passenger: user.idUser,
        phoneNumber: user.phoneNumber,
        firstName: user.firstName,
        lastName: user.lastName);

    int sendResponse = await travelDatasourceImpl.insertPassengerRemote(
        passenger: passenger);
    if (sendResponse == 1) {
        await EasyLoading.showInfo("Cupo solicitado");
          Navigator.of(context).pop();
    }else{
      await EasyLoading.showInfo("Error al reservar");
      return;
    }

  }

  void _cancelSpot(int passengerId) async {
    int sendResponse = await travelDatasourceImpl.deletePassengerRemote(
        passengerId: passengerId);
    if (sendResponse == 1) {}
  }

  @override
  Widget build(BuildContext context) {
    Card generalTravelInformation = Card(
      color: Colors.grey.shade200,
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: StreamBuilder<Map<String, dynamic>?>(
                          stream: _loadTravelDetails(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              detailsList = snapshot.data;
                              if (detailsList!.isEmpty) {
                                return const Center(
                                  child:
                                      Text('No tiene viajes por el momento...'),
                                );
                              } else {
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '\$ ${widget.travel.price}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(width: 10),
                  Text(
                    detailsList!["vehicle"]["vehicle_type"],
                    //"Motocicleta",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 25.0),
                    overflow: TextOverflow.ellipsis,
                  ),

                  //const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                  margin: const EdgeInsets.only(left: 40.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Partida:  ${widget.travel.startingPoint}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Destino:   ${widget.travel.arrivalPoint}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 25),
                        Text(
                           '${detailsList!["driver"]["first_name"]}  ${detailsList!["driver"]["last_name"]}' ,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                        Text(
                          '${widget.travel.seats} cupos disponibles ',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                        
                      ])),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    width: 13,
                  ),
                  Text(
                    'cupos: $_seats',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextButton.icon(
                      label: const Text(''),
                      onPressed: seatsIncrement,
                      icon: const Icon(
                        Icons.plus_one_rounded,
                        color: Colors.black,
                      )),

                  const SizedBox(height: 10),
                  LargeButton(
                    large: false,
                    text: "reservar",
                    onPressed: () {
                      _reserveSpot();
                    },
                  ),
                  //const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 15),
            ],
          );}}}),
    ));

    Card bookedTravelInformation = Card(
      color: Colors.grey.shade200,
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '\$ ${widget.travel.price}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(width: 10),
                  Text(
                    "Motocicleta",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 25.0),
                    overflow: TextOverflow.ellipsis,
                  ),

                  //const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                  margin: const EdgeInsets.only(left: 40.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Juan Sebastian Estupiñan ",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                        Text(
                          '3145872849',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'AVH 234',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'chevrolet onix rojo',
                          style: Theme.of(context).textTheme.titleSmall,
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
                      ])),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    width: 13,
                  ),
                  Text(
                    'cupos: $_seats',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  const SizedBox(height: 10),
                  LargeButton(
                    large: false,
                    text: "cancelar",
                    onPressed: () {
                      _cancelSpot(user.idUser);
                    },
                  ),
                  //const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 15),
            ],
          )),
    );
    return Center(child: generalTravelInformation);
  }
}
