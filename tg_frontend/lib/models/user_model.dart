import 'dart:ffi';
import 'dart:html';

import 'package:intl/intl.dart';

class User {
  final String identityDocument;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final String residenceCity;
  //final String type;
  final String idUser;
  final String email;
  final Bool isActive;

  User({
    required this.identityDocument,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.residenceCity,
    //required this.type,
    required this.idUser,
    required this.email,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['id_user']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      birthDate: json['date_of_birth'] != null
          ? DateTime.parse('${json['date_of_birth']}')
          : null,
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      identityDocument: json['identity_document']?.toString() ?? '',
      residenceCity: json['residence_city']?.toString() ?? '',
      isActive: json['is_active'] ?? true,
      //type: json['type']?.toString() ?? '',
      // registrationDate: json['registration_date'] != null
      //     ? DateTime.parse('${json['registration_date']}')
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      "email": email,
      "phone_number": phoneNumber,
      "first_name": firstName,
      "last_name": lastName,
      "identity_document": identityDocument,
      "birth_date": (birthDate as DateTime).toIso8601String(),
      "residence_city": residenceCity,
      "is_active": isActive,
      //"type": type,
    };
  }

  String get birthDateFormatted {
    return birthDate != null ? DateFormat('yyyy-MM-dd').format(birthDate!) : '';
  }

  // String get registrationDateFormatted {
  //   return registrationDate != null
  //       ? DateFormat('yyyy-MM-dd').format(registrationDate!)
  //       : '';
  // }
}
