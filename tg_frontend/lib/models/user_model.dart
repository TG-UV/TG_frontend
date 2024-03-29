class User {
  final String identityDocument;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String? birthDate;
  final String residenceCity;
  //final String type;
  final String idUser;
  final String email;
  final int isActive;

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
      birthDate: json['date_of_birth']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      identityDocument: json['identity_document']?.toString() ?? '',
      residenceCity: json['residence_city']?.toString() ?? '',
      isActive: json['is_active'] == true ? 1 : 0,
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
      "birth_date": birthDate,
      "residence_city": residenceCity,
      "is_active": isActive == 1 ? true : false,
      //"type": type,
    };
  }

  // String get birthDateFormatted {
  //   return birthDate != null ? DateFormat('yyyy-MM-dd').format(birthDate!) : '';
  // }

  // String get registrationDateFormatted {
  //   return registrationDate != null
  //       ? DateFormat('yyyy-MM-dd').format(registrationDate!)
  //       : '';
  // }
}
