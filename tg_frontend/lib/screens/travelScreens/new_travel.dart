import 'package:flutter/material.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/widgets/square_button.dart';
import 'package:tg_frontend/widgets/input_field.dart';

class NewTravel extends StatefulWidget {
  const NewTravel({super.key});

  @override
  State<NewTravel> createState() => _NewTravelState();
}

class _NewTravelState extends State<NewTravel> {
  final TextEditingController startingPointController = TextEditingController();
  final TextEditingController arrivalPointController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 26),
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
              textAlign: TextAlign.left,
            )),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          //BotonPersonalizado('Botón 1'),
          SquareButton(text: '10', onPressed: () {}),
          SquareButton(text: '30 min', onPressed: () {}),
          SquareButton(text: '1 hora', onPressed: () {}),
          SquareButton(
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          //BotonPersonalizado('Botón 1'),
          SquareButton(text: '1', onPressed: () {}),
          SquareButton(text: '2', onPressed: () {}),
          SquareButton(text: '3', onPressed: () {}),
          SquareButton(text: '', onPressed: () {}, myIcon: Icons.edit),
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
        const SizedBox(height: 10),
        LargeButton(text: 'crear', large: false, onPressed: () {})
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
    ));
  }
}
