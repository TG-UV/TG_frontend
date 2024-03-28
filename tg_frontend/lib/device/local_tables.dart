class LocalDB {
  static const String tbUser = "user";
  static const String identityDocument = "identity_document";
  static const String phoneNumber = "phone_number";
  static const String firstName = "first_name";
  static const String lastName = "last_name";
  static const String birthDate = "date_of_birth";
  static const String residenceCity = "residence_city";
  static const String isActive = "is_active";
  static const String idUser = "id_user";
  static const String email = "email";
  //static const String registrationDate = "registro";

  static const String tbTravel = "travel";
  static const String idTravel = "id_trip";
  static const String arrivalPoint = "arrival_point";
  static const String startingPoint = "starting_point";
  static const String driver = "driver";
  static const String price = "fare";
  static const String seats = "seats";
  static const String hour = "start_time";
  static const String date = "start_date";
  static const String currentTrip = "current_trip";

  static const String idPassenger = "id_passenger";
  static const String passengerEmail = "email";

  static const String tableInsertUser = """
      CREATE TABLE IF NOT EXISTS $tbUser(
          $identityDocument VARCHAR(200),
          $phoneNumber VARCHAR(200),
          $firstName VARCHAR(200),
          $lastName VARCHAR(200),
          $birthDate VARCHAR(200),
          $residenceCity INTEGER,
          $isActive INTEGER,
          $idUser INTEGER,
          $email VARCHAR(200)
          );
        """;

  static const String tableInsertTravel = """
      CREATE TABLE IF NOT EXISTS $tbTravel(
        $idTravel INTEGER PRIMARY KEY AUTOINCREMENT
        $arrivalPoint VARCHAR(15),
        $startingPoint VARCHAR(30),
        $hour TIMESTAMP,
        $date DATE,
        $driver INTEGER,
        $seats INTEGER,
        $price VARCHAR(200),
        $currentTrip VARCHAR(200)
        );
      """;
}
