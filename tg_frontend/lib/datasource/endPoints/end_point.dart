class EndPoints {
  final String baseUrl = "https://uv-tg-backend.vercel.app";
  final String getUserLogged = "/users/me/";
  final String getUserAuth = '/auth/token/login/';
  final String getAndPostUser = '/users/';
  final String getTravel = "/driver/trip/";
  final String getTravelPlannedDriver = "/driver/trip/planned/";
  final String getTravelHistoryDriver = "/driver/trip/history/";
  final String postTravel = "/driver/trip/add/";
  final String patchPassengerTrip = "/passenger-trip/";
  final String postPassengerTrip = "/passenger-trip/";
  final String getTravelDetailsPassenger = "/passenger/trip/";
  final String getTravelAssociatedPassenger = "/passenger/trip/associated/";
  final String getTravelPlannedPassenger = "/driver/trip/planned//passenger/trip/planned/";
  final String getTravelHistoryPassenger = "/passenger/trip/history/";

  final String getVehicleOptions = "/vehicle/registration/";
  //final String postDriverVehicleAdd = "/driver/vehicle/add/";
  final String postVehicle = "/driver/vehicle/add/";
  final String getCities = "/city/";
  final String getGeneralTravels = "/trip/";

}
