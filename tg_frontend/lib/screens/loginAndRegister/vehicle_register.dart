import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/models/vehicleOptions_model.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/loginAndRegister/password_register.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';



class VehicleRegister extends StatefulWidget {
  const VehicleRegister({super.key, required this.user});
  final User user;

  @override
  State<VehicleRegister> createState() => _VehicleRegisterState();
}

class _VehicleRegisterState extends State<VehicleRegister> {
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  final _formKey = GlobalKey<FormState>();

  late Future<Map<String, dynamic>> options;
  final TextEditingController plateController = TextEditingController();
  final ValueNotifier<int?> typeController = ValueNotifier<int?>(null);
  final ValueNotifier<int?> brandController = ValueNotifier<int?>(null);
  final ValueNotifier<int?> modelController = ValueNotifier<int?>(null);
  final ValueNotifier<int?> colorController = ValueNotifier<int?>(null);

  late Vehicle vehicle;
 
  @override
  void initState() {
    super.initState();
    options = fetchOptions();
  }

  Future<Map<String, dynamic>> fetchOptions() async {
    final listResponse = await userDatasourceImpl.getVehicleOptionsRemote();
      
    listResponse != null
        ? options = listResponse;
        : showErrorMessage('El usuario no existe, intente de nuevo');


    final response = await http.get(Uri.parse('https://tu-api.com/data'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load options');
    }
  }

Future<List<VehicleOption>> fetchOptions(String endpoint) async {
    final response = await http.get(Uri.parse('https://tu-api.com/$endpoint'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)[endpoint];
      return data.map((item) => Option.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load options');
    }
  }
  void submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      //List<Travel> travelList = [];
      vehicle = Vehicle(
          idVehicle: 0,
          licensePlate: licensePlateController.text,
          vehicleBrand: 0,
          vehicleColor: 0,
          vehicleModel: 0,
          vehicleType: 0,
          owner: widget.user.idUser);
      //userDatasourceImpl.insertUserRemote(user: user);
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
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 150),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Añade los datos de tu Vehículo",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 35),
                  InputField(
                    controller: vehicleTypeController,
                    textInput: 'Tipo de vehículo',
                    textInputType: TextInputType.text,
                    obscure: false,
                    icon: const Icon(Icons.motorcycle),
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    controller: colorController,
                    textInput: 'Color',
                    textInputType: TextInputType.text,
                    obscure: false,
                    icon: const Icon(null),
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    controller: licensePlateController,
                    textInput: 'Placa',
                    textInputType: TextInputType.text,
                    obscure: false,
                    icon: const Icon(null),
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    controller: brandController,
                    textInput: 'Marca',
                    textInputType: TextInputType.text,
                    obscure: false,
                    icon: const Icon(null),
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    controller: modelController,
                    textInput: 'Modelo',
                    textInputType: TextInputType.text,
                    obscure: false,
                    icon: const Icon(null),
                  ),

                  const SizedBox(height: 80),
                  Container(
                      alignment: Alignment.center,
                      child: LargeButton(
                          text: 'Continuar',
                          large: true,
                          onPressed: () {
                            Get.to(() => PasswordRegister(user: widget.user));
                          })),

                  // child: const GlobalButton(text: 'Iniciar sesión'),
                ],
              ),
              Positioned(
                  top: 30.0,
                  left: 5.0,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)))
            ])));
  }
}
