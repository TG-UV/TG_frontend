import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/screens/loginAndRegister/vehicle_register.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VehicleManagment extends StatefulWidget {
  const VehicleManagment({super.key, required this.user, required this.parent});
  final User user;
  final String parent;

  @override
  State<VehicleManagment> createState() => _VehicleManagmentState();
}

class _VehicleManagmentState extends State<VehicleManagment> {
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> options;
  List<Vehicle> driverVehicles = [];
  Vehicle? vehicleSelected;
  bool isVisible = false;

  int? _selectedType;
  int? _selectedBrand;
  int? _selectedModel;
  int? _selectedColor;

  final TextEditingController licensePlateController = TextEditingController();
  final ValueNotifier<int?> typeController = ValueNotifier<int?>(null);
  final ValueNotifier<int?> brandController = ValueNotifier<int?>(null);
  final ValueNotifier<int?> modelController = ValueNotifier<int?>(null);
  final ValueNotifier<int?> colorController = ValueNotifier<int?>(null);

  late Vehicle vehicle;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
    _fetchOptions();
  }

  void _fetchVehicles() async {
    final List<Vehicle>? listResponse =
        await userDatasourceImpl.getVehiclesDriver();
    if (listResponse != null) {
      setState(() {
        driverVehicles = listResponse;
      });
    } else {
      throw Exception('Error al llamar los vehículos, intente de nuevo');
    }
  }

  void _fetchOptions() async {
    final Map<String, dynamic>? listResponse =
        await userDatasourceImpl.getVehicleOptionsRemote();

    if (listResponse != null) {
      options = listResponse;
      setState(() {});
    } else {
      throw Exception(
          'Error al llamar la opciones de vehiculo, intente de nuevo');
    }
  }

  InputDecoration myInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.secondaryColor, width: 0.5),
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
      vehicle = Vehicle(
        idVehicle: vehicleSelected!.idVehicle,
        licensePlate: licensePlateController.text,
        vehicleBrand: _selectedBrand!.toString(),
        vehicleColor: _selectedColor!.toString(),
        vehicleModel: _selectedModel!.toString(),
        vehicleType: _selectedType!.toString(),
      );
      if (widget.parent == "menu") {
        var response = await userDatasourceImpl.updateVehicelRemote(
            vehicleId: vehicle.idVehicle, vehicle: vehicle);
        if (response is int) {
          await EasyLoading.showInfo("vehículo añadido");
          _fetchVehicles();
        } else {
          await EasyLoading.showInfo("Intentelo mas tarde");
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back)),
                        Text(
                          " Administra tus vehículos",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 20),
                        )
                      ]),
                      const SizedBox(height: 30),
                      !isVisible
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                  MainButton(
                                      text: "Modificar",
                                      large: false,
                                      buttonColor: ColorManager.thirdColor,
                                      onPressed: () {
                                        setState(() {
                                          isVisible = true;
                                        });
                                      }),
                                  MainButton(
                                      text: "Añadir",
                                      large: false,
                                      buttonColor: ColorManager.fourthColor,
                                      onPressed: () => Get.to(() =>
                                          VehicleRegister(
                                              user: widget.user,
                                              parent: widget.parent))),
                                ])
                          : Visibility(
                              visible: isVisible,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Modifica uno de tus vehículos",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                        height: 70,
                                        child: DropdownButtonFormField<Vehicle>(
                                          value: vehicleSelected,
                                          onChanged: (Vehicle? newValue) {
                                            setState(() {
                                              vehicleSelected = newValue!;
                                              licensePlateController.text =
                                                  vehicleSelected!.licensePlate;
                                            });
                                          },
                                          items: driverVehicles
                                              .map((Vehicle vehiculo) {
                                            return DropdownMenuItem<Vehicle>(
                                              value: vehiculo,
                                              child: Text(
                                                  '${vehiculo.licensePlate} ${vehiculo.vehicleBrand}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall),
                                            );
                                          }).toList(),
                                          decoration:
                                              myInputDecoration(" Vehículo"),
                                        )),
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
                                              .map<DropdownMenuItem<int>>(
                                                  (type) {
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
                                          items: (options['brands']
                                                  as List<dynamic>)
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
                                          decoration:
                                              myInputDecoration("Marca"),
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Por favor seleccione la marca';
                                            }
                                            return null;
                                          },
                                        )),
                                    const SizedBox(height: 16.0),
                                    SizedBox(
                                        height: 70,
                                        child: DropdownButtonFormField<int>(
                                          value: _selectedModel,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedModel = value;
                                            });
                                          },
                                          items: (options['models']
                                                  as List<dynamic>)
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
                                          decoration:
                                              myInputDecoration("Modelo"),
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
                                          items: (options['colors']
                                                  as List<dynamic>)
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
                                          decoration:
                                              myInputDecoration("Color"),
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
                                            text: 'Confirmar',
                                            buttonColor:
                                                ColorManager.fourthColor,
                                            large: true,
                                            onPressed: () {
                                              submitForm(context);
                                            })),
                                  ]))
                    ]))));
  }
}
