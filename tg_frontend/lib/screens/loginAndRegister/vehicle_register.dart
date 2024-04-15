import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/models/vehicleOptions_model.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/screens/loginAndRegister/password_register.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
        await userDatasourceImpl.getVehicleOptionsRemote();

    if (listResponse != null) {
      return listResponse;
    } else {
      throw Exception(
          'Error al llamar la opciones de vehiculo, intente de nuevo');
    }
  }

  void submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      //List<Travel> travelList = [];
      vehicle = Vehicle(
        idVehicle: 0,
        licensePlate: licensePlateController.text,
        vehicleBrand: _selectedBrand!,
        vehicleColor: _selectedColor!,
        vehicleModel: _selectedModel!,
        vehicleType: _selectedType!,
        // owner: widget.user.idUser
      );
      //userDatasourceImpl.insertUserRemote(user: user);
      //Get.to(() => const Home());
      if (widget.parent == "menu") {
        int response =
            await userDatasourceImpl.insertVehicleRemote(vehicle: vehicle);
        response != 0
            ? await EasyLoading.showInfo("vehículo añadido")
            : await EasyLoading.showInfo("Intentelo mas tarde");
      } else {
        Get.to(() => PasswordRegister(user: widget.user, vehicle: vehicle));
      }
    } else {
      AlertDialog(
          title: const Text("Error"),
          content: const SingleChildScrollView(
              child: ListBody(
            children: <Widget>[
              Text("Faltan campos por completar."),
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
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  InputField(
                                    controller: licensePlateController,
                                    textInput: 'Placa',
                                    textInputType: TextInputType.text,
                                    obscure: false,
                                    icon: const Icon(null),
                                  ),
                                  const SizedBox(height: 16.0),
                                  DropdownButtonFormField<int>(
                                    value: _selectedType,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedType = value;
                                      });
                                    },
                                    items: (options['types'] as List<dynamic>)
                                        .map<DropdownMenuItem<int>>((type) {
                                      return DropdownMenuItem<int>(
                                        value: type['id_vehicle_type'],
                                        child: Text(type['name']),
                                      );
                                    }).toList(),
                                    decoration:
                                        InputDecoration(labelText: 'Tipo'),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Por favor seleccione el tipo';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  DropdownButtonFormField<int>(
                                    value: _selectedBrand,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedBrand = value;
                                      });
                                    },
                                    items: (options['brands'] as List<dynamic>)
                                        .map<DropdownMenuItem<int>>((brand) {
                                      return DropdownMenuItem<int>(
                                        value: brand['id_vehicle_brand'],
                                        child: Text(brand['name']),
                                      );
                                    }).toList(),
                                    decoration:
                                        InputDecoration(labelText: 'Marca'),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Por favor seleccione la marca';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  DropdownButtonFormField<int>(
                                    value: _selectedModel,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedModel = value;
                                      });
                                    },
                                    items: (options['models'] as List<dynamic>)
                                        .map<DropdownMenuItem<int>>((model) {
                                      return DropdownMenuItem<int>(
                                        value: model['id_vehicle_model'],
                                        child: Text(model['name']),
                                      );
                                    }).toList(),
                                    decoration:
                                        InputDecoration(labelText: 'Modelo'),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Por favor seleccione el modelo';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  DropdownButtonFormField<int>(
                                    value: _selectedColor,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedColor = value;
                                      });
                                    },
                                    items: (options['colors'] as List<dynamic>)
                                        .map<DropdownMenuItem<int>>((color) {
                                      return DropdownMenuItem<int>(
                                        value: color['id_vehicle_color'],
                                        child: Text(color['name']),
                                      );
                                    }).toList(),
                                    decoration:
                                        InputDecoration(labelText: 'Color'),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Por favor seleccione el color';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 80),
                                  Container(
                                      alignment: Alignment.center,
                                      child: LargeButton(
                                          text: 'Continuar',
                                          large: true,
                                          onPressed: () {
                                            submitForm(context);
                                          })),
                                ])));
                  }
                })));
    // return Scaffold(
    //     body: Container(
    //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //         alignment: Alignment.center,
    //         child: Stack(children: [
    //           Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               const SizedBox(height: 150),
    //               Container(
    //                 alignment: Alignment.center,
    //                 child: Text(
    //                   "Añade los datos de tu Vehículo",
    //                   textAlign: TextAlign.center,
    //                   style: Theme.of(context).textTheme.titleLarge,
    //                 ),
    //               ),
    //               const SizedBox(height: 35),
    //               InputField(
    //                 controller: vehicleTypeController,
    //                 textInput: 'Tipo de vehículo',
    //                 textInputType: TextInputType.text,
    //                 obscure: false,
    //                 icon: const Icon(Icons.motorcycle),
    //               ),
    //               const SizedBox(height: 15),
    //               InputField(
    //                 controller: colorController,
    //                 textInput: 'Color',
    //                 textInputType: TextInputType.text,
    //                 obscure: false,
    //                 icon: const Icon(null),
    //               ),
    //               const SizedBox(height: 15),
    //               InputField(
    //                 controller: licensePlateController,
    //                 textInput: 'Placa',
    //                 textInputType: TextInputType.text,
    //                 obscure: false,
    //                 icon: const Icon(null),
    //               ),
    //               const SizedBox(height: 15),
    //               InputField(
    //                 controller: brandController,
    //                 textInput: 'Marca',
    //                 textInputType: TextInputType.text,
    //                 obscure: false,
    //                 icon: const Icon(null),
    //               ),
    //               const SizedBox(height: 15),
    //               InputField(
    //                 controller: modelController,
    //                 textInput: 'Modelo',
    //                 textInputType: TextInputType.text,
    //                 obscure: false,
    //                 icon: const Icon(null),
    //               ),

    //               const SizedBox(height: 80),
    //               Container(
    //                   alignment: Alignment.center,
    //                   child: LargeButton(
    //                       text: 'Continuar',
    //                       large: true,
    //                       onPressed: () {
    //                         Get.to(() => PasswordRegister(user: widget.user));
    //                       })),

    //               // child: const GlobalButton(text: 'Iniciar sesión'),
    //             ],
    //           ),
    //           Positioned(
    //               top: 30.0,
    //               left: 5.0,
    //               child: IconButton(
    //                   onPressed: () {
    //                     Navigator.pop(context);
    //                   },
    //                   icon: const Icon(Icons.arrow_back)))
    //         ])));
  }
}
