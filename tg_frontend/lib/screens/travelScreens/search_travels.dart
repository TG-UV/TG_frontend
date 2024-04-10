import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  final TextEditingController startingPointController = TextEditingController();
  final TextEditingController arrivalPointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<Travel> travelsList = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
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
                  controller: startingPointController,
                  textInput: 'Universidad del Valle',
                  textInputType: TextInputType.text,
                  obscure: false,
                  icon: const Icon(Icons.edit),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 40),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Cuando",
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.left,
                    )),
                // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                //   //BotonPersonalizado('Botón 1'),
                //   SquareButton(text: '10 min', onPressed: () {}),
                //   SquareButton(text: '30 min', onPressed: () {}),
                //   SquareButton(text: '1 hora', onPressed: () {}),
                //   SquareButton(
                //     myIcon: Icons.edit,
                //     text: '',
                //     onPressed: () {},
                //   ),
                // ]),
                const SizedBox(height: 20),
                LargeButton(
                    text: "buscar", large: false, onPressed: _fetchTravels),
              ],
            ),
          ),
          
          // Expanded(
          //  child:
        ]),
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
                              borderRadius: BorderRadius.circular(15)),
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
                                        travel: travelsList[index]);
                                  })));
                })
            : Center(
              
                child: Text(
                "",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    
              ))
      ],
    ));
  }
}
