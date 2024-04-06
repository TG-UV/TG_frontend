import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/screens/loginAndRegister/password_register.dart';
import 'package:tg_frontend/screens/loginAndRegister/vehicle_register.dart';
import 'package:tg_frontend/widgets/input_field.dart';
import 'package:tg_frontend/widgets/large_button.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/device/environment.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' show  DatePicker;
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as dt_picker;
import 'package:intl/intl.dart';





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
  DateTime? _selectedDate;

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
    _fetchCities();
  }
  
 Future<void> _selectDate(BuildContext context) async {
  final DateTime? selectedTime = await showDatePicker(
    context: context,
    firstDate: DateTime(1950),
    lastDate: DateTime(2010)
  );
  if(selectedTime != null){
   
          _selectedDate = selectedTime;


  }
  }

  Future<List<dynamic>?> _fetchCities() async {
    final List<dynamic>? jsonResponse =
        await userDatasourceImpl.getUserCitiesRemote();
    if (jsonResponse != null) {
      
              cities = jsonResponse;
     
    } else {
      print('Error al obtener la lista de ciudades desde la API.');
    }
    return cities;
  }

  void submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      
      user = User(
        idUser: 0,
        identityDocument: identifactionController.text,
        phoneNumber: phoneController.text,
        firstName: nameController.text,
        lastName: lastNameController.text,
        birthDate: dateController.text,
        residenceCity: _selectedCity.toString(),
        type: widget.userType,
        email: emailController.text,
        password: "",
        isActive: 1,
      );
      widget.userType == 2
          ? Get.to(() => VehicleRegister(user: user))
          : Get.to(() => PasswordRegister(user: user));
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
        body: 
     FutureBuilder<List<dynamic>?>(
        future: _fetchCities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error al cargar ciudades: ${snapshot.error}'));
          } else {
            cities = snapshot.data!;
            return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey, // Aquí se usa la clave _formKey
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Regístrate",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),

                        const SizedBox(height: 50),
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
                          textInputType: TextInputType.text,
                          obscure: false,
                          textInput: 'Documento de identificación',
                          icon: const Icon(Icons.insert_drive_file),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
      onTap: () {
    // Tu función asíncrona aquí, por ejemplo:
    _selectDate(context); 
      // Lógica asíncrona aquí
    },
      child: InputField(
                textInput: 'Fecha de Nacimiento',
                textInputType: TextInputType.text,
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? dateController.text= DateFormat('yyyy-MM-dd').format(_selectedDate!)
                      : '',
                ),
                obscure: false,
                icon: const Icon(Icons.calendar_month),
                
                
              ),
            ),
                     
                        const SizedBox(height: 15),
                        InputField(
                          controller: phoneController,
                          textInput: 'Celular',
                          textInputType: TextInputType.text,
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
                          items: cities!
                              .map<DropdownMenuItem<int>>((city) {
                            return DropdownMenuItem<int>(
                              value: city['id_city'] as int,
                              child: Text(city['name'] as String),
                            );
                          }).toList(),
                          decoration:
                              const InputDecoration(labelText: 'Ciudad'),
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor seleccione la ciudad';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 100),
                        Container(
                          alignment: Alignment.center,
                          child: LargeButton(
                              text: 'Continuar',
                              large: true,
                              onPressed: () {
                                submitForm(context);
                              }),
                        ),
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
                  ],
                )));}}));
  }
}
