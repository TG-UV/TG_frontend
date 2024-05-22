import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/errors.dart/exceptions.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/screens/home.dart';
import 'package:tg_frontend/screens/loginAndRegister/password_register.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/main_button.dart';

class VehicleRegister extends StatefulWidget {
  const VehicleRegister({super.key, required this.user, required this.parent});
  final User user;
  final String parent;

  @override
  State<VehicleRegister> createState() => _VehicleRegisterState();
}

class _VehicleRegisterState extends State<VehicleRegister> {
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  final _formKey = GlobalKey<FormState>();

  int? _selectedType;
  int? _selectedBrand;
  int? _selectedModel;
  int? _selectedColor;

  late Map<String, dynamic> options;
  final TextEditingController licensePlateController = TextEditingController();
  final ValueNotifier<int?> typeController = ValueNotifier<int?>(null);
  final ValueNotifier<int?> brandController = ValueNotifier<int?>(null);
  final ValueNotifier<int?> modelController = ValueNotifier<int?>(null);
  final ValueNotifier<int?> colorController = ValueNotifier<int?>(null);

  late Vehicle vehicle;

  @override
  void initState() {
    super.initState();
    fetchOptions().then((value) {
      setState(() {
        options = value;
      });
    }).catchError((error) {
      //showErrorMessage(error.toString());
    });
  }

  Future<Map<String, dynamic>> fetchOptions() async {
    final Map<String, dynamic>? listResponse =
        await userDatasourceImpl.getVehicleOptionsRemote(context);

    if (listResponse != null) {
      return listResponse;
    } else {
      throw Exception(
          'Error al llamar la opciones de vehiculo, intente de nuevo');
    }
  }

  // InputDecoration(
  //                 enabledBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.blue, width: 2),
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 border: OutlineInputBorder(
  //                   borderSide: BorderSide(color: Colors.blue, width: 2),
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 filled: true,
  //                 fillColor: Color.fromARGB(255, 38, 159, 80),
  //               );
  InputDecoration myInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.secondaryColor, width: 2),
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

  void submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      //List<Travel> travelList = [];
      vehicle = Vehicle(
        idVehicle: 0,
        licensePlate: licensePlateController.text,
        vehicleBrand: _selectedBrand!.toString(),
        vehicleColor: _selectedColor!.toString(),
        vehicleModel: _selectedModel!.toString(),
        vehicleType: _selectedType!.toString(),
      );
      //Get.to(() => const Home());
      if (widget.parent == "menu") {
        var response = await userDatasourceImpl.insertVehicleRemote(
            vehicle: vehicle, context: context);
        if (response is int) {
          await EasyLoading.showInfo("vehículo añadido");
          Get.to(() => const Home());
        }
      } else {
        Get.to(() => PasswordRegister(user: widget.user, vehicle: vehicle));
      }
    } else {
      return ErrorOrAdviceHandler.showErrorAlert(
          context, "Error en alguno de los campos", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: FutureBuilder<Map<String, dynamic>>(
                future: fetchOptions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Error al cargar future de vehicle options: ${snapshot.error}'));
                  } else {
                    options = snapshot.data!;
                    return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.arrow_back)),
                                    Text(
                                      " Registra un vehículo",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(fontSize: 20),
                                    )
                                  ]),
                                  const SizedBox(height: 30.0),
                                  InputField(
                                    controller: licensePlateController,
                                    textInput: 'Placa',
                                    textInputType: TextInputType.text,
                                    obscure: false,
                                    icon: const Icon(null),
                                  ),
                                  const SizedBox(height: 16.0),
                                  SizedBox(
                                      height: 70,
                                      child: DropdownButtonFormField<int>(
                                        value: _selectedType,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedType = value;
                                          });
                                        },
                                        //dropdownColor: ColorManager.secondaryColor,
                                        items: (options['types']
                                                as List<dynamic>)
                                            .map<DropdownMenuItem<int>>((type) {
                                          return DropdownMenuItem<int>(
                                            value: type['id_vehicle_type'],
                                            child: Text(type['name'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall),
                                          );
                                        }).toList(),
                                        decoration: myInputDecoration(
                                            "Tipo de vehículo"),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Por favor seleccione el tipo';
                                          }
                                          return null;
                                        },
                                      )),
                                  const SizedBox(height: 16.0),
                                  SizedBox(
                                      height: 70,
                                      child: DropdownButtonFormField<int>(
                                        value: _selectedBrand,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedBrand = value;
                                          });
                                        },
                                        items:
                                            (options['brands'] as List<dynamic>)
                                                .map<DropdownMenuItem<int>>(
                                                    (brand) {
                                          return DropdownMenuItem<int>(
                                            value: brand['id_vehicle_brand'],
                                            child: Text(brand['name'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall),
                                          );
                                        }).toList(),
                                        decoration: myInputDecoration("Marca"),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Por favor seleccione la marca';
                                          }
                                          return null;
                                        },
                                      )),
                                  SizedBox(height: 16.0),
                                  SizedBox(
                                      height: 70,
                                      child: DropdownButtonFormField<int>(
                                        value: _selectedModel,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedModel = value;
                                          });
                                        },
                                        items:
                                            (options['models'] as List<dynamic>)
                                                .map<DropdownMenuItem<int>>(
                                                    (model) {
                                          return DropdownMenuItem<int>(
                                            value: model['id_vehicle_model'],
                                            child: Text(model['name'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall),
                                          );
                                        }).toList(),
                                        decoration: myInputDecoration("Modelo"),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Por favor seleccione el modelo';
                                          }
                                          return null;
                                        },
                                      )),
                                  SizedBox(height: 16.0),
                                  SizedBox(
                                      height: 70,
                                      child: DropdownButtonFormField<int>(
                                        value: _selectedColor,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedColor = value;
                                          });
                                        },
                                        items:
                                            (options['colors'] as List<dynamic>)
                                                .map<DropdownMenuItem<int>>(
                                                    (color) {
                                          return DropdownMenuItem<int>(
                                            value: color['id_vehicle_color'],
                                            child: Text(color['name'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall),
                                          );
                                        }).toList(),
                                        decoration: myInputDecoration("Color"),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Por favor seleccione el color';
                                          }
                                          return null;
                                        },
                                      )),
                                  const SizedBox(height: 80),
                                  Container(
                                      alignment: Alignment.center,
                                      child: MainButton(
                                          text: 'Continuar',
                                          large: true,
                                          buttonColor: ColorManager.fourthColor,
                                          onPressed: () {
                                            submitForm(context);
                                          })),
                                ])));
                  }
                })));
  }
}
