// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/errors.dart/exceptions.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/services/auth_services.dart';

abstract class TravelDatasource {
  Future<List<String>> getMapSuggestions(
      {required String address, required BuildContext context});
  Future<LatLng> getMapCoordinates(
      {required String address, required BuildContext context});
  Future<String> getTextDirection(
      {required double lat,
      required double long,
      required BuildContext context});
  //Future<void> insertTravelsLocal({required List<Travel> travels, required BuildContext context});
  Future<void> insertTravelRemote(
      {required Travel travel, required BuildContext context});
  Future<void> deleteTravelRemote(
      {required String travelId, required BuildContext context});
  // Future<void> getTravelLocal({required int travelId, String filter, required BuildContext context});
  Future<List<Travel>> getTravelsRemote(
      {required String finalEndPoint,
      Map<String, dynamic> searchData,
      required BuildContext context});
  Future<List<Travel>> getTravelSuggestions(
      {required Map<String, dynamic> searchData,
      required BuildContext context});
  Future<Response<Map<String, dynamic>>?> getTravelDetails(
      {required int travelId,
      required String finalUrl,
      required BuildContext context});
  // Future<int?> updateTravelLocal(
  //     {required int travelId,
  //     required List<String> fields,
  //     required List<String> values, required BuildContext context});
  Future<int?> updateTravelRemote(
      {required int travelId,
      required List<String> fields,
      required List<String> values,
      required BuildContext context});
  Future<List<Passenger>> getPassangersRemote(
      {required int travelId, required BuildContext context});
  Future<int> insertPassengerRemote(
      {required Passenger passenger, required BuildContext context});
  Future<int> updatePassengerRemote(
      {required int passengerTripId,
      required bool valueConfirmed,
      required BuildContext context});
  Future<int> deleteSpotPassengerRemote(
      {required int tripId, required BuildContext context});
  Future<int> deleteSpotDriverRemote(
      {required int idPassengerTrip, required BuildContext context});
}

class TravelDatasourceMethods implements TravelDatasource {
  Dio dio = Dio();
  DatabaseProvider databaseProvider = DatabaseProvider.db;
  late Database database;
  final _endPoints = EndPoints();
  String? token;
  late User user = Environment.sl.get<User>();
  String apiKey =
      'pk.eyJ1Ijoic2FybWFyaWUiLCJhIjoiY2xwYm15eTRrMGZyYjJtcGJ1bnJ0Y3hpciJ9.v5mHXrC66zG4x-dgZDdLSA';
  String serverErrorString = "Lo sentimos, tenemos un error en el servidor; ";

