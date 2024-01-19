import 'package:intl/intl.dart';

class Passenger {
  final String idPassenger;
  final String email;
  final String phoneNumber;
  final DateTime birthDate;
  final String firstName;
  final String lastName;
  final DateTime registrationDate;

  Passenger({
    required this.idPassenger,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.firstName,
    required this.lastName,
    required this.registrationDate,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      idPassenger: json['id_passenger']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      birthDate: json['birth_date'] != null
          ? DateTime.parse('${json['birth_date']}')
          : DateTime.now(),
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      registrationDate: json['registration_date'] != null
          ? DateTime.parse('${json['registration_date']}')
          : DateTime.now(),
    );
  }

  String get birthDateFormatted {
    return DateFormat('yyyy-MM-dd').format(birthDate);
  }

  String get registrationDateFormatted {
    return DateFormat('yyyy-MM-dd').format(registrationDate);
  }
}
