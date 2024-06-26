class EndPoints {
  final String baseUrl = "https://uv-tg-backend.vercel.app";

  final String getUserLogged = "/users/me/";
  final String getUserAuth = '/auth/token/login/';
  final String getUserLogout = "/auth/token/logout/";
  final String getAndPostUser = '/users/';
  final String getVehicleOptions = "/vehicle/registration/";
  final String postVehicle = "/driver/vehicle/add/";
  final String getCities = "/users/registration/";
  final String postUserActivation = "/users/activation/";
  final String postUserReSendActivation = "/users/resend_activation/";
  final String postSetPassword = "/users/set_password/";
  final String postReSetPassword = "/users/reset_password/";

  final String getVehiclesDriver = "/driver/vehicle/";
  final String putVehicleUpdateDriver = "/driver/vehicle/update/";
  final String getTravel = "/driver/trip/";
  final String postTravel = "/driver/trip/add/";
  final String getTravelHistoryDriver = "/driver/trip/history/";
  final String getTravelPlannedDriver = "/driver/trip/planned/";
  final String deleteTRavelDriver = "/driver/trip/delete/";

  final String deleteSpotTripDriver = "/driver/passenger-trip/delete/";
  final String deleteSpotTripPassenger = "/passenger/trip/delete/";
  final String patchPassengerTrip = "/passenger-trip/";
  final String postPassengerTripBook = "/passenger/trip/book/";

  final String getTravelDetailsPassenger = "/passenger/trip/";
  final String getTravelAssociatedPassenger = "/passenger/trip/associated/";
  final String getTravelPlannedPassenger = "/passenger/trip/planned/";
  final String getTravelHistoryPassenger = "/passenger/trip/history/";

  //final String getGeneralTravels = "/trip/";
  final String getGeneralTravels = "/passenger/search/";
}