  TravelDatasourceMethods() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    database = await databaseProvider.database;
    token = await AuthStorage().getToken();
  }

  @override
  Future<List<String>> getMapSuggestions(
      {required String address, required BuildContext context}) async {
    String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$address.json?access_token=$apiKey&country=CO&region=Valle%20del%20Cauca';
    List<String> suggestions = [];

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> features = data['features'];
      suggestions =
          features.map((feature) => feature['place_name'] as String).toList();
    } else {
      ErrorOrAdviceHandler.showErrorAlert(
          context,
          "lo sentimos estamos teniendo un problema para obtener las direcciones, intenta más tarde",
          true);
    }
    return suggestions;
  }

  @override
  Future<LatLng> getMapCoordinates(
      {required String address, required BuildContext context}) async {
    String url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$address.json?access_token=$apiKey";
    LatLng coordinates = const LatLng(0.0, 0.0);
    //List<String> suggestions = [];

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<double> coordinatesValues =
          List<double>.from(data['features'][0]['geometry']['coordinates']);
      coordinates = LatLng(coordinatesValues[1], coordinatesValues[0]);
      return coordinates;
    } else {
      ErrorOrAdviceHandler.showErrorAlert(
          context,
          "lo sentimos estamos teniendo un problema para obtener las direcciones, intenta más tarde",
          true);
      return coordinates;
    }
  }

  @override
  Future<String> getTextDirection(
      {required double lat,
      required double long,
      required BuildContext context}) async {
    String placeName = "";
    String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$long,$lat.json?access_token=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final features = jsonResponse['features'];
      if (features != null && features.isNotEmpty) {
        final firstFeature = features[0];
        placeName = firstFeature['place_name'];
        return placeName;
      } else {
        return 'No se encontraron resultados';
      }
    } else {
      ErrorOrAdviceHandler.showErrorAlert(context,
          "Estamos teniendo un inconveniente, intenta más tarde", true);
    }
    return placeName;
  }

  // @override
  // Future<void> insertTravelsLocal({required List<Travel> travels, context}) async {
  //   var i = 0;
  //   Travel currentTravel;
  //   try {
  //     while (i < travels.length) {
  //       currentTravel = travels[i];
  //       await database.insert(LocalDB.tbTravel, {
  //         LocalDB.idTravel: currentTravel.id,
  //         LocalDB.arrivalPoint: currentTravel.arrivalPoint,
  //         LocalDB.startingPoint: currentTravel.startingPoint,
  //         LocalDB.date: currentTravel.date,
  //         LocalDB.hour: currentTravel.hour,
  //         LocalDB.driver: currentTravel.driver,
  //         LocalDB.price: currentTravel.price,
  //         LocalDB.seats: currentTravel.seats,
  //         LocalDB.currentTrip: currentTravel.currentTrip,
  //       }).timeout(const Duration(seconds: 120));
  //       i++;
  //     }
  //   } catch (e) {
  //     print('Error al insertar un viaje Local' + e.toString());
  //   }
  // }

  @override
  Future<int> insertTravelRemote(
      {required Travel travel, required BuildContext context}) async {
    int sent = 0;
    try {
      String? token = await AuthStorage().getToken();
      Map<String, dynamic> jsonTravel = travel.toJson();
      dio.options.headers['Authorization'] = 'Token $token';
      Response response = await dio
          .post(_endPoints.baseUrl + _endPoints.postTravel, data: jsonTravel);
      if (response.statusCode == 200 || response.statusCode == 201) {
        sent++;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return sent;
  }

  @override
  Future<int> deleteTravelRemote(
      {required String travelId, required BuildContext context}) async {
    int sent = 0;
    String url =
        "${_endPoints.baseUrl}${_endPoints.deleteTRavelDriver}$travelId/";
    try {
      dio.options.headers['Authorization'] = 'Token $token';
      Response response = await dio.delete(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        sent++;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return sent;
  }

  // @override
  // Future<Travel?> getTravelLocal(
  //     {required int travelId, String? filter, required BuildContext context}) async {
  //   try {
  //     List<Map<String, dynamic>> travelMaps = await database.query(
  //       LocalDB.tbTravel,
  //       where: '${LocalDB.idTravel} = ?',
  //       whereArgs: [travelId],
  //     ).timeout(const Duration(seconds: 300));

  //     if (travelMaps.isNotEmpty) {
  //       return Travel.fromJson(travelMaps.first);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  @override
  Future<List<Travel>> getTravelsRemote(
      {required String finalEndPoint,
      Map<String, dynamic>? searchData,
      required BuildContext context}) async {
    String? token = await AuthStorage().getToken();
    List<Travel> travelList = [];
    Response<dynamic> response;

    try {
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.get(
        _endPoints.baseUrl + finalEndPoint,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (finalEndPoint == _endPoints.getGeneralTravels) {
          for (var data in response.data) {
            Travel travel = Travel.fromJson(data);
            travelList.add(travel);
          }
        } else {
          for (var data in response.data["results"]) {
            Travel travel = Travel.fromJson(data);
            travelList.add(travel);
          }
        }
        // travel = Travel.fromJson(response.data);
        // travelList.add(travel);
        //insertTravelsLocal(travels: travelList);
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return travelList;
  }

  @override
  Future<List<Travel>> getTravelSuggestions(
      {required Map<String, dynamic>? searchData,
      required BuildContext context}) async {
    List<Travel> travelList = [];
    Response<dynamic> response;

    try {
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(
          _endPoints.baseUrl + _endPoints.getGeneralTravels,
          data: searchData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        for (var data in response.data[0]["results"]) {
          Travel travel = Travel.fromJson(data);
          travelList.add(travel);
        }
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }

    return travelList;
  }

  // @override
  // Future<int?> updateTravelLocal(
  //     {required int travelId,
  //     required List<String> fields,
  //     required List<String> values, required BuildContext context}) async {
  //   int request = 0;
  //   try {
  //     Map<String, Object?> updates = {};
  //     for (var i = 0; i < fields.length; i++) {
  //       updates[fields[i]] = values[i];
  //     }
  //     request = await database.update(LocalDB.tbTravel, updates, where: """
  //         ${LocalDB.idTravel} = ?
  //         """, whereArgs: [travelId]).timeout(const Duration(seconds: 300));
  //   } catch (error) {
  //     print('Error al realizar updateTRavelLocal: $error');
  //   }
  //   return request;
  // }

  @override
  Future<int> updateTravelRemote(
      {required int travelId,
      required List<String> fields,
      required List<String> values,
      required BuildContext context}) async {
    int request = 0;

    return request;
  }

  @override
  Future<List<Passenger>> getPassangersRemote(
      {required int travelId, required BuildContext context}) async {
    List<Passenger> passengersList = [];
    Response<dynamic> response;
    String? token = await AuthStorage().getToken();

    try {
      //Map<String, dynamic> parameters = {"id_trip": travelId.toString()};
      dio.options.headers['Authorization'] = 'Token $token';
      String url =
          _endPoints.baseUrl + _endPoints.getTravel + travelId.toString();
      response = await dio.get(
        url,
        //  queryParameters: parameters,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> passengersData = response.data['passengers'];

        for (var passengerData in passengersData) {
          var passengerDetails = passengerData['passenger'];
          Passenger passenger = Passenger.fromJson({
            'id_passenger_trip': passengerData['id_passenger_trip'],
            'is_confirmed': passengerData['is_confirmed'],
            'pickup_point_lat': passengerData['pickup_point']['lat'],
            'pickup_point_long': passengerData['pickup_point']['long'],
            'phone_number': passengerDetails['phone_number'],
            'first_name': passengerDetails['first_name'],
            'last_name': passengerDetails['last_name'],
            'trip': travelId,
            'seats': passengerData['seats'],
          });
          passengersList.add(passenger);
        }
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return passengersList;
  }

  @override
  Future<int> updatePassengerRemote(
      {required int passengerTripId,
      required bool valueConfirmed,
      required BuildContext context}) async {
    Map<String, dynamic> data = {"is_confirmed": valueConfirmed};
    String url =
        "${_endPoints.baseUrl}${_endPoints.patchPassengerTrip}${passengerTripId.toString()}/";
    int sent = 0;
    try {
      dio.options.headers['Authorization'] = 'Token $token';
      Response response = await dio.patch(url, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        sent++;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return sent;
  }

  @override
  Future<int> insertPassengerRemote(
      {required Passenger passenger, required BuildContext context}) async {
    int sent = 0;
    try {
      Map<String, dynamic> jsonPassengerTrip = passenger.toJson();
      dio.options.headers['Authorization'] = 'Token $token';
      Response response = await dio.post(
          _endPoints.baseUrl + _endPoints.postPassengerTripBook,
          data: jsonPassengerTrip);
      if (response.statusCode == 200 || response.statusCode == 201) {
        sent++;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return sent;
  }

  @override
  Future<int> deleteSpotPassengerRemote(
      {required int tripId, required BuildContext context}) async {
    String url =
        "${_endPoints.baseUrl}${_endPoints.deleteSpotTripPassenger}${tripId.toString()}/";
    int sent = 0;
    try {
      dio.options.headers['Authorization'] = 'Token $token';
      Response response = await dio.delete(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        sent++;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return sent;
  }

  @override
  Future<int> deleteSpotDriverRemote(
      {required int idPassengerTrip, required BuildContext context}) async {
    String url =
        "${_endPoints.baseUrl}${_endPoints.deleteSpotTripDriver}${idPassengerTrip.toString()}/";
    int sent = 0;
    try {
      dio.options.headers['Authorization'] = 'Token $token';
      Response response = await dio.delete(url);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 203 ||
          response.statusCode == 204) {
        sent = 1;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return sent;
  }

  @override
  Future<Response<Map<String, dynamic>>?> getTravelDetails(
      {required int travelId,
      required String finalUrl,
      required BuildContext context}) async {
    Response<Map<String, dynamic>>? response;
    try {
      dio.options.headers['Authorization'] = 'Token $token';
      String url = "${_endPoints.baseUrl}$finalUrl${travelId.toString()}/";

      response = await dio.get(
        url,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return response;
  }
}
