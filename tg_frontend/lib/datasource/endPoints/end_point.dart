class EndPoints {
  final String baseUrl = "https://uv-tg-backend.vercel.app";
  final String getUserLogged = "/users/me/";
  final String getUserAuth = '/auth/token/login/';
  final String getAndPostUser = '/users/';
  final String getTravel = "/trip/";
  final String postTravel = "/driver/trip/add/";
  final String patchPassengerTrip = "/passenger-trip/{id_passenger_trip}/";
  final String postPassengerTrip = "/passenger-trip/";
  final String getVehicleOptions = "/vehicle/registration/";
  //final String postDriverVehicleAdd = "/driver/vehicle/add/";
  final String postVehicle = "/driver/vehicle/add/";
  final String getCities = "/city/";
}
