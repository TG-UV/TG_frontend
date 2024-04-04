class User {
  final String identityDocument;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String? birthDate;
  final String residenceCity;
  final int type;
  final int idUser;
  final String email;
  final int isActive;
  String password;

  User({
    required this.identityDocument,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.residenceCity,
    required this.type,
    required this.idUser,
    required this.email,
    required this.isActive,
    required this.password
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['id_user']as int? ?? 0,
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      birthDate: json['date_of_birth']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      identityDocument: json['identity_document']?.toString() ?? '',
      residenceCity: json['residence_city']?.toString() ?? '',
      isActive: json['is_active'] == true ? 1 : 0,
      type: json['type']as int? ?? 0,
      password: ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "phone_number": phoneNumber,
      "first_name": firstName,
      "last_name": lastName,
      "identity_document": identityDocument,
      "date_of_birth": birthDate,
      "residence_city": int.parse(residenceCity),
      //"is_active": isActive == 1 ? true : false,
      "password": password,
      "type" : type,
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
