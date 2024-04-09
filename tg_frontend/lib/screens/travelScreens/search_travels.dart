import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  Stream<List<Travel>> _fetchTravelsStream() async* {
    final value = await travelDatasourceMethods.getTravelsRemote(
        finalEndPoint: endPoint.getGeneralTravels);
    yield value;
    // setState(() {

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 26),
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
        Visibility(
            visible: travelsList.isNotEmpty,
            child: DraggableScrollableSheet(
                initialChildSize: 0.55,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 58, 58),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                        ),
                      ),
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          ),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: StreamBuilder<List<Travel>>(
                                  stream: _fetchTravelsStream(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else {
                                      travelsList = snapshot.data ?? [];
                                      if (travelsList.isEmpty) {
                                        return const Center(
                                          child: Text(
                                              'No tiene viajes por el momento...'),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                             Text(
                                                  "Tu mejor opción",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                  textAlign: TextAlign.left,
                                                ),
                                            //TravelCard(travel: perfectTravel),
                                            TravelCard(travel: travelsList[0]),
                                            const SizedBox(height: 30),
                                            Text(
                                                  "Revisa otras opciones",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                  textAlign: TextAlign.left,
                                                ),
                                            ListView.builder(
                                                    itemCount:
                                                        travelsList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return TravelCard(
                                                          travel: travelsList[
                                                              index]);
                                                    })
                                          ],
                                        );
                                      }
                                    }
                                  }))));
                }))
      ]),
    ]));
  }
}
