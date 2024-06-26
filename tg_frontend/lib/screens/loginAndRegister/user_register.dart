import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/errors.dart/exceptions.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/screens/loginAndRegister/password_register.dart';
import 'package:tg_frontend/screens/loginAndRegister/vehicle_register.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/utils/date_Formatter.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/main_button.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key, required this.userType});
  final int userType;
  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  UserDatasourceMethods userDatasourceImpl =
      Environment.sl.get<UserDatasourceMethods>();
  final _formKey = GlobalKey<FormState>();
  late User user;
  late List<dynamic>? cities;
  int? _selectedCity;
  String? _selectedDate;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController identifactionController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //  _fetchCities();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: DateTime(1950), lastDate: DateTime(2009));
    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormatter().dateFormatedToSend(pickedDate);
        dateController.text =
            DateFormatter().dateFormatedTextControllerComplete(pickedDate);
        print(dateController.text);
      });
    }
  }

  Future<List<dynamic>?> _fetchCities(BuildContext context) async {
    final List<dynamic>? jsonResponse =
        await userDatasourceImpl.getUserCitiesRemote(context);
    if (jsonResponse != null) {
      cities = jsonResponse;
    } else {
      print('Error al obtener la lista de ciudades desde la API.');
    }
    return cities;
  }

  dynamic submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate() && dateController.text != "") {
      //if (true)

      user = User(
        idUser: 0,
        identityDocument: identifactionController.text,
        phoneNumber: phoneController.text,
        firstName: nameController.text,
        lastName: lastNameController.text,
        birthDate: _selectedDate,
        residenceCity: _selectedCity.toString(),
        type: widget.userType,
        email: emailController.text,
        password: "",
        isActive: 1,
      );
      widget.userType == 2
          ? Get.to(() => VehicleRegister(
                user: user,
                parent: "register",
              ))
          : Get.to(() => PasswordRegister(user: user));
    } else {
      return ErrorOrAdviceHandler.showErrorAlert(
          context, "Error en alguno de los campos", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: FutureBuilder<List<dynamic>?>(
            future: _fetchCities(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.fourthColor,
                  ),
                );
              } else if (snapshot.hasError || snapshot.data == null) {
                return Center(
                  child: Text(
                    'Se produjo un error, intente mas tarde',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      overflow: TextOverflow.ellipsis,
                      color: ColorManager.fourthColor,
                    ),
                    maxLines: 3,
                  ),
                );
              } else {
                cities = snapshot.data!;
                return SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 16),
                            Row(children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back)),
                              const SizedBox(width: 5),
                              Text(
                                " Regístrate",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontSize: 22),
                              )
                            ]),
                            SizedBox(
                                height: MediaQuery.of(context).size.width / 4),
                            InputField(
                              controller: nameController,
                              textInput: 'Nombre',
                              textInputType: TextInputType.text,
                              obscure: false,
                              icon: const Icon(Icons.person),
                            ),
                            const SizedBox(height: 15),
                            InputField(
                              controller: lastNameController,
                              textInput: 'Apellido',
                              textInputType: TextInputType.text,
                              obscure: false,
                              icon: const Icon(Icons.person),
                            ),
                            const SizedBox(height: 15),
                            InputField(
                              controller: identifactionController,
                              textInputType: TextInputType.number,
                              obscure: false,
                              textInput: 'Documento de identificación',
                              icon: const Icon(Icons.insert_drive_file),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              obscureText: false,
                              style:
                                  TextStyle(color: ColorManager.primaryColor),
                              //autofocus: true,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 9.0, horizontal: 7.0),
                                  hintText: 'Fecha de Nacimiento',
                                  hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 71, 71, 71),
                                      fontSize: 12),
                                  filled: true,
                                  suffixIcon: IconButton(
                                      onPressed: () => _selectDate(context),
                                      icon: const Icon(
                                        Icons.calendar_month_outlined,
                                        size: 20,
                                      )),
                                  fillColor: ColorManager.thirdColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                  labelStyle: const TextStyle(
                                      color: Color.fromARGB(255, 32, 32, 32),
                                      fontSize: 18),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: ColorManager.primaryColor,
                                      width: 2.0,
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 15),
                            InputField(
                              controller: phoneController,
                              textInput: 'Celular',
                              textInputType: TextInputType.number,
                              obscure: false,
                              icon: const Icon(Icons.phone),
                            ),
                            const SizedBox(height: 15),
                            InputField(
                              controller: emailController,
                              textInput: 'Correo Insitucional',
                              textInputType: TextInputType.text,
                              obscure: false,
                              icon: const Icon(Icons.mail),
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<int>(
                              value: _selectedCity,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCity = value;
                                });
                              },
                              items: cities!.map<DropdownMenuItem<int>>((city) {
                                return DropdownMenuItem<int>(
                                  value: city['id_city'] as int,
                                  child: Text(
                                    city['name'] as String,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                  labelText: 'Ciudad',
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 14)),
                              validator: (value) {
                                if (value == null) {
                                  return 'Por favor seleccione la ciudad';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 60),
                            Container(
                              alignment: Alignment.center,
                              child: MainButton(
                                  text: 'Continuar',
                                  large: true,
                                  buttonColor: ColorManager.fourthColor,
                                  onPressed: () {
                                    submitForm(context);
                                  }),
                            ),
                          ]),
                    ));
              }
            }));
  }
}
