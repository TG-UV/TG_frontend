class LocalDB {
  static const String tbUser = "user";
  static const String identityDocument = "identity_document";
  static const String phoneNumber = "phone_number";
  static const String firstName = "first_name";
  static const String lastName = "last_name";
  static const String birthDate = "date_of_birth";
  static const String residenceCity = "residence_city";
  static const String type = "type";
  static const String idUser = "id_user";
  static const String email = "email";
  //static const String registrationDate = "registro";

  static const String tableInsertUser = """
      CREATE TABLE IF NOT EXISTS $tbUser(
          $identityDocument VARCHAR(200),
          $phoneNumber VARCHAR(200),
          $firstName VARCHAR(200),
          $lastName VARCHAR(200),
          $birthDate VARCHAR(200),
          $residenceCity INTEGER,
          $type INTEGER,
          $idUser INTEGER,
          $email VARCHAR(200)
          );
        """;
}
