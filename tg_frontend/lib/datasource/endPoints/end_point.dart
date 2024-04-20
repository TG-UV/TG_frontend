class EndPoints {
  final String baseUrl = "https://uv-tg-backend.vercel.app";

  final String getUserLogged = "/users/me/";
  final String getUserAuth = '/auth/token/login/';
  final String getAndPostUser = '/users/';
  final String getVehicleOptions = "/vehicle/registration/";
  final String postVehicle = "/driver/vehicle/add/";
  final String getCities = "/city/";
  final String postUserActivation = "/users/activation/";

  final String getVehiclesDriver = "/driver/vehicle/";
  final String putVehicleUpdateDriver = "/driver/vehicle/update/";
  final String getTravel = "/driver/trip/";
  final String postTravel = "/driver/trip/add/";
  final String getTravelHistoryDriver = "/driver/trip/history/";
  final String getTravelPlannedDriver = "/driver/trip/planned/";
  final String deleteTRavelDriver = "/trip/";

  final String patchPassengerTrip = "/passenger-trip/";
  final String postPassengerTrip = "/passenger-trip/";

  final String getTravelDetailsPassenger = "/passenger/trip/";
  final String getTravelAssociatedPassenger = "/passenger/trip/associated/";
  final String getTravelPlannedPassenger = "/passenger/trip/planned/";
  final String getTravelHistoryPassenger = "/passenger/trip/history/";

  final String getGeneralTravels = "/trip/";
}
